function [] = slotCarTrackLayout ()
% Jason Atwood
% 03/29/2013
%
% description:
% This is the head function for this library. See the README.md file for
% usage of this method.
%
% inputs:
% - none
%
% outputs:
% - none
%
% subfuctions:
% - addOrDeletePiece by JWA
% - addTurnPiece by JWA
% - getLeftRightLaneDistances by JWA
% - insertHere by JWA
% - pdist2 by Piotr Dollar
% - plotArc by JWA
% - rebuild by JWA
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
% "lane". Heading is the resultant track heading, in radians. East is 
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
global tightTheta
global wideTheta

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
    
    %% DO ACTUAL TASK
    nextPiece = input('========================\n----- MAIN MENU -----\n========================\nPlease select an option:\nAdd Piece:\n[1] straight\n[2] left turn, small radius\n[3] right turn, small radius\n[4] left turn, large radius\n[5] right turn, large radius\n\n\Edit track:\n[6] delete last piece\n[7] insert or delete piece\n[8] rotate entire track\n\n[9] save track\n[10] exit\n========================\n');
    clc

    if ~isnumeric(nextPiece) || isempty(nextPiece) % confirm that input is valid
        nextPiece = -1;
    end
    
    switch nextPiece
        
        case {1, 2, 3, 4, 5, 6} % =====================================  add or delete a piece
            track = addOrDeletePiece(nextPiece, track);
        
        case 7
            track = insertHere(track);
            
    
        case 8  % =====================================  rotate entire track
            inputString = sprintf('Select new heading (in degrees). Current heading is %.2f degrees\n', track(1,7)*180/pi);
            rotateTrackBy = input(inputString)
            rotateTrackBy = rotateTrackBy*pi/180 % convert from degrees to rads
            
            % update left and right lane start points
            track(1,1) = -laneWidth * sin(rotateTrackBy); % left x
            track(1,2) =  laneWidth * cos(rotateTrackBy); % left y
            track(1,5) =  laneWidth * sin(rotateTrackBy); % right x
            track(1,6) = -laneWidth * cos(rotateTrackBy); % right y
            track(1,7) = rotateTrackBy;                   % heading
            
            track = rebuild(track);
            
        case 9 % =====================================  save current track
            [fileName, pathName] = uiputfile('*.png','Save Track As...');
            
            if ~ischar(fileName) || isempty(fileName) % confirm that filename is valid
                fprintf('ERROR, invalid file name. Try again\n')
            else
                saveas(myFig, fileName);
                fprintf('Save complete.\n')
            end
            
        case 10 % =====================================  exit program
            fprintf('Thanks for using.....goodbye.\n')
            break
    
        otherwise
            fprintf('Not a valid entry.\n')
            
    end
    
    % update plot
    updatePlot(track)
    axis off % i have to do this ever time
end
