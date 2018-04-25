function strokeData = stroke(bench,zernikeMode,amplitudeVector)
	config = bench.config;
	
	if nargin<3
		maxAmp = 1./max(abs(bench.ZtCArray(zernikeMode,:)));
		amplitudeVector = linspace(config.strokeMinAmpFrac*maxAMp, config.strokeMaxAmpFrac*maxAMp, config.strokeNstep);
	end

	[Nstep,~] = size(amplitudeVector(:));
	outputArray =  zeros(Nstep, 4);
	outputArray(:,1) = amplitudeVector;
	allPhiArray = zeros(nSubAperture,nSubAperture,Nstep);

	naomi.action.resetDm(bench);
	naomi.action.resetWfs(bench);

	phiRefArray = naomi.measure.phase(bench);
	h = {
		  {'MJD-OBS', config.mjd, 'MJD at script startup'}, 
		  {'MODE', zernikeMode, 'Zernike mode used'}
		};
    
	for s=1:Nstep
	    % Set DM
	    naomi.action.cmdModal(bench, zernikeMode, amplitudeVector(s) * (1).^(s-1));
	    outputArray(s,2) = max(abs(bench.biasVector + bench.cmdVector));


	    phiArray = naomi.measure.phase(bench) - phiRefArray;
	    allPhiArray(:,:,s) = phiArray(:,:);

		% Get PtV, and Rms without TT
	    outputArray(s,3) = max(phiArray(:)) - min(phiArray(:));
	    outputArray(s,4) = naomi.compute.rms_tt(phiArray);
    end
    strokeData = naomi.data.Stroke(outputArray, h, {bench});

    if config.plotVerbose
    	naomi.plot.figure('Modal Stroke'); clf;
    	strokeData.plot();
    end
end