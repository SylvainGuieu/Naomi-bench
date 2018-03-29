function phaseData = phase(wfs, Np, config)
	if nargin<2; Np=1; end
	
	h = {{'NP', Np, 'Number of averaged pull'}}
	phaseData = naomi.data.Phase(wfs.getAvgPhase(), h, {wfs});
	
	if config.plots
		naomi.getFigure('Last Phase');
		phaseData.plot();
	end
end