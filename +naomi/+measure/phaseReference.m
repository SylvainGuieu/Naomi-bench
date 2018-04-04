function phaseData = phaseReference(bench, Np)
	if nargin<2; Np = bench.config.phaseRefNp; end
	
	h = {{'NP', Np, 'Number of averaged pull'}};

	ref = bench.wfs.ref; % save the ref 
	bench.wfs.ref.resetReference();

	PHASE_REF = naomi.data.PhaseReference(bench.wfs.getAvgPhase(Np), h, {bench});
	if bench.config.autoConfig
		bench.PHASE_REF = PHASE_REF;
	end
	if bench.config.plotVerbose
		naomi.getFigure('Phase reference');
		PHASE_REF.plot();
	end
end