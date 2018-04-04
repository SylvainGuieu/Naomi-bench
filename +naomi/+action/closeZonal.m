function phi = closeZonal(bench, PtC,gain,Nstep,trgPhi)
% closeZonal Close a zonal loop
%
%   phi = closeZonal(dm,wfs,PtC,gain,Nstep)
%
%   dm, wfs: DM and WFS from ACE
%   PtC(Nsub,Nsub,Nact): Phase to Command matrix
%   gain: loop gain, same for all modes
%   Nstep: number of step before function return
%   trgPhi(Nsub,Nsub): target phase to close loop
%
%   phi(Nsub,Nsub): the residuals at the loop end.
%
wfs = bench.wfs;
dm = bench.dm;
config = bench.config;

config.log(fprints('Close zonal loop (%i step):\n',Nstep), 1);

[~,~,Nact] = size(PtC);
if nargin < 6; trgPhi = 0.0; end;

for step=1:Nstep
    % Read WFS
    phi  = naomi.measure.phase(bench, 1).data;
    phir = phi - trgPhi;
    
    % Control
    res = reshape(naomi.compute.nanzero(phir),1,[]) * reshape(PtC,[],Nact);
    dm.cmdVector = dm.cmdVector - gain * res';
    
    % Print
    if config.plotVerbose; dm.DrawMonitoring(); end
    cmd = dm.cmdVector + dm.biasVector;
    config.log(fprints(['%2i rms = %.3f rmsc = %.3f ptv = %.3f '...
             'cmax = %.3f cmean = %.3f\n'],...
            step, naomi.compute.nanstd(phir(:)), ...
            naomi.compute.rms_tt(phir),max(phir(:)) - min(phir(:)),...
            max(abs(cmd(:))),mean(cmd(:))), 1);
end

end
