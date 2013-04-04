function [] = updatePlot(track)
% Jason Atwood
% 03/29/2013
%
% description:
%  does all plotting of the track
%
% inputs:
% - track : [n x 8] matrix contains all track pieces
%
% outputs:
% none
%
% subfuctions:
% - plotArc by JWA
% 
% notes:
% this method assumes that a figure is already open and selected

% load global variables
global tightDiameter
global wideDiameter
global laneWidth

clf % clear current figure
[numberOfPieces, ~] = size(track);

% iterate through each piece
for i = 1:numberOfPieces
    
    pieceType = track(i,8);
    
    % set radius
    if pieceType == 2 | pieceType == 3 
        radius = tightDiameter/2;
    elseif pieceType == 4 | pieceType == 5
        radius = wideDiameter/2;
    end
   
    switch pieceType
        case 1 % plot a set of straigth lines
            plot([track(i-1,1),track(i,1)], [track(i-1,2), track(i,2)], 'b') % plot left track
            hold on
            plot([track(i-1,3),track(i,3)], [track(i-1,4), track(i,4)], 'k') % plot center track
            hold on
            plot([track(i-1,5),track(i,5)], [track(i-1,6), track(i,6)], 'r') % plot right track
            
        case {2,4} % plot CCW arc for left turns     
            [xunit, yunit] = plotArc([track(i-1,1),track(i-1,2)], [track(i,1),track(i,2)], radius-laneWidth, 0);
            plot(xunit, yunit,'b');
            hold on
            
            [xunit, yunit] = plotArc([track(i-1,3),track(i-1,4)], [track(i,3),track(i,4)], radius, 0);
            plot(xunit, yunit,'k');;
            hold on
            
            [xunit, yunit] = plotArc([track(i-1,5),track(i-1,6)], [track(i,5),track(i,6)], radius + laneWidth, 0);
            plot(xunit, yunit,'r');
            
            hold on
            
        case {3,5} % plot CW arc for right turn
             [xunit, yunit] = plotArc([track(i-1,1),track(i-1,2)], [track(i,1),track(i,2)], radius + laneWidth, 1);
            plot(xunit, yunit,'b');
            hold on
            
            [xunit, yunit] = plotArc([track(i-1,3),track(i-1,4)], [track(i,3),track(i,4)], radius, 1);
            plot(xunit, yunit,'k');;
            hold on
            
            [xunit, yunit] = plotArc([track(i-1,5),track(i-1,6)], [track(i,5),track(i,6)], radius - laneWidth, 1);
            plot(xunit, yunit,'r');
            
            hold on
            
        otherwise
            % do nothing
    end
    
    % plot circles
    plot(track(i,1), track(i,2), 'bo') % plot left track
    hold on
    plot(track(i,3), track(i,4), 'ko') % plot center track
    hold on
    plot(track(i,5), track(i,6), 'ro') % plot right track
    axis equal
end
    
hold off
commandwindow % return attention to the command window