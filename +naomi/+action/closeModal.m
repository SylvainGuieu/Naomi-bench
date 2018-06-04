function [phir,rmsc] = closeModal(bench,trgPhi, varargin)
% closeModal Close a modal loop
%
%   phi = closeModal(dm,wfs,PtZArray,gain,nStep,lowestMode,highestMode)
%   phi = closeModal(dm,wfs,PtZArray,gain,nStep,lowestMode,highestMode,targetPhi)
%
%   dm, wfs: DM and WFS from ACE
%   PtZArray(nSubAperture,nSubAperture,nZernike): Phase to Mode matrix
%   gain: loop gain, same for all modes
%   nStep: number of step before function return
%   lowestMode,highestMode: first and last controled modes
%   trgPhi(nSubAperture,nSubAperture): target phase to close loop
%
%   phi(nSubAperture,nSubAperture): the residuals at the loop end.
%


P = naomi.parseParameters(varargin, {'gain', 'nZernike', 'nStep'}, 'action.closeModal');
gain           = naomi.getParameter(bench, P, 'gain', 'closeModalGain');
lowestZernike  = naomi.getParameter(bench, P, 'lowestZernike', 'closeModalLowestZernike');
highestZernike = naomi.getParameter(bench, P, 'highestZernike', 'closeModalHighestZernike');
nStep          = naomi.getParameter(bench, P, 'nStep', 'closeModalNstep');


P.nZernike = highestZernike; % for theoriticalZtP

dm = bench.dm;

PtZArray = naomi.getParameter([], P, 'PtZArray', [], []);
if isempty(PtZArray)
    [~,PtZArray] = naomi.make.theoriticalZtP(bench, P);
end

bench.log(sprintf('NOTICE: Close modal loop in %i steps:',nStep));

[~,~,nZernike] = size(PtZArray);
iZernike = lowestZernike:highestZernike;

if nargin < 7; trgPhi = 0.0; end;
    for step=1:nStep
        % Read WFS
        phi  = naomi.measure.phase(bench, 1); 
        phir = phi - trgPhi;
        
        % Control
        res = reshape(naomi.compute.nanzero(phir),1,[]) * reshape(PtZArray,[],nZernike);
        
        naomi.action.cmdRelativeModal(bench, iZernike,  -gain * res(iZernike) );
            
        % print
        rmsc = naomi.compute.rms_tt(phir);
        cmd = dm.cmdVector + dm.biasVector;
        bench.log( sprintf('NOTICE: %2i/%i rms = %.3f rmsc = %.3f ptv = %.3f cmax = %.3f cmean = %.3f', ...
                                   step,nStep,naomi.compute.nanstd(phir(:)),rmsc,...
                                   max(phir(:)) - min(phir(:)),...
                                   max(abs(cmd(:))),mean(cmd(:))), 2);                 
    end
end

