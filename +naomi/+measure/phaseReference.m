function phaseData = phaseReference(bench, nPhase)
	if nargin<2; nPhase = bench.config.phaseRefNphase; end
	
	h = {{'NP', nPhase, 'Number of phase averaged'}};
		
	% 0,0 -> no tiptilt removal, no reference substraction 
	phaseArray = naomi.measure.phase(bench,nPhase,0,0);
	phaseData = naomi.data.PhaseReference(phaseArray, h, {bench});	
end