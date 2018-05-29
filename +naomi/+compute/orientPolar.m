function [theta,r] = orientPolar(theta, r, orientation, angle)
%ORIENTPOLAR recompute the polar coordinates according to the given
% orientation 'xy', 'yx', '-xy', '-x-y', 'y-x', '-y-x', '-yx'
if nargin<4; angle= 0.0; end
switch orientation
    case 'xy'
        theta = theata + angle;
    case '-xy'
        theta = -theta + pi + angle;
    case '-x-y'
        theta = theta + pi + angle;
    case 'x-y'
        theta = -theta + angle;
    case 'yx'
        theta = theta + pi/2 + angle;
    case '-yx'
        theta = -theta +pi/2 + angle;
    case 'y-x'
        theta =  -theta + (pi + pi/2) + angle;
    case '-y-x'
        theta = theta + (pi + pi/2) + angle;
end
end

