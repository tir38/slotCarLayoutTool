function [rebuiltTrack] = rebuild(track)
% Jason Atwood
% 04/01/2013
%
% description:
%  rebuilds the track piece by piece. basically for propgating any changes
%  to inside pieces. If for example, I change the 10th piece. I will need
%  to rebuild pieces 11, 12, .... to the end. So by rebuilding the entire
%  track. I propogate any and all internal changes. In this way I can make
%  individual changes to elements and everything will be fine. I can also
%  use this to rebuild changes to the starting condition, for example
%  rotating the entire track.
%
% inputs:
% - track       : [n x 8] matrix contains prior track pieces
%
% outputs:
% track   : [n+1 x 8] matrix contains prior track pieces plus one new one
%

[numberOfPieces, ~] = size(track);
rebuiltTrack = track(1,:) % add starting conditions
pieceTypes   = track(:,8)

% put the end segment back on the end
for i = 1:numberOfPieces-1
    nextPiece = pieceTypes(i+1);
    rebuiltTrack = addOrDeletePiece(nextPiece, rebuiltTrack);
end
clc