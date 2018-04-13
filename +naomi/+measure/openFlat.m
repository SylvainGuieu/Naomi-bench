function flatData = openFlat(bench, nPhase)
	config = bench.config;
	if nargin<2; nPhase = config.flatNphase; end;

	naomi.action.resetDM(bench);
	naomi.config.pupillMask(bench);
	naomi.action.resetWfs(bench);		
	
	
	flatArray = naomi.measure.phase(bench,nPhase);

	h = {{'DPR_TYPR', 'FLAT_OPEN', ''}, {'NP', nPhase, 'number of phase averaged'}, 
		 {'LOOP', 'OPEN', ''}};

	flatData = naomi.data.Phase(flatArray, h, {bench});
	if config.plotVerbose
		bench.config.figure('Best Flat');
		flatData.plot();
	end
end