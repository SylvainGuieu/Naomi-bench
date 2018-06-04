function [phaseArray, phaseResidualArray, phaseData,phaseResidualData] = closeZernike(bench, zernike, varargin)
    
	config = bench.config;
    
    P = naomi.parseParameters(varargin, {'amplitude', 'gain', 'nZernike', 'nStep', 'dateOb', 'tplNAme'}, 'measure.closeZernike');
    P.gain        = naomi.getParameter(bench, P, 'gain', 'zernikeCloseGain');
    P.highestMode = naomi.getParameter(bench, P, 'nZernike', 'zernikeCloseNzernike');
    P.nStep       = naomi.getParameter(bench, P, 'nStep', 'zernikeCloseNstep');
    P.amplitude   = naomi.getParameter(bench, P, 'amplitude' , 'zernikeAmplitude');
    nPhase        = naomi.getParameter(bench, P, 'nPhase', 'zernikeNphase');
    
    
    targetPhaseArray = naomi.make.theoriticalPhase(bench, zernike, P);
    
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);		
	naomi.action.resetWfs(bench);

	
	naomi.action.closeModal(bench, targetPhaseArray, P);
	
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
