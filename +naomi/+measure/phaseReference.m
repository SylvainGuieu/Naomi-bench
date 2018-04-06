function phaseData = phaseReference(bench, Np)
	if nargin<2; Np = bench.config.phaseRefNp; end
	
	h = {{'NP', Np, 'Number of averaged pull'}};

	ref = bench.wfs.ref; % save the ref 
	bench.wfs.resetReference();


	phaseData = naomi.data.PhaseReference(bench.wfs.getAvgPhase(Np), h, {bench});	
end