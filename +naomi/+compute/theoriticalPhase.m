function [phaseArray] = theoriticalPhase(nSub,x0,y0,diamPix, centralObscurationPix, zernikeNumber, orientation)
% theoriticalZtP  Theoretical phase screen for N zernike modes
%
%   [phaseArray] = compute.theoriticalPhase(nSub,x0,y0,diamPix, centralObscurationPix,  zernikeNumber, orientation)
%   
%   The phase screen are roughly normalized to RMS=1
%   The arrangement is the NOLL indexes, and start at
%   piston=1, tip=2, tilt=3, focus=4...  Positions
%   outside the pupil are filled with NaN.
%   The zernikes are computed with the zernfun function.
%   
%   nSub: size of output phase screen   
%   x0,y0,diamPix: circle to define the pupil
%   dimaPix: the diameter of the pupill [pixel]
%   centralObscurationPix: the central obscuration diameter [pixel]
%   zernikeNumber: the  zernike number 
%   orientation:  see config, one of 'xy', 'yx', '-yx', '-x-y', etc....
%   phaseArray(nSub,nSub): phase screen for the given zernike
%   
%   
% Mask to define the phase pupil
if nargin<7
    orientation = 'xy';
end
mask = naomi.compute.pupillMask(nSub,diamPix, centralObscurationPix, x0, y0);
 
[X,Y] = meshgrid(1:nSub,1:nSub);
% Radius
[theta,r] = cart2pol(double(X-x0)/double(diamPix/2),double(Y-y0)/double(diamPix/2));
[theta,r] = naomi.compute.orientPolar(theta, r, orientation);

mask(r>1.0) = 0;
mask(r<0.0) = 0;

% Noll numbering
n = [0 1  1 2  2 2  3 3  3 3 4 4  4 4  4  5  5  5  5  5  5 6  6 6  6 6  6 6  7 7  7 7  7 7  7 7 8 8  8 8  8 8  8 8  8 9  9 9  9 9  9 9  9 9  9 10 10 10 10 10 10 10 10 10  10 10 11 11 11 11 11 11 11 11 11 11  11 11 12 12 12 12 12 12 12 12 12 12  12 12  12 13 13 13 13 13 13 13 13 13 13 13  13 13  13];
m = [0 1 -1 0 -2 2 -1 1 -3 3 0 2 -2 4 -4  1 -1  3 -3  5 -5 0 -2 2 -4 4 -6 6 -1 1 -3 3 -5 5 -7 7 0 2 -2 4 -4 6 -6 8 -8 1 -1 3 -3 5 -5 7 -7 9 -9  0 -2  2 -4  4 -6  6 -8  8 -10 10 -1  1 -3  3 -5  5 -7  7 -9  9 -11 11  0  2 -2  4 -4  6 -6  8 -8 10 -10 12 -12  1 -1  3 -3  5 -5  7 -7  9 -9 11 -11 13 -13];
 
Z = naomi.compute.zernfun(n(zernikeNumber),m(zernikeNumber),r(mask),theta(mask)); 
Z = Z / rms(Z(:));
phaseArray = nan(nSub, nSub);
phaseArray(mask) = Z;
 
end
 
 

