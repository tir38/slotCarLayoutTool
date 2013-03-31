function [xunit, yunit] = plotArc(startPoint, endPoint, radius, direction)

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
