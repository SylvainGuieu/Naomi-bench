function [theta,r] = orientPolar(theta, r, orientation)
%ORIENTPOLAR recompute the polar coordinates according to the given
% orientation 'xy', 'yx', '-xy', '-x-y', 'y-x', '-y-x', '-yx'
switch orientation
    case 'xy'
   
    case '-xy'
        theta = -theta + pi;
    case '-x-y'
        theta = theta + pi;
    case 'x-y'
        theta = -theta;
    case 'yx'
        theta = theta + pi/2;
    case '-yx'
        theta = -theta +pi/2;
    case 'y-x'
        theta =  -theta + (pi + pi/2);
    case '-y-x'
        theta = theta + (pi + pi/2);
end
end

