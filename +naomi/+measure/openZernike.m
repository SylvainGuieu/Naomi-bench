function [phaseArray, phaseData] = openZernike(bench, zernike, varargin)
	config = bench.config;
    P = naomi.parseParameters(varargin, {'nPhase', 'amplitude', 'nPushPull', 'dateOb', 'tplName'}, 'measure.openZernike');
    amplitude = naomi.getParameter(bench, P, 'amplitude', 'zernikeAmplitude');
    nPhase = naomi.getParameter(bench, P, 'nPhase', 'zernikeNphase');
    nPushPull = naomi.getParameter(bench, P, 'nPushPull', 'zernikeNpushPull');
    
    
	naomi.action.resetDm(bench);
	naomi.config.pupillMask(bench);
	naomi.action.resetWfs(bench);		
	
    if nPushPull
        phaseArray = zeros(bench.nSubAperture);
        for iPushPull=1:nPushPull
            naomi.action.cmdModal(bench, zernike,  amplitude);
            push =  naomi.measure.phase(bench,nPhase);
            naomi.action.cmdModal(bench, zernike,  -amplitude);
            pull =  naomi.measure.phase(bench,nPhase);
            phaseArray = phaseArray + (push-pull)/nPushPull;
        end
        phaseArray = phaseArray / (2*amplitude*nPushPull);
    else
        naomi.action.cmdModal(bench, zernike, amplitude);
        % :TODO: Do not remove the tiptilt or leave it as it is ??? 
        phaseArray = naomi.measure.phase(bench,nPhase);
    end
    if nargout>1
        K = naomi.KEYS;
        tplName = naomi.getParameter([], P, 'tplName', [], K.TPLNAMEd);
        dateOb  = naomi.getParameter([], P, 'dateOb',  [], now);
        h = {{K.MJDOBS,config.mjd, K.MJDOBSc},...
             {K.DATEOB, dateOb, K.DATEOBc}, ...
             {K.TPLNAME,tplName, K.TPLNAMEc}, ...
             {K.DPRTYPE, 'ZERNIKE_OPEN', K.DPRTYPEc}, ... 
             {K.ZERN, zernike, K.ZERN}, ... 
             {K.NPHASE, nPhase, K.NPHASEc}, ...
             {K.LOOP, K.OPENED, K.LOOPc}, ...
             {K.AMPLITUD, amplitude, K.AMPLITUDc}, ...
		     {K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
		     {K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};
						
        phaseData = naomi.data.Phase(phaseArray, h);
		bench.populateHeader(phaseData.header);
    end
end