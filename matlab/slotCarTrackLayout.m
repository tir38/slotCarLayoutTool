function [] = slotCarTrackLayout ()
% Jason Atwood
% 03/29/2013
%
% description:
%
% inputs:
% - none
%
% outputs:
% - none
%
% subfuctions:
% - addTurnPiece by JWA
% - getLeftRightLaneDistances by JWA
% - plotArc by JWA
% - round2 by Robert Bemis
% - updatePlot by JWA
%
% notes:
% Track variables:
% A track is defined by an array of eight variables arranged into an (n x 8)
% matrix, where n is the number of track pieces. Each row corresponds to one 
% track piece. Each piece is defined by its eight variables:
%
% - left_x
% - left_y
% - center_x
% - center_y
% - right_X
% - right_y
% - heading
% - pieceType
%
% Each x/y pair represents the end point (in global coordinates) of that
% "lane". Heading is the resultant track heading, in radians. To-the-right is 
% heading = 0. It increases CCW. The final variable describes the pieceType as a number:
%
% 0 = no piece (used for start)
% 1 = straight
% 2 = left turn, tight radius
% 3 = right turn, tight radius
% 4 = left turn, wide radius
% 5 = right turn, wide radius
%
% Lane designation:
% The concept of "left" lane and "right" lane is a bit ambiguous. However,
% I am using them to keep track of the two lanes that the cars travel on.
% 
% Geometric computation of turns:
% First find the parallel and perpendicular distances when adding a turn,
% then translate those two distances into global x,y based on prior
% heading.
%
%
clear all
close all
clc
commandwindow
warning on verbose
%% ========== code ==========
%% setup
global laneWidth
global tightDiameter
global tightSegments
global wideDiameter
global wideSegments
global straightLength
global laneSpacing

tolerance = 0.001; % tolerance when comparing floats

% user-set track parameters
laneSpacing     = 3.5; % inches, distance between left and right lanes
straightLength  = 12.0; % inches

tightDiameter   = 28-(laneSpacing*2); % inches, centerline turn diameter
tightSegments   = 6; % number of segments that create 360 degrees turn

wideDiameter    = 42-(laneSpacing*2); % inches, centerline turn diameter
wideSegments    = 12; % number of segments that create 360 degree turn

scaleFactor     = 32; % scale factor for the model cars and track (1:32)

% track parameters derived from other parameters
laneWidth       = laneSpacing/2; % inches, distance between lane center and track center.
tightTheta      = 2*pi/tightSegments; % radians, the arc angle of an individual piece
wideTheta       = 2*pi/wideSegments; % radians, the arc angle of an individual piece

% initialize track
track = [0, laneWidth, 0, 0, 0, -laneWidth, 0, 0];

% initialize figure
myFig = figure();
set(myFig, 'Position', [0,0,700,700])
axis off 


while 1~=0
    %% get info on the current end of the track
    [numberOfPieces, ~] = size(track);
    lastPiece = track(numberOfPieces, :);
    
    [numberOfStraights, ~]   = size(find(track(:,8) == 1));
    [numberOfTightTurns, ~] = size([find(track(:,8) == 2); find(track(:,8) ==3)]);
    [numberOfWideTurns, ~]  = size([find(track(:,8) == 4); find(track(:,8) ==5)]);
    centerLineDistance = (numberOfStraights * straightLength) + (numberOfTightTurns * pi*tightDiameter/tightSegments) + (numberOfWideTurns * pi*wideDiameter/wideSegments);
    centerLineDistanceMiles = centerLineDistance*scaleFactor/12/5280;
    
    % get left and right lane distances
    [leftDistance, rightDistance] = getLeftRightLaneDistances(track(:,8));
    ratio = leftDistance/rightDistance;
    difference = abs(leftDistance - rightDistance);
        
    % get bounding box around the track
    minX = min([min(track(:,1)), min(track(:,3)), min(track(:,5))]);
    maxX = max([max(track(:,1)), max(track(:,3)), max(track(:,5))]);
 
    minY = min([min(track(:,2)), min(track(:,4)), min(track(:,6))]);
    maxY = max([max(track(:,2)), max(track(:,4)), max(track(:,6))]);
    
    bbWidth  = maxX - minX;
    bbHeight = maxY - minY;
    
    % convert current heading to [0 - 360] degrees for display
    displayHeading = (180/pi)*lastPiece(7); %  convert do degrees
    displayHeading = rem(displayHeading, 360); % reduce to single rotation
    if (abs(displayHeading - 360)) < tolerance % simple fix so that function doesn't display 360
        displayHeading = 0;
    end
    
    % display stuff for user
    figureString1 = sprintf('Currently have %i pieces in place: \n\t%i straights\t%i tight turns\t%i wide turns.\n',numberOfPieces-1, numberOfStraights, numberOfTightTurns, numberOfWideTurns);
    figureString2 = sprintf('\nTrack length = %.3f inches; at scale thats %.3f miles\n',centerLineDistance, centerLineDistanceMiles);
    figureString3 = sprintf('\nCurrent center is [%.3f, %.3f] with heading = %.3f degrees.\n',lastPiece(3), lastPiece(4), displayHeading);
    if ratio < 1
        figureString4 = sprintf('\nBlue lane has advantage by %.2f inches.\n',difference);
    elseif ratio > 1
        figureString4 = sprintf('\nRed lane has advantage by %.2f inches.\n',difference);
    else
        figureString4 = sprintf('\nRed and Blue lanes are equal distance.\n');
    end
    figureString5 = sprintf('\nTrack will take up an area [%.2f by %.2f] inches.\n', bbWidth, bbHeight);
    
    title(strcat(figureString1, figureString2, figureString3, figureString4, figureString5));
    
    %% add piece to track
    nextPiece = input('=================\nPlease select an option:\n[1] straight\n[2] left turn, small radius\n[3] right turn, small radius\n[4] left turn, large radius\n[5] right turn, large radius\n[6] delete last piece\n[7] save track\n[8] exit\n=================\n');
    clc

    switch nextPiece
        case 1 % ===================================== straight piece
            track = [track;...
                        lastPiece(1) + straightLength*cos(lastPiece(7)), ...    % left_x
                        lastPiece(2) + straightLength*sin(lastPiece(7)), ...    % left_y
                        lastPiece(3) + straightLength*cos(lastPiece(7)), ...    % center_x
                        lastPiece(4) + straightLength*sin(lastPiece(7)), ...    % center_y
                        lastPiece(5) + straightLength*cos(lastPiece(7)), ...    % left_y
                        lastPiece(6) + straightLength*sin(lastPiece(7)), ...    % right_y
                        lastPiece(7), ....                                      % heading didn't change
                        1];                                                      % straight piece

                    
        case 2 % ===================================== left turn, tight radius
            diameter = tightDiameter;
            theta = tightTheta;
            leftOrRight = 'left';
            
            track = addTurnPiece(track, diameter, theta, lastPiece, leftOrRight);
            [currentTrackSize, ~] = size(track);
            track(currentTrackSize, 8) = nextPiece; % set track type here
             
            
        case 3 % ===================================== right turn, tight radius
            diameter = tightDiameter;
            theta = -1*tightTheta;
            leftOrRight = 'right';
            
            track = addTurnPiece(track, diameter, theta, lastPiece, leftOrRight);
            [currentTrackSize, ~] = size(track);
            track(currentTrackSize, 8) = nextPiece; % set track type here

            
        case 4  % ===================================== left turn, wide radius
            diameter = wideDiameter;
            theta = wideTheta;
            leftOrRight = 'left';
            
            track = addTurnPiece(track, diameter, theta, lastPiece, leftOrRight);
            [currentTrackSize, ~] = size(track);
            track(currentTrackSize, 8) = nextPiece; % set track type here
       
            
        case 5 % ===================================== right turn, wide radius
            diameter = wideDiameter;
            theta = -1* wideTheta;
            leftOrRight = 'right';
            
            track = addTurnPiece(track, diameter, theta, lastPiece, leftOrRight);
            [currentTrackSize, ~] = size(track);
            track(currentTrackSize, 8) = nextPiece; % set track type here
            
            
        case 6 % ===================================== delete last piece
            if numberOfPieces >= 2
                track = track(1:numberOfPieces-1,:); % remove last piece
            end
            

        case 7 % =====================================  save current track
            [fileName, pathName] = uiputfile('*.png','Save Track As...');
            
            if ~ischar(fileName) || isempty(fileName) % confirm that filename is valid
                fprintf('ERROR, invalid file name. Try again\n')
            else
                saveas(myFig, fileName);
                fprintf('Save complete.\n')
            end
            
        case 8 % =====================================  exit program
            fprintf('Thanks for using.....goodbye.\n')
            break
            
            
        otherwise
            fprintf('Not a valid entry.\n')
            
    end
    
    % attempt to reduce error propogation
    track(end:7) = round2(track(end:7), 1/(2*pi)); % round to nearest whole degree
 
    % update plot
    updatePlot(track)
    axis off % i have to do this ever time

end
