function [xunit, yunit] = plotArc(startPoint, endPoint, radius, direction)
% Jason Atwood
% 03/29/2013
%
% description:
%  plots a single arc
%
% inputs:
% - startPoint  : 1D array with two values: startPoint(1) = x, startPoint(2) = y position of start point
% - endPoint    : 1D array with two values: endPoint(1) = x, endPoint(2) = y position of end point
% - radius      : radius of arc to plot
% - direction   : int, sets direction, 0 = CCW, 1 = CW
%
% outputs:
% xunit : 1D array with x values of the arc
% yunit : 1D array with y values of the arc
%
% subfuctions:
% - none
%
% notes:
% to plot arc:
% 1. [xunit, yunit] = plotArc([2,3], [3, 5], 2, 0)
% 2. plot(xunit, yunit)
% 3. axis equal
% 
% geometric considerations:
% With any give start point, end point, and radius, there area alwasy 4 arcs.
% 'direction' sets BOTH, direction of travel and which side of the
% start/endpoints the circle center lies.

% length of chord
m = ((endPoint(1) - startPoint(1))^2 + (endPoint(2) - startPoint(2))^2)^0.5; % euclidean distance

% length of perpendicular bisector
h = (radius^2 - (m/2)^2)^0.5;   % pythagorean theorem

% chord heading
theta = atan2((endPoint(2)-startPoint(2)) , (endPoint(1) - startPoint(1))); % angle in radians

% perpendicular bisector point
pBisec = (startPoint + endPoint)./2;

% circle center
if direction == 0       % counter clockwise
    alpha = theta + pi/2;
else                    % clockwise
    alpha = theta - pi/2;
end
C = [pBisec(1) + h*cos(alpha), pBisec(2) + h*sin(alpha)];


% generate arc;
startAngle = atan2((startPoint(2) - C(2)) , (startPoint(1) - C(1))); 
endAngle = atan2((endPoint(2) - C(2)) , (endPoint(1) - C(1)));

if direction == 0
    if startAngle > endAngle
        % will cross 180 boundary
        th = [startAngle : pi/50 : pi,  -pi : pi/50 : endAngle];

    else
        th = startAngle:pi/50:endAngle;
    end
else
    if startAngle < endAngle
        % will cross 180 boundary
        th = [endAngle : pi/50 : pi,  -pi : pi/50 : startAngle];

    else
        th = startAngle:-pi/50:endAngle;
    end
end
xunit = radius * cos(th) + C(1);
yunit = radius * sin(th) + C(2);
