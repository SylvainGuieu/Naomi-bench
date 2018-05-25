function strokeData = stroke(bench,zernikeMode,amplitudeVector)
	config = bench.config;
	
	if nargin<3 || isempty(amplitudeVector)
		maxAmp = 1./max(abs(bench.ZtCArray(zernikeMode,':')));
		amplitudeVector = linspace(config.strokeMinAmpFrac*maxAmp, config.strokeMaxAmpFrac*maxAmp, config.strokeNstep);
    end
    
	[nAmp,~] = size(amplitudeVector(:));
    nSubAperture = bench.nSubAperture;
    nActuator = bench.nActuator;
    
	allPhiArray = zeros(nAmp,nSubAperture,nSubAperture);
    allCmdArray = zeros(nAmp, nActuator);
    
	naomi.action.resetDm(bench);
	naomi.action.resetWfs(bench);

	phiRefArray = naomi.measure.phase(bench);
    
    % configure the mask matching the zernike to command matrix
    % installed
    naomi.config.pupillMask(bench, 'ztc');
    % make sure tiptilt are not removed
    bench.config.filterTipTilt = 0.0;
    bench.log(sprintf('NOTICE: starting stroke measurement for mode %d', zernikeMode));
    for iAmp=1:nAmp
	    % Set DM
	    naomi.action.cmdModal(bench, zernikeMode, amplitudeVector(iAmp) * (1).^(iAmp-1));
        allCmdArray(iAmp,:) = bench.cmdVector;        
	    phiArray = naomi.measure.phase(bench) - phiRefArray;
	    allPhiArray(iAmp,:,:) = phiArray(:,:);
        bench.log(sprintf('NOTICE:  stroke %d/%d mode=%d amplitude=%.3f', iAmp, nAmp, zernikeMode,amplitudeVector(iAmp) ));
    end
    
    K = naomi.KEYS;
        
    h = {{K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
		 {K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}, ...
         {K.ZERN,  zernikeMode, K.ZERNc},...
         {K.DPRVER, naomi.compute.zernikeInfo(zernikeMode), K.DPRVERc}};
    strokeData = naomi.data.StrokePhaseCube(allPhiArray, h);
	bench.populateHeader(strokeData);
    strokeData.dmCommandArray = allCmdArray;
    strokeData.biasVector = bench.biasVector;
    strokeData.amplitudeVector = amplitudeVector;
    
    bench.log(sprintf('NOTICE:  stroke measurement for mode %d finished', zernikeMode));
    
end