function phi = closeZonal(bench, PtC,gain,Nstep,trgPhi)
% closeZonal Close a zonal loop
%
%   phi = closeZonal(dm,wfs,PtC,gain,Nstep)
%
%   dm, wfs: DM and WFS from ACE
%   PtC(nSubAperture,nSubAperture,nActuator): Phase to Command matrix
%   gain: loop gain, same for all modes
%   Nstep: number of step before function return
%   trgPhi(nSubAperture,nSubAperture): target phase to close loop
%
%   phi(nSubAperture,nSubAperture): the residuals at the loop end.
%
wfs = bench.wfs;
dm = bench.dm;
config = bench.config;

config.log(sprintf('Close zonal loop (%i step):\n',Nstep), 1);

[~,~,nActuator] = size(PtC);
if nargin < 6; trgPhi = 0.0; end;

    for step=1:Nstep
        % Read WFS
        phi  = naomi.measure.phase(bench, 1);
        phir = phi - trgPhi;
        
        % Control
        res = reshape(naomi.compute.nanzero(phir),1,[]) * reshape(PtC,[],nActuator);
        naomi.action.cmdRelativeZonal(':', -gain * res');
        
        
        % Print    
        cmd = dm.cmdVector + dm.biasVector;
        config.log(sprintf('%2i rms = %.3f rmsc = %.3f ptv = %.3f '...
                 'cmax = %.3f cmean = %.3f\n',...
                step, naomi.compute.nanstd(phir(:)), ...
                naomi.compute.rms_tt(phir),max(phir(:)) - min(phir(:)),...
                max(abs(cmd(:))),mean(cmd(:))), 1);
    end

end
