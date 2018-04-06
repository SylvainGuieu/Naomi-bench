function phaseData = phase(bench, Np)
	if nargin<2; Np = bench.config.defaultNp; end
	
	h = {{'NP', Np, 'Number of averaged pull'}};
	phaseData = naomi.data.Phase(bench.wfs.getAvgPhase(Np), h, {bench});
	
	if bench.config.plotVerbose
		bench.config.figure('Last Phase');
		phaseData.plot();
	end
end