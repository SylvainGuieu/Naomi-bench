function flatData = closeFlat(bench, gain, Nz, Nstep)

	config = bench.config;
	if nargin<2; gain = config.flatCloseGain; end
	if nargin<3; Nz = config.flatCloseNz; end
	if nargin<4; Nstep = config.flatCloseNstep; end

	h = {{'DPR_TYPR', 'FLAT_CLOSED', ''}, 
		 {'NP', Np, 'number of pull'},
		 {'GAIN', gain, 'close loop gain'},
		 {'NSTEP', Nstep, 'number of loop step'}, 
		 {'NZERN', Nz, 'number of zerniques used to close loop'}, 
		 {'LOOP', 'CLOSE', ''}};

	[ZtPArray,PtZArray] = naomi.make.theoriticalZtP(bench);

	bench.dm.Reset();
	naomi.config.pupillMask(bench);		
	bench.wfs.Reset();

	naomi.action.closeModal(bench,PtZArray, gain, Nstep, 2, Nz);
	flatArray = naomi.measure.phase(config.flatNp);
	flatData  = naomi.data.Phase(flatArray, h, {bench});

	if config.plotVerbose
		bench.config.figure('Best Flat');
		flatData.plot();
	end
end
