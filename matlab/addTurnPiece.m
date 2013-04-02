function [track] = addTurnPiece(track, diameter, theta, lastPiece, leftOrRight)
% Jason Atwood
% 03/29/2013
%
% description:
%  adds a single turn piece to the 'track' matrix, can do left/right
%  tight/wide turns.
%
% inputs:
% - track       : [n x 8] matrix contains prior track pieces
% - diameter    : turn diameter in inches
% - theta       : arc angle of an individual piece
% - lastPiece   : the last row of track (yes I could compute that in here,
%                   since I have 'track', but its all the same)
% - leftOrRight : string, 'left' or 'right' describes which direction the
%                   turn will go. relative to prior piece
%
% outputs:
% track   : [n+1 x 8] matrix contains prior track pieces plus one new one
%
% subfuctions:
% - none

global laneWid

lastHeading = lastPiece(7);

currentTrackPiece = []; % to store the 8 values for this piece

% iteration direction changes based on turning left or right
if strcmp(leftOrRight, 'left')
    iteratorStart = -1;
    iteratorEnd = 1;
    increment = 1;
    
elseif strcmp(leftOrRight, 'right')
    iteratorStart = 1;
    iteratorEnd = -1;
    increment = -1;
end

for i = iteratorStart : increment : iteratorEnd % for each lane
    radius = (diameter/2) + (i*laneWidth);
    chord = abs(2*sin(theta/2)* radius);

    parallelDistance        = chord * cos(theta/2);
    perpendicularDistance   = chord * sin(theta/2);

    deltaX = parallelDistance*cos(lastHeading) + perpendicularDistance*cos((pi/2) + lastHeading);
    deltaY = parallelDistance*sin(lastHeading) + perpendicularDistance*sin((pi/2) + lastHeading);

    if strcmp(leftOrRight, 'left')
        x = lastPiece(2*i+3) + deltaX; % specific to turning left
        y = lastPiece(2*i+4) + deltaY;
    elseif strcmp(leftOrRight, 'right')
        x = lastPiece(-2*i+3) + deltaX; % specific to turning right
        y = lastPiece(-2*i+4) + deltaY;
    end

    currentTrackPiece = [currentTrackPiece, x, y]; % "pop" x,y onto currentTrackPiece
end

newHeading = lastHeading + theta;
currentTrackPiece = [currentTrackPiece, newHeading, 0]; % don't set the track type here....set it when going back up to main function
track = [track; currentTrackPiece]; % "pop" onto list of track pieces