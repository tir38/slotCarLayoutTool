function [track] = addOrDeletePiece(nextPiece, track) 
% Jason Atwood
% 03/29/2013
%
% description:
%  Adds a single piece to the track or deletes the last piece. Can add
%  straights or turns.
%
% inputs:
% - track       : [n x 8] matrix contains prior track pieces
% - nextPiece   : int, describing which action to take (1-6)
%
% outputs:
% track         : [n+1 x 8] matrix contains prior track pieces plus one new one
%
% subfuctions:
% - addTurnPiece by JWA

% load global variables
global laneWidth
global tightDiameter
global tightSegments
global wideDiameter
global wideSegments
global straightLength
global laneSpacing
global tightTheta
global wideTheta

[numberOfPieces, ~] = size(track);
lastPiece = track(numberOfPieces, :);
    
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

    otherwise
        % do nothing
end