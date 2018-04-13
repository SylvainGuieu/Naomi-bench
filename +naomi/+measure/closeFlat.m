function flatData = closeFlat(bench, gain, nZernike, nStep)

	config = bench.config;
	if nargin<2; gain = config.flatCloseGain; end
	if nargin<3; nZernike = config.flatCloseNzernike; end
	if nargin<4; nStep = config.flatCloseNstep; end

	nPhase = config.flatNphase
	h = {{'DPR_TYPR', 'FLAT_CLOSED', ''}, 
		 {'NP', nPhase, 'number of phase averaged'},
		 {'GAIN', gain, 'close loop gain'},
		 {'NSTEP', nStep, 'number of loop step'}, 
		 {'NZERN', nZernike, 'number of zernikes used to close loop'}, 
		 {'LOOP', 'CLOSE', 'loop status OPEN or CLOSE'}};

	[ZtPArray,PtZArray] = naomi.make.theoriticalZtP(bench);

	
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);		
	naomi.action.resetWfs(bench);

	naomi.action.closeModal(bench,PtZArray, gain, nStep, 2, nZernike);
	
	flatArray = naomi.measure.phase(bench, config.flatNphase);
	flatData  = naomi.data.Phase(flatArray, h, {bench});

	if config.plotVerbose
		bench.config.figure('Best Flat');
		flatData.plot();
	end
end
