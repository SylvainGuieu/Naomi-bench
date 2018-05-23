function [flatArray, flatData] = openFlat(bench, nPhase)
	config = bench.config;
	if nargin<2; nPhase = config.flatNphase; end;

	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);
	naomi.action.resetWfs(bench);		
	
	
	flatArray = naomi.measure.phase(bench,nPhase);
    % if to output argument, wrap the result in a 
    % naomi.data.PhaseFlat object (ready to be saved)
    if nargout>1
        K = naomi.KEYS;
        h = {{K.DPRTYPE, 'FLAT_OPEN', K.DPRTYPEc},... 
             {K.NPHASE, nPhase, K.NPHASEc}, ...
             {K.LOOP, K.OPENED, K.LOOPc},... 
			 {K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
		 	 {K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};

        flatData = naomi.data.PhaseFlat(flatArray, h);
		bench.populateHeader(flatData.header);
    end
end