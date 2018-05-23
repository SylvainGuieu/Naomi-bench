function [flatArray, flatData] = closeFlat(bench, gain, nZernike, nStep)

	config = bench.config;
	if nargin<2; gain = config.flatCloseGain; end
	if nargin<3; nZernike = config.flatCloseNzernike; end
	if nargin<4; nStep = config.flatCloseNstep; end

	nPhase = config.flatNphase;
    
    
	[~,PtZArray] = naomi.make.theoriticalZtP(bench);

	
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);		
	naomi.action.resetWfs(bench);
    
	naomi.action.closeModal(bench,PtZArray, gain, nStep, 2, nZernike);
	
	
		flatArray = naomi.measure.phase(bench, nPhase);
    
    % if to output argument encapsule the result in a 
    % naomi.data.PhaseFlat object
    if nargout>1
        K = naomi.KEYS;
        
        h = {{K.DPRTYPE, 'FLAT_CLOSED', K.DPRTYPEc}, ...
            {K.LOOPMODE,  K.ZONAL,  K.LOOPMODEc}, ...
            {K.LOOP,      K.CLOSED, K.LOOPc}, ...
            {K.NPHASE,    nPhase,   K.NPHASEc  }, ...
            {K.LOOPGAIN,  gain,     K.LOOPGAINc}, ...
            {K.LOOPSTEP,  nStep,    K.LOOPSTEPc}, ...
            {K.LOOPNZER,  nZernike, K.LOOPNZERc}, 
						{K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
						{K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};
        
        flatData  = naomi.data.PhaseFlat(flatArray, h);
				bench.populateHeader(flatData.header);
    end
    
end
