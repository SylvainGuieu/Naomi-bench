function [X,Y] = orientedMeshgrid(v,orientation)
%ORIENTEDMESHGRID create a square meshgrid following a orientation
%convention
%   v is the vector containing normal coordiante 
%  1.  'xy'  ->  [x,y] = meshgrid(v, v)
%  2.  'x-y' ->  same as 1. but y axis is flipped 
%  3.  '-xy' ->  same as 1. but x axis is flipped  
%  4.  '-x-y' -> same as 1. but x and y are flipped 
%  5.  'yx'  ->  y and x mesh are inversed
%       etc...
switch orientation 
    case 'xy'
        [X,Y] = meshgrid(v);
    case '-xy'
        [X,Y] = meshgrid(v(end:-1:1), v);
    case '-x-y'
        [X,Y] = meshgrid(v(end:-1:1), v(end:-1:1));
    case 'x-y'
        [X,Y] = meshgrid(v, v(end:-1:1));
    case 'yx'
        [Y,X] = meshgrid(v, v);
    case '-yx'
        [Y,X] = meshgrid(v(end:-1:1), v);
    case 'y-x'
        [Y,X] = meshgrid(v, v(end:-1:1));
    case '-y-x'
        [Y,X] = meshgrid(v(end:-1:1), v(end:-1:1));
    otherwise
        error(sprintf('orientation "%s" not understood', orientation))
end
end

