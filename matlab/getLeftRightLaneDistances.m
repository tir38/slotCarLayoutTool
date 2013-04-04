function [leftDistance, rightDistance] = getLeftRightLaneDistances(pieceList)
% Jason Atwood
% 03/29/2013
%
% description:
%  computes the total distance of each lane, in inches
%
% inputs:
% - pieceList : [n x 1] matrix containing the description of each
%                   piece of the track (1-5)
%
% outputs:
% - leftDistance  : double, distance of left lane, in inches
% - rightDistance : double, distance of right lane, in inches

% load global variables
global laneWidth
global tightDiameter
global tightSegments
global wideDiameter
global wideSegments
global straightLength
global laneSpacing

% compute distance traveled in turns by inside and outside lines
insideTightTurnDistance  = 2*pi*(tightDiameter/2 - laneWidth/2) * (1/tightSegments); % inches
outsideTightTurnDistance = 2*pi*(tightDiameter/2 + laneWidth/2) * (1/tightSegments); % inches

insideWideTurnDistance  = 2*pi*(wideDiameter/2 - laneWidth/2) * (1/wideSegments); % inches
outsideWideTurnDistance = 2*pi*(wideDiameter/2 + laneWidth/2) * (1/wideSegments); % inches

% get numbers of each piece type
[numberOfStraights, ~]          = size(find(pieceList == 1));
[numberOfLeftTightTurns, ~]     = size(find(pieceList == 2));
[numberOfRightTightTurns, ~]    = size(find(pieceList == 3));
[numberOfLeftWideTurns, ~]      = size(find(pieceList == 4));
[numberOfRightWideTurns, ~]     = size(find(pieceList == 5));

% compute distances
leftDistance =  numberOfStraights* straightLength...
                + numberOfLeftTightTurns *  insideTightTurnDistance...
                + numberOfRightTightTurns * outsideTightTurnDistance...
                + numberOfLeftWideTurns *   insideWideTurnDistance...
                + numberOfRightWideTurns *  outsideWideTurnDistance;
            
rightDistance = numberOfStraights* straightLength...
                + numberOfLeftTightTurns *  outsideTightTurnDistance...
                + numberOfRightTightTurns * insideTightTurnDistance...
                + numberOfLeftWideTurns *   outsideWideTurnDistance...
                + numberOfRightWideTurns *  insideWideTurnDistance;
