function phi = closeZonal(bench, PtC,gain,nStep,trgPhi)
% closeZonal Close a zonal loop
%
%   phi = closeZonal(dm,wfs,PtC,gain,nStep)
%
%   dm, wfs: DM and WFS from ACE
%   PtC(nSubAperture,nSubAperture,nActuator): Phase to Command matrix
%   gain: loop gain, same for all modes
%   nStep: number of step before function return
%   trgPhi(nSubAperture,nSubAperture): target phase to close loop
%
%   phi(nSubAperture,nSubAperture): the residuals at the loop end.
%
wfs = bench.wfs;
dm = bench.dm;
config = bench.config;

bench.log(sprintf('NOTICE: Close zonal loop in %i step:',nStep), 1);

[~,~,nActuator] = size(PtC);
if nargin < 6; trgPhi = 0.0; end;

    for step=1:nStep
        % Read WFS
        phi  = naomi.measure.phase(bench, 1);
        phir = phi - trgPhi;
        
        % Control
        res = reshape(naomi.compute.nanzero(phir),1,[]) * reshape(PtC,[],nActuator);
        naomi.action.cmdRelativeZonal(':', -gain * res');
        
        
        % Print    
        cmd = dm.cmdVector + dm.biasVector;
        bench.log(sprintf('NOTICE %2i/%i rms = %.3f rmsc = %.3f ptv = %.3f '...
                 'cmax = %.3f cmean = %.3f',...
                step, nStep, naomi.compute.nanstd(phir(:)), ...
                naomi.compute.rms_tt(phir),max(phir(:)) - min(phir(:)),...
                max(abs(cmd(:))),mean(cmd(:))), 2);
    end

end
