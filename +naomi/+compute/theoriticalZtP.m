function [ZtP,PtZ] = theoriticalZtP(Nsub,x0,y0,diamPix,Nzer)
% theoriticalZtP  Theoretical phase screen for N zernike modes
%
%   [ZtP,PtZ] = ComputeZtP(Nsub,x0,y0,diamPix,Nzer)
%  
%   The phase screen are roughly normalized to RMS=1
%   The arrangement is the NOLL indexes, and start at
%   piston=1, tip=2, tilt=3, focus=4...  Positions
%   outside the pupil are filled with 0 (not NaN).
%   The zernikes are computed with the zernfun function.
%   
%   Nsub: size of output phase screen
%   x0,y0,diamPix: circle to define the pupil
%   Nzer: number of zernikes
% 
%   ZtP(Nzer,Nsub,Nsub): phase screen of zernikes
%   PtZ(Nsub,Nsub,Nzer): phase to zernikes

% Mask to define the phase pupil
[Y,X] = meshgrid(1:Nsub,1:Nsub);
mask = (X-x0).^2 + (Y-y0).^2 < (diamPix*diamPix/4);

% Radius
[theta,r] = cart2pol(double(X-x0)/double(diamPix/2),double(Y-y0)/double(diamPix/2));

% Noll numbering
n = [0 1  1 2  2 2  3 3  3 3 4 4  4 4  4  5  5  5  5  5  5 6  6 6  6 6  6 6  7 7  7 7  7 7  7 7 8 8  8 8  8 8  8 8  8 9  9 9  9 9  9 9  9 9  9 10 10 10 10 10 10 10 10 10  10 10 11 11 11 11 11 11 11 11 11 11  11 11 12 12 12 12 12 12 12 12 12 12  12 12  12 13 13 13 13 13 13 13 13 13 13 13  13 13  13];
m = [0 1 -1 0 -2 2 -1 1 -3 3 0 2 -2 4 -4  1 -1  3 -3  5 -5 0 -2 2 -4 4 -6 6 -1 1 -3 3 -5 5 -7 7 0 2 -2 4 -4 6 -6 8 -8 1 -1 3 -3 5 -5 7 -7 9 -9  0 -2  2 -4  4 -6  6 -8  8 -10 10 -1  1 -3  3 -5  5 -7  7 -9  9 -11 11  0  2 -2  4 -4  6 -6  8 -8 10 -10 12 -12  1 -1  3 -3  5 -5  7 -7  9 -9 11 -11 13 -13];

% Init
ZtP = nan(Nzer,Nsub,Nsub);
ztp = nan(Nsub,Nsub);

% Estimate Zernike and fill the output matrix
for z=1:Nzer
  % TODO maybe the computation should be in the path instead
  Z = naomi.compute.zernfun(n(z),m(z),r(mask),theta(mask));
  Z = Z / rms(Z(:));
  ztp(mask) = Z;
  ZtP(z,:,:) = ztp;
end

% Comptue the Phase to Zernike
PtZ = reshape(pinv(reshape(naomi.compute.nanzero(ZtP),Nzer,[])),Nsub,Nsub,[]);

end


