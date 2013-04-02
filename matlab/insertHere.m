function[track] = insertHere(track)
% Jason Atwood
% 04/01/2013
%
% description:
%  inserts a single turn piece to the 'track' matrix, can do left/right
%  tight/wide turns.
%
% inputs:
% - track       : [n x 8] matrix contains prior track pieces
%
% outputs:
% track   : [n+1 x 8] matrix contains prior track pieces plus one new one
%
% subfuctions:
% - pdist2 by Piotr Dollar

% get input from user
fprintf('In figure window, select point to insert piece.\n')
myInput = ginput(1);
    
[numberOfPieces, ~] = size(track);

% concatenate all track points into [3n x 2] matrix for easy search
trackPoints = [track(:,1:2); track(:,3:4); track(:,5:6)];
size(trackPoints);

%find nearest point
[output] = pdist2(trackPoints, myInput, 'euclidean');
[~, indices] = min(output);
nearestPoint = trackPoints(indices(1),:);

% find which piece contains that point
nearestPiece = rem(indices(1), numberOfPieces);

% visualize which point and piece was selected
hold on
plot(track(nearestPiece, 1), track(nearestPiece, 2), 'go')
hold on
plot(track(nearestPiece, 3), track(nearestPiece, 4), 'go')
hold on
plot(track(nearestPiece, 5), track(nearestPiece, 6), 'go')
hold on

% break the track at that point into two segments startSegment, endSegment
startSegment = track(1:nearestPiece, :); % start Segment
endSegment = track(nearestPiece+1:end, 8); % I only care about the piece type. I am going to recompute the point locations later.

% insert the piece I want]
insertPiece = input('=================\nWhat do you want to insert [1-5], delete[6], or cancel[7]?:\n[1] straight\n[2] left turn, small radius\n[3] right turn, small radius\n[4] left turn, large radius\n[5] right turn, large radius\n=================\n');
if insertPiece == 7
    clc
    fprintf('Canceling insert.\n')
    return
end

track = addOrDeletePiece(insertPiece, startSegment);

% put the end segment back on the end
[sizeEndSegment, ~] = size(endSegment);
for i = 1:sizeEndSegment
    nextPiece = endSegment(i);
    track = addOrDeletePiece(nextPiece, track);
end
clc