function [PtC,ZtC,ZtP] = commandMatrix(IFM, x0, y0, diamPix, centralObscurtionPix, nEigenValue, nZernike, zeroMean, ztcOrientation)
% compute.commandMatrix  Compute the zonal and modal Command matrix from an IFM 
%
%   [NtC,PtC,ZtP] = compute.commandMatrix(IFM, x0, y0, diamPix, centralObscurtionPix, nEigenValue, nZernike, zeroMean)
%	

%   The request pupil is extracted for each Influence
%   function, then the matrix is inverted by SVdec
%   keeping only the number of requested Eigenvalues.
%
%   IFM(nActuator,nSubAperture,nSubAperture): input Influence Functions
%   x0,y0,diamPix,centralObscurtionPix: define the phase mask in pixel
%   nEigenValue: number of accepted Eigenvalues
%   zeroMean: 0/1 flag to select of the mean of actuators
%             is forced to zero (1) or not (0).
%   ztcOrientation: one of 'xy', 'yx', '-yx' etc...
%
%   PtC(nSubAperture,nSubAperture,nActuator): zonal Phase to Command matrix
%   ZtC(nZernike,nActuator): modal zernike to command matrix
%   ZtP(nZernike,nSubAperture,nSubAperture): requested zernikes

if nargin<8
    zeroMean = 1;
end
if nargin<9; ztcOrientation = 'xy'; end

[nActuator,nSubAperture,~] = size(IFM);

% Mask to define the phase pupil
mask = naomi.compute.pupillMask(nSubAperture, diamPix, centralObscurtionPix, x0, y0);

% CtP defined only over the
% requested circle, 0 outside.
CtP = bsxfun(@times,IFM,reshape(mask,1,nSubAperture,nSubAperture));
CtP(isnan(CtP)) = 0.0;

% Compute Phase2Command matrix
CtP = reshape(CtP,nActuator,nSubAperture*nSubAperture);
CtP(:,nSubAperture*nSubAperture+1) = zeroMean * 1000;
if exist('acecsPInv')
    PtC = acecsPInv(CtP,nEigenValue);
else
    warning('The acecsPInv command is not found using pinv. Is ACE loaded ? ');
    PtC = pinv(CtP);
end
PtC = PtC(1:nSubAperture*nSubAperture,:);
PtC = reshape(PtC,nSubAperture,nSubAperture,nActuator);

% Compute the Zernike2Phase matrix
ZtP = naomi.compute.theoriticalZtP(nSubAperture,x0,y0,diamPix, centralObscurtionPix, nZernike, ztcOrientation);

% Compute the Zernike to Command
ZtC = reshape(naomi.compute.nanzero(ZtP),nZernike,nSubAperture*nSubAperture) * reshape(PtC,nSubAperture*nSubAperture,nActuator);

end

