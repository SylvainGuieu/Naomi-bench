function [PtC,NtC,ZtP] = cmdMat(IFM, x0, y0, diamPix, Neig, Nzer, zeroMean)
% ComputeCmdMat  Compute the zonal and modal Command matrix
%
%   [NtC,PtC,ZtP] = ComputeCommandMatrix(IFM, x0, y0, rad, Neig)
%
%   The request pupil is extracted for each Influence
%   function, then the matrix is inverted by SVdec
%   keeping only the number of requested Eigenvalues.
%
%   IFM(Nact,Nsub,Nsub): input Influence Functions
%   x0,y0,diamPix: circle to define the phase in pixel
%   Neig: number of accepted Eigenvalues
%   zeroMean: 0/1 flag to select of the mean of actuators
%             is forced to zero (1) or not (0).
%
%   PtC(Nsub,Nsub,Nact): zonal Phase to Command matrix
%   NtC(Nzer,Nact): modal NAOMI to command matrix
%   ZtP(Nzer,Nsub,Nsub): requested zernikes


[Nact,Nsub,~] = size(IFM);

% Mask to define the phase pupil
[Y,X] = meshgrid(1:Nsub,1:Nsub);
mask = (X-x0).^2 + (Y-y0).^2 < (diamPix*diamPix/4);

% CtP defined only over the
% requested circle, 0 outside.
CtP = bsxfun(@times,IFM,reshape(mask,1,Nsub,Nsub));
CtP(isnan(CtP)) = 0.0;

% Compute Phase2Command matrix
CtP = reshape(CtP,Nact,Nsub*Nsub);
CtP(:,Nsub*Nsub+1) = zeroMean * 1000;
PtC = acecsPInv(CtP,Neig);
PtC = PtC(1:Nsub*Nsub,:);
PtC = reshape(PtC,Nsub,Nsub,Nact);

% Compute the Zernike2Phase matrix
ZtP = naomi.compute.theoriticalZtP(Nsub,x0,y0,diamPix,Nzer);

% Compute the Zernike to Command
NtC = reshape(naomi.compute.nanzero(ZtP),Nzer,Nsub*Nsub) * reshape(PtC,Nsub*Nsub,Nact);

end

