function [phaseArray, phaseResidualArray, phaseData,phaseResidualData] = closeZernike(bench, zernike, amplitude, gain, nZernike, nStep)
    
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
  phaseResidualArray = phaseArray - targetPhaseArray;
    
    % build the data objects 
    if nargout>2 
        K = naomi.KEYS;
        h = {{K.DPRTYPE,   'ZERNIKE_CLOSED', K.DPRTYPEc}, ...
             {K.LOOPMODE,  K.ZONAL, K.LOOPMODEc}, ...
             {K.LOOP,      K.CLOSED, K.LOOPc}, ...
             {K.NPHASE,    nPhase, K.NPHASEc}, ...
             {K.LOOPGAIN,  gain, K.LOOPGAINc}, ...
             {K.LOOPSTEP,  nStep, K.LOOPSTEPc}, ...
             {K.LOOPNZER,  nZernike, K.LOOPNZERc}, ...
             {K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
 						 {K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};

        phaseData  = naomi.data.Phase(phaseArray, h);
        bench.populateHeader(phaseData.header);
        phaseResidualData = naomi.data.PhaseResidual(phaseResidualArray, h);
        naomi.copyHeaderKeys(phaseData, phaseResidualData, naomi.benchKeyList);
    end
end
