function flatData = openFlat(bench, nPhase)
	config = bench.config;
	if nargin<2; nPhase = config.flatNphase; end;

	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);
	naomi.action.resetWfs(bench);		
	
	
	flatArray = naomi.measure.phase(bench,nPhase);
    K = naomi.KEYS;
    h = {{K.DPRTYPE, 'FLAT_OPEN', K.DPRTYPEc},... 
         {K.NPHASE, nPhase, K.NPHASEc}, ...
		 {K.LOOP, 'OPEN', K.LOOPc}};
    
	flatData = naomi.data.PhaseFlat(flatArray, h, {bench});
	if config.plotVerbose
		naomi.plot.figure('Best Flat');
		flatData.plot();
	end
end