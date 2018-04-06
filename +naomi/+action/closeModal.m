function [phir,rmsc] = closeModal(bench,PtZArray,gain,Nstep,minMode,maxMode,trgPhi)
% closeModal Close a modal loop
%
%   phi = closeModal(dm,wfs,PtZArray,gain,Nstep,minMode,maxMode)
%   phi = closeModal(dm,wfs,PtZArray,gain,Nstep,minMode,maxMode,targetPhi)
%
%   dm, wfs: DM and WFS from ACE
%   PtZArray(Nsub,Nsub,Nzer): Phase to Mode matrix
%   gain: loop gain, same for all modes
%   Nstep: number of step before function return
%   minMode,maxMode: first and last controled modes
%   trgPhi(Nsub,Nsub): target phase to close loop
%
%   phi(Nsub,Nsub): the residuals at the loop end.
%


wfs = bench.wfs;
dm = bench.dm;
config = bench.config;

fprintf('Close modal loop (%i step):\n',Nstep);

[~,~,Nzer] = size(PtZArray);
if nargin < 8; trgPhi = 0.0; end;

for step=1:Nstep
    % Read WFS
    phi  = naomi.measure.phase(bench, 1).data; 
    phir = phi - trgPhi;

    % Control
    res = reshape(naomi.compute.nanzero(phir),1,[]) * reshape(PtZArray,[],Nzer);
    dm.zernikeVector(minMode:maxMode) = dm.zernikeVector(minMode:maxMode) - gain * res(minMode:maxMode);
    
    % Print
    if config.plotVerbose; dm.DrawMonitoring(); end

    rmsc = naomi.compute.rms_tt(phir);
    cmd = dm.cmdVector + dm.biasVector;
    fprintf('%2i rms = %.3f rmsc = %.3f ptv = %.3f cmax = %.3f cmean = %.3f\n',step,naomi.compute.nanstd(phir(:)),rmsc,max(phir(:)) - min(phir(:)),max(abs(cmd(:))),mean(cmd(:)));
end

end

