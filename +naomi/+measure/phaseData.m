function phaseData = phaseData(bench, nPhase)
	if nargin<2; nPhase = bench.config.defaultNphase; end	
	h = {{'NP', nPhase, 'Number of averaged pull'}};
	phaseData = naomi.data.Phase(naomi.measure.phase(bench, nPhase), h, {bench});		
end