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
% - none
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
% track parameters
laneSpacing     = 3.5; % inches, distance between left and right lanes
straightLength  = 12.0; % inches
global laneWidth
laneWidth       = laneSpacing/2; % inches, distance between lane center and track center.

global tightDiameter
tightDiameter   = 28-(laneSpacing*2) % inches, turn diameter
tightSegments   = 6; % number of segments that create 360 degrees turn
tightTheta      = 2*pi/tightSegments; % radians, the arc angle of an individual piece

global wideDiameter
wideDiameter    = 42-(laneSpacing*2) % inches, turn diameter
wideSegments    = 12; % number of segments that create 360 degree turn
wideTheta       = 2*pi/wideSegments; % radians, the arc angle of an individual piece

tolerance       = 0.001; % inches, for this script, for comparing two floating point numbers

% initialize track
track = [0, laneWidth, 0, 0, 0, -laneWidth, 0, 0];

myFig = figure();
set(myFig, 'Position', [0,0,500,500])

while 1~=0
    
    nextPiece = input('======= Please select next element [1-5], delete last piece [6], or exit [7] =================\n');
    clc
    % get info on the curren end of the track
    [numberOfPieces, ~] = size(track)
    numberOfPieces = numberOfPieces -1
    lastPiece = track(numberOfPieces+1, :);
    
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
            currentTrackPiece = []; % to store the 8 values for this piece
            
            for i = -1:1:1 % for each track
                radius = (tightDiameter/2) + (i*laneWidth);
                chord = 2*sin(tightTheta/2)* radius;
                
                parallelDistance        = chord * cos(tightTheta/2);
                perpendicularDistance   = chord * sin(tightTheta/2);
                
                deltaX = parallelDistance*cos(lastPiece(7)) + perpendicularDistance*cos((pi/2) + lastPiece(7));
                deltaY = parallelDistance*sin(lastPiece(7)) + perpendicularDistance*sin((pi/2) + lastPiece(7));
                
                x = lastPiece(2*i+3) + deltaX; % specific to turning left
                y = lastPiece(2*i+4) + deltaY;
                
                currentTrackPiece = [currentTrackPiece, x, y]; % "pop" x,y onto currentTrackPiece
            end
            
            newHeading = lastPiece(7) + tightTheta;
            currentTrackPiece = [currentTrackPiece, newHeading, 2];
            track = [track; currentTrackPiece]; % "pop" onto list of track pieces
             
        case 3 % ===================================== right turn, tight radius
            currentTrackPiece = []; % to store the 8 values for this piece
            
            for i = 1:-1:-1 % for each track
                radius = (tightDiameter/2) + (i*laneWidth);
                chord = 2*sin(tightTheta/2)* radius;
                
                parallelDistance        = chord * cos(-tightTheta/2);
                perpendicularDistance   = chord * sin(-tightTheta/2);
                
                deltaX = parallelDistance*cos(lastPiece(7)) + perpendicularDistance*cos((pi/2) + lastPiece(7));
                deltaY = parallelDistance*sin(lastPiece(7)) + perpendicularDistance*sin((pi/2) + lastPiece(7));
                
                x = lastPiece(-2*i+3) + deltaX; % specific to turning right
                y = lastPiece(-2*i+4) + deltaY;
                
                currentTrackPiece = [currentTrackPiece, x, y]; % "pop" x,y onto currentTrackPiece
            end
            
            newHeading = lastPiece(7) - tightTheta;
            currentTrackPiece = [currentTrackPiece, newHeading, 3];
            track = [track; currentTrackPiece]; % "pop" onto list of track pieces
            
        case 4  % ===================================== left turn, wide radius
            
            currentTrackPiece = []; % to store the 8 values for this piece
            
            for i = -1:1:1 % for each track
                radius = (wideDiameter/2) + (i*laneWidth);
                chord = 2*sin(wideTheta/2)* radius;
                
                parallelDistance        = chord * cos(wideTheta/2);
                perpendicularDistance   = chord * sin(wideTheta/2);
                
                deltaX = parallelDistance*cos(lastPiece(7)) + perpendicularDistance*cos((pi/2) + lastPiece(7));
                deltaY = parallelDistance*sin(lastPiece(7)) + perpendicularDistance*sin((pi/2) + lastPiece(7));
                
                x = lastPiece(2*i+3) + deltaX; % specific to turning left
                y = lastPiece(2*i+4) + deltaY;
                
                currentTrackPiece = [currentTrackPiece, x, y]; % "pop" x,y onto currentTrackPiece
            end
            
            newHeading = lastPiece(7) + wideTheta;
            currentTrackPiece = [currentTrackPiece, newHeading, 4];
            track = [track; currentTrackPiece]; % "pop" onto list of track pieces
            
            
        case 5 % ===================================== right turn, wide radius
            currentTrackPiece = []; % to store the 8 values for this piece
            
            for i = 1:-1:-1 % for each track
                radius = (wideDiameter/2) + (i*laneWidth);
                chord = 2*sin(wideTheta/2)* radius;
                
                parallelDistance        = chord * cos(-wideTheta/2);
                perpendicularDistance   = chord * sin(-wideTheta/2);
                
                deltaX = parallelDistance*cos(lastPiece(7)) + perpendicularDistance*cos((pi/2) + lastPiece(7));
                deltaY = parallelDistance*sin(lastPiece(7)) + perpendicularDistance*sin((pi/2) + lastPiece(7));
                
                x = lastPiece(-2*i+3) + deltaX; % specific to turning right
                y = lastPiece(-2*i+4) + deltaY;
                
                currentTrackPiece = [currentTrackPiece, x, y]; % "pop" x,y onto currentTrackPiece
            end
            
            newHeading = lastPiece(7) - wideTheta;
            currentTrackPiece = [currentTrackPiece, newHeading, 5];
            track = [track; currentTrackPiece]; % "pop" onto list of track pieces
            
        case 6
            if numberOfPieces >= 1
                track = track(1:numberOfPieces,:); % remove last piece
            end
            
        case 7
            fprintf('Thanks for using.....goodbye.\n')
            break
            
        otherwise
            fprintf('Not a valid entry.\n')
    end
    
%     % validate addition of new piece:
%         % confirm that lanes are still the same distance appart
%         currentTrackPiece = track(numberOfPieces+1,:);
%         checkLaneSpacing = ((abs(currentTrackPiece(1)- currentTrackPiece(5)))^2  + (abs(currentTrackPiece(2) - currentTrackPiece(6)))^2)^0.5;
%         if (abs(checkLaneSpacing - laneSpacing) > tolerance)
%             fprintf('ERROR: something went wrong adding that piece.\n')
%         end
 
    % update plot
    updatePlot(track)
end
