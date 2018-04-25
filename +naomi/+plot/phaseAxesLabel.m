function phaseAxesLabel(axes, orientation)
%PHASEAXESLABEL Summary of this function goes here
%   Detailed explanation goes here
if nargin<2; orientation = 'xy'; end;
% assume here that it is a nomal matlab image plot: e.i. y axes increase
% from top to bottom 
xp_x = 'x  =>+'; % increasing x on x axis
xn_x = '+<=  x';
xp_y = '+<=  x'; % increasing x on y axis
xn_y = 'x  =>+';

yp_x = 'y  =>+';
yn_x = '+<=  y';
yp_y = '+<=  y';
yn_y = 'y  =>+';

switch orientation
    case 'xy'
        xl = xp_x;
        yl = yp_y;
    case '-xy'
        xl = xn_x;
        yl = yp_y;
    case '-x-y'
        xl = xn_x;
        yl = yn_y;
    case 'x-y'
        xl = xp_x;
        yl = yn_y;   
        
     case 'yx'
        xl = yp_x;
        yl = xp_y;
    case '-yx'
        xl = yn_x;
        yl = xp_y;
    case '-y-x'
        xl = yn_x;
        yl = xn_y;
    case '-yx'
        xl = yp_x;
        yl = xn_y;    
    otherwise 
        error(sprintf ('orientation "%s" not understood', orientation));
end
    xlabel(axes, xl);
    ylabel(axes, yl);
end

