function [leftDistance, rightDistance] = getLeftRightLaneDistances(pieceList)

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
