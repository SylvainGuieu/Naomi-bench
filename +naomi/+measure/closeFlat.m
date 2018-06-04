function [flatArray, flatData] = closeFlat(bench, varargin)
    
    P = naomi.parseParameters(varargin, {'gain', 'nZernike', 'nStep'}, 'measure.closeFlat');
    P.gain =     naomi.getParameter(bench, P, 'gain', 'flatCloseGain');
    P.highestMode = naomi.getParameter(bench, P, 'nZernike', 'flatCloseNzernike');
    P.nStep =    naomi.getParameter(bench, P, 'nStep', 'flatCloseNstep');
    nPhase =   naomi.getParameter(bench, P, 'nPhase', 'flatNphase');
    
    P.lowestMode = 2;
     
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);		
	naomi.action.resetWfs(bench);
    
	naomi.action.closeModal(bench, 0.0 ,P);
	
	flatArray = naomi.measure.phase(bench, nPhase);
    
    % if to output argument encapsule the result in a 
    % naomi.data.PhaseFlat object
    if nargout>1
        K = naomi.KEYS;
        
        h = {{K.DPRTYPE, 'FLAT_CLOSED', K.DPRTYPEc}, ...
            {K.LOOPMODE,  K.MODAL,  K.LOOPMODEc}, ...
            {K.LOOP,      K.CLOSED, K.LOOPc}, ...
            {K.NPHASE,    nPhase,   K.NPHASEc  }, ...
            {K.LOOPGAIN,  gain,     K.LOOPGAINc}, ...
            {K.LOOPSTEP,  nStep,    K.LOOPSTEPc}, ...
            {K.LOOPNZER,  nZernike, K.LOOPNZERc}, ... 
			{K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
			{K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};
        
        flatData  = naomi.data.PhaseFlat(flatArray, h);
		bench.populateHeader(flatData.header);
    end
    
end
