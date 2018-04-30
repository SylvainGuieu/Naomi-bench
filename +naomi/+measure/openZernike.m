function phaseData = openZernike(bench, zernike, amplitude, nPhase)
	config = bench.config;
    if nargin<3; amplitude = config.zernikeAmplitude; end
	if nargin<4; nPhase = config.zernikeNphase; end
    
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);
	naomi.action.resetWfs(bench);		
	
    
    naomi.action.cmdModal(bench, zernike, amplitude);
	
    % Do not remove the tiptilt or leave it as it is ??? 
	phaseArray = naomi.measure.phase(bench,nPhase);
    
    K = naomi.KEYS;
	h = { {K.ZERN, zernike, K.ZERN}, ... 
         {K.DPRTYPE, 'ZERNIKE_OPEN', K.DPRTYPEc}, ... 
         {K.NPHASE, nPhase, K.NPHASEc}, ...
		 {K.LOOP, 'OPEN', K.LOOPc}, ...
         {K.AMPLITUD, amplitude, K.AMPLITUDc}};
    
	phaseData = naomi.data.Phase(phaseArray, h, {bench});
	if config.plotVerbose
		naomi.plot.figure('Last Phase');
        naomi.plot.phase(bench);
	end
end