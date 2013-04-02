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
%% setup
% track parameters
laneSpacing     = 3.5; % inches, distance between left and right lanes
straightLength  = 12.0; % inches
global laneWidth
laneWidth       = laneSpacing/2; % inches, distance between lane center and track center.

global tightDiameter
tightDiameter   = 28-(laneSpacing*2); % inches, turn diameter
tightSegments   = 6; % number of segments that create 360 degrees turn
tightTheta      = 2*pi/tightSegments; % radians, the arc angle of an individual piece

global wideDiameter
wideDiameter    = 42-(laneSpacing*2); % inches, turn diameter
wideSegments    = 12; % number of segments that create 360 degree turn
wideTheta       = 2*pi/wideSegments; % radians, the arc angle of an individual piece

tolerance       = 0.001; % inches, for this script, for comparing two floating point numbers

% initialize track
track = [0, laneWidth, 0, 0, 0, -laneWidth, 0, 0];

% initialize figure
myFig = figure();
set(myFig, 'Position', [0,0,500,500])

while 1~=0
    %% get info on the current end of the track
    [numberOfPieces, ~] = size(track);
    lastPiece = track(numberOfPieces, :);
    
    [numberOfStraights, ~]   = size(find(track(:,8) == 1));
    [numberOfTightTurns, ~] = size([find(track(:,8) == 2); find(track(:,8) ==3)]);
    [numberOfWideTurns, ~]  = size([find(track(:,8) == 4); find(track(:,8) ==5)]);
    
    fprintf('Currently have %i pieces in place: %i straights, %i tight turns, and %i wide turns.\n',numberOfPieces-1, numberOfStraights, numberOfTightTurns, numberOfWideTurns)

    centerLineDistance = (numberOfStraights * straightLength) + (numberOfTightTurns * pi*tightDiameter/tightSegments) + (numberOfWideTurns * pi*wideDiameter/wideSegments);
    fprintf('Track length is currently %.3f inches.\n',centerLineDistance)
    
    % display current center point and heading
    fprintf('Current center is [%.3f, %.3f] with heading = %.3f.\n',lastPiece(3), lastPiece(4), lastPiece(7))
        
    
    
    %% add piece to track
    nextPiece = input('======= Please select next element [1-5], delete last piece [6], or exit [7] =================\n');
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
            
            
        case 7 % =====================================  exit program
            fprintf('Thanks for using.....goodbye.\n')
            break
            
        otherwise
            fprintf('Not a valid entry.\n')
    end
 
    % update plot
    updatePlot(track)
end
