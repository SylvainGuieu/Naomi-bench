function flatData = openFlat(bench, Np)
	config = bench.config;
	if nargin<2; Np = config.flatNp; end;

	bench.dm.Reset();
	naomi.config.pupillMask(bench);		
	bench.wfs.Reset();
	
	flatArray = naomi.measure.phase(Np);

	h = {{'DPR_TYPR', 'FLAT_OPEN', ''}, {'NP', Np, 'number of pull'}, 
		 {'LOOP', 'OPEN', ''}};

	flatData = naomi.data.Phase(flatArray, h, {bench});
	if config.plotVerbose
		bench.config.figure('Best Flat');
		flatData.plot();
	end
end