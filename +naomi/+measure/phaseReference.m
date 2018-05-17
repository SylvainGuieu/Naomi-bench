function [phaseArray,phaseData] = phaseReference(bench, nPhase)
	if nargin<2; nPhase = bench.config.phaseRefNphase; end
		
	% 0,0 -> no tiptilt removal, no reference substraction 
	phaseArray = naomi.measure.phase(bench,nPhase,0,0);
    if nargout>1
        K = naomi.KEYS;
        h = {{K.NPHASE, nPhase, K.NPHASEc}, ...
             {K.PHASEREF, 0, K.PHASEREFc}, ...
             {K.PHASETT, 0, K.PHASETTc}};
        phaseData = naomi.data.PhaseReference(phaseArray, h, {bench});
    end
end