function [phir,rmsc] = closeModal(bench,PtZArray,gain,Nstep,minMode,maxMode,trgPhi)
% closeModal Close a modal loop
%
%   phi = closeModal(dm,wfs,PtZArray,gain,Nstep,minMode,maxMode)
%   phi = closeModal(dm,wfs,PtZArray,gain,Nstep,minMode,maxMode,targetPhi)
%
%   dm, wfs: DM and WFS from ACE
%   PtZArray(nSubAperture,nSubAperture,nZernike): Phase to Mode matrix
%   gain: loop gain, same for all modes
%   Nstep: number of step before function return
%   minMode,maxMode: first and last controled modes
%   trgPhi(nSubAperture,nSubAperture): target phase to close loop
%
%   phi(nSubAperture,nSubAperture): the residuals at the loop end.
%


wfs = bench.wfs;
dm = bench.dm;
config = bench.config;

config.log(sprintf('Close modal loop (%i step):\n',Nstep));

[~,~,nZernike] = size(PtZArray);
iZernike = minMode:maxMode;

if nargin < 7; trgPhi = 0.0; end;
    for step=1:Nstep
        % Read WFS
        phi  = naomi.measure.phase(bench, 1); 
        phir = phi - trgPhi;
        
        % Control
        res = reshape(naomi.compute.nanzero(phir),1,[]) * reshape(PtZArray,[],nZernike);

        
        naomi.action.cmdRelativeModal(bench, iZernike,  -gain * res(iZernike) );
            
        % print 
        rmsc = naomi.compute.rms_tt(phir);
        cmd = dm.cmdVector + dm.biasVector;
        config.log( sprintf('%2i rms = %.3f rmsc = %.3f ptv = %.3f cmax = %.3f cmean = %.3f\n', ...
                                   step,naomi.compute.nanstd(phir(:)),rmsc,...
                                   max(phir(:)) - min(phir(:)),...
                                   max(abs(cmd(:))),mean(cmd(:))));
                       
    end

end

