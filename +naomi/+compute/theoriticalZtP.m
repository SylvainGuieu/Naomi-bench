function [ZtPArray,PtZArray] = theoriticalZtP(nSub,x0,y0,diamPix, centralObscurationPix, nZernike, orientation, angle)
% theoriticalZtP  Theoretical phase screen for N zernike modes
%
%   [ZtPArray,PtZArray] = compute.theoriticalZtP(nSub,x0,y0, diamPix,centralObscurationPix, nZernike, orientation)
%   
%   The phase screen are roughly normalized to RMS=1
%   The arrangement is the NOLL indexes, and start at
%   piston=1, tip=2, tilt=3, focus=4...  Positions
%   outside the pupil are filled with 0 (not NaN).
%   The zernikes are computed with the zernfun function.
%   
%   nSub: size of output phase screen   
%   x0,y0,diamPix: circle to define the pupil
%   diamPix: pupill diameter (pixel) 
%   centralObscurationPix: pupill central obscuration (pixel)
%  	nZernike: number of zernikes
% 	
%   ZtPArray(nZernike,nSub,nSub): phase screen of zernikes
%   PtZArray(nSub,nSub,nZernike): phase to zernikes
%   
% Mask to define the phase pupil

if nargin<7
    orientation = 'xy';
end
if nargin<8; angle = 0.0; end

mask = naomi.compute.pupillMask(nSub, diamPix, centralObscurationPix, x0, y0);

[X,Y] = meshgrid(1:nSub,1:nSub); 
% Radius
[theta,r] = cart2pol(double(X-x0)/double(diamPix/2),double(Y-y0)/double(diamPix/2));
[theta,r] = naomi.compute.orientPolar(theta, r, orientation, angle);

mask(r>1.0) = 0;
mask(r<0.0) = 0;

% Noll numbering
n = [0 1  1 2  2 2  3 3  3 3 4 4  4 4  4  5  5  5  5  5  5 6  6 6  6 6  6 6  7 7  7 7  7 7  7 7 8 8  8 8  8 8  8 8  8 9  9 9  9 9  9 9  9 9  9 10 10 10 10 10 10 10 10 10  10 10 11 11 11 11 11 11 11 11 11 11  11 11 12 12 12 12 12 12 12 12 12 12  12 12  12 13 13 13 13 13 13 13 13 13 13 13  13 13  13];
m = [0 1 -1 0 -2 2 -1 1 -3 3 0 2 -2 4 -4  1 -1  3 -3  5 -5 0 -2 2 -4 4 -6 6 -1 1 -3 3 -5 5 -7 7 0 2 -2 4 -4 6 -6 8 -8 1 -1 3 -3 5 -5 7 -7 9 -9  0 -2  2 -4  4 -6  6 -8  8 -10 10 -1  1 -3  3 -5  5 -7  7 -9  9 -11 11  0  2 -2  4 -4  6 -6  8 -8 10 -10 12 -12  1 -1  3 -3  5 -5  7 -7  9 -9 11 -11 13 -13];

% Init
ZtPArray = nan(nZernike,nSub,nSub);
ztp = nan(nSub,nSub);

% Estimate Zernike and fill the output matrix
for iZer=1:nZernike
  
  % TODO maybe the computation should be in the path instead
  Z = naomi.compute.zernfun(n(iZer),m(iZer),r(mask),theta(mask));
  Z = Z / rms(Z(:));
  ztp(mask) = Z;
  ZtPArray(iZer,:,:) = ztp;
end

% Comptue the Phase to Zernike
if nargout>1
    PtZArray = reshape(pinv(reshape(naomi.compute.nanzero(ZtPArray),nZernike,[])),nSub,nSub,[]);
end
end


