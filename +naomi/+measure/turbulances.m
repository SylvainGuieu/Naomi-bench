function [phaseCube, phaseCubeData] = turbulances(bench, phaseReference, nPhase)
    if length(phaseReference)==1 
      % this is the number of phase to be averaged 
      phaseReference = naomi.measurePhase(bench, phaseReference, 0); 
    end
    nSubaperture = bench.nSubaperture;
    phaseCube(nPhase, nSubAperture, nSubAperture);
    for iPhase=1:nPhase
      phaseCube(iPhase, :,:) = naomi.measurePhase(bench, 1, 0);
    end
      
    if nargout>1
      h = {{}};
      phaseCubeData = naomi.data.PhaseCube(phaseCube, h, {bench});
    end
end