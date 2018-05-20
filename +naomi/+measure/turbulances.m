function [phaseCube, phaseCubeData] = turbulances(bench, phaseReference, nPhase)
    if length(phaseReference)==1 
      % this is the number of phase to be averaged 
      phaseReference = naomi.measure.phase(bench, phaseReference, 0); 
    end
    nSubAperture = bench.nSubAperture;
    phaseCube= zeros(nPhase, nSubAperture, nSubAperture);
    for iPhase=1:nPhase
      phaseCube(iPhase, :,:) = naomi.measure.phase(bench, 1, 0)-phaseReference;
    end
      
    if nargout>1
      h = {};
      phaseCubeData = naomi.data.PhaseCube(phaseCube, h, {bench});
    end
end