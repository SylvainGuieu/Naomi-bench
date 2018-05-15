function flatData = closeFlat(bench, gain, nZernike, nStep)

	config = bench.config;
	if nargin<2; gain = config.flatCloseGain; end
	if nargin<3; nZernike = config.flatCloseNzernike; end
	if nargin<4; nStep = config.flatCloseNstep; end

	nPhase = config.flatNphase;
    K = naomi.KEYS;
	h = {{K.DPRTYPE, 'FLAT_CLOSED', K.DPRTYPEc}, ...
         {K.LOOPMODE, 'zonal',   K.LOOPMODEc}, ...
         {K.LOOP,     'CLOSED',  K.LOOPc}, ...
		 {K.NPHASE,    nPhase,   K.NPHASEc}, ...
		 {K.LOOPGAIN,  gain,     K.LOOPGAINc}, ...
		 {K.LOOPSTEP', nStep,    K.LOOPSTEPc}, ...
		 {K.LOOPNZER,  nZernike, K.LOOPNZERc}};
    
	[~,PtZArray] = naomi.make.theoriticalZtP(bench);

	
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);		
	naomi.action.resetWfs(bench);
    
	naomi.action.closeModal(bench,PtZArray, gain, nStep, 2, nZernike);
	
	flatArray = naomi.measure.phase(bench, nPhase);
	flatData  = naomi.data.PhaseFlat(flatArray, h, {bench});
    
	if config.plotVerbose
		naomi.plot.figure('Best Flat');
		flatData.plot();
	end
end
