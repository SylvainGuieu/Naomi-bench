function [phaseCube, phaseCubeData] = turbulances(bench, phaseReference, nPhase)
    if nargin<2
        phaseReference = 10;
    end
    if nargin<3
        nPhase = 10;
    end
    if length(phaseReference)==1 
      % this is the number of phase to be averaged 
      phaseReference = naomi.measure.phase(bench, phaseReference, 0); 
    end
    nSubAperture = bench.nSubAperture;
    phaseCube = zeros(nPhase, nSubAperture, nSubAperture);
    for iPhase=1:nPhase
      phaseCube(iPhase, :,:) = naomi.measure.phase(bench, 1, 0) - phaseReference;
    end
    
    if bench.config.plotVerbose
       naomi.plot.figure('Tubulances');
       rmsVector = naomi.compute.nanstd(reshape(phaseCube, nPhase, nSubAperture*nSubAperture), 2);
       plot(rmsVector, 'b-o');
       ylabel('wave front rms (mu rms)'); 
       xlabel('measurement');
    end
    
    if nargout>1
      K = naomi.KEYS;
      h = {{K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
           {K.PHASETT,  0, K.PHASETTc}, ...
           {K.DPRVER, 'TURBU', K.DPRVERc}};
      phaseCubeData = naomi.data.PhaseCube(phaseCube, h);
      bench.populateHeader(phaseCubeData.header);
    end
end