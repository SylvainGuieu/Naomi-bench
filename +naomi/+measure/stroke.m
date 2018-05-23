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
    K = naomi.KEYS;
	h = {
		  {K.MJDOBS, config.mjd, K.MJDOBSc}, ...
		  {K.ZERN, zernikeMode, K.ZERNc}, ... 
          {K.NAMP, nAmp, K.NAMPc}
		};
    for iAmp=1:nAmp
        h{length(h)+1} = {sprintf('AMP%d',iAmp), amplitudeVector(iAmp), sprintf('amplitude %d value', iAmp)};
    end
    for iAmp=1:nAmp
	    % Set DM
	    naomi.action.cmdModal(bench, zernikeMode, amplitudeVector(iAmp) * (1).^(iAmp-1));
        allCmdArray(iAmp,:) = bench.cmdVector;        
	    phiArray = naomi.measure.phase(bench) - phiRefArray;
	    allPhiArray(iAmp,:,:) = phiArray(:,:);
    end
    
    strokeData = naomi.data.StrokePhaseCube(allPhiArray, h);
		bench.populateHeader(strokeData);
    strokeData.dmCommandArray = allCmdArray;
    strokeData.biasVector = bench.biasVector;
    strokeData.amplitudeVector = amplitudeVector;
    
    
    if config.plotVerbose
    	naomi.plot.figure('Modal Stroke'); clf;
    	strokeData.plot();
    end
end