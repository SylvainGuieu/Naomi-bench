function [phaseArray, phaseData] = openZernike(bench, zernike, amplitude, nPhase)
	config = bench.config;
    if nargin<3; amplitude = config.zernikeAmplitude; end
	if nargin<4; nPhase = config.zernikeNphase; end
    
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);
	naomi.action.resetWfs(bench);		
	
    
    naomi.action.cmdModal(bench, zernike, amplitude);
	
    % :TODO: Do not remove the tiptilt or leave it as it is ??? 
	phaseArray = naomi.measure.phase(bench,nPhase);
    
    if nargout>1
        K = naomi.KEYS;
        h = {{K.ZERN, zernike, K.ZERN}, ... 
             {K.DPRTYPE, 'ZERNIKE_OPEN', K.DPRTYPEc}, ... 
             {K.NPHASE, nPhase, K.NPHASEc}, ...
             {K.LOOP, K.OPENED, K.LOOPc}, ...
             {K.AMPLITUD, amplitude, K.AMPLITUDc}, ...
		     {K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
		     {K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};
						
        phaseData = naomi.data.Phase(phaseArray, h);
				bench.populateHeader(phaseData.header);
    end
end