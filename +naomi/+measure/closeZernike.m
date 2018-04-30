function [phaseData, phaseResidualData] = closeZernike(bench, zernike, amplitude, gain, nZernike, nStep)
    
	config = bench.config;
    if nargin<3; amplitude = config.zernikeAmplitude; end
	if nargin<4; gain = config.zernikeCloseGain; end
	if nargin<5; nZernike = config.zernikeCloseNzernike; end
	if nargin<6; nStep = config.zernikeCloseNstep; end
    
	nPhase = config.zernikeNphase;
    
    
    [~,PtZArray] = naomi.make.theoriticalZtP(bench);
    
    targetPhaseArray = naomi.make.theoriticalPhase(bench, zernike, amplitude);
    
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);		
	naomi.action.resetWfs(bench);

	
	naomi.action.closeModal(bench,PtZArray, gain, nStep, 2, nZernike, targetPhaseArray);
	
	phaseArray = naomi.measure.phase(bench, config.flatNphase);
    
    K = naomi.KEYS;
	h = {{K.DPRTYPE, 'ZERNIKE_CLOSED', K.DPRTYPEc}, ...
         {K.LOOPMODE, 'zonal', K.LOOPMODEc}, ...
         {K.LOOP,     'CLOSED', K.LOOPc}, ...
		 {K.NPHASE, nPhase, K.NPHASEc}, ...
		 {K.LOOPGAIN, gain, K.LOOPGAINc}, ...
		 {K.LOOPSTEP', nStep, K.LOOPSTEPc}, ...
		 {K.LOOPNZER, nZernike, K.LOOPNZERc}};
     
	phaseData  = naomi.data.Phase(phaseArray, h, {bench});
    phaseResidualData = naomi.data.PhaseResidual(phaseArray - targetPhaseArray, h , {bench});
	if config.plotVerbose
		naomi.plot.figure('Last Phase');
        naomi.plot.phase(bench);	
	end
end
