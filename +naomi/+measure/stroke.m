function strokeData = stroke(bench,zernikeMode,amplitudeVector)
	config = bench.config;
	
	if nargin<3 || isempty(amplitudeVector)
		maxAmp = 1./max(abs(bench.ZtCArray(zernikeMode,':')));
		amplitudeVector = linspace(config.strokeMinAmpFrac*maxAmp, config.strokeMaxAmpFrac*maxAmp, config.strokeNstep);
	end

	[Nstep,~] = size(amplitudeVector(:));
    nSubAperture = bench.nSubAperture;
	outputArray =  zeros(Nstep, 6);
	outputArray(:,1) = amplitudeVector;
	allPhiArray = zeros(nSubAperture,nSubAperture,Nstep);

	naomi.action.resetDm(bench);
	naomi.action.resetWfs(bench);

	phiRefArray = naomi.measure.phase(bench);
	h = {
		  {'MJD-OBS', config.mjd, 'MJD at script startup'}, 
		  {'MODE', zernikeMode, 'Zernike mode used'}
		};
    
    theoriticalPhase = squeeze(naomi.make.theoriticalPhase(bench, zernikeMode, 1.0));
	for s=1:Nstep
	    % Set DM
	    naomi.action.cmdModal(bench, zernikeMode, amplitudeVector(s) * (1).^(s-1));
	    outputArray(s,2) = max(abs(bench.biasVector + bench.cmdVector));


	    phiArray = naomi.measure.phase(bench) - phiRefArray;
	    allPhiArray(:,:,s) = phiArray(:,:);
        
        residualArray = phiArray - theoriticalPhase.*amplitudeVector(s);
        figure(6); imagesc(residualArray);title(sprintf('%.3f',naomi.compute.nanstd(phiArray(:))));
        figure(7); imagesc(phiArray);title(sprintf('%.3f',naomi.compute.nanstd(residualArray(:))));
		% Get the PtV
	    outputArray(s,3) = max(phiArray(:)) - min(phiArray(:));
        outputArray(s,5) = max(residualArray(:)) - min(residualArray(:));
        
        
        % remove the TT only for tip, tilt and piston
        if zernikeMode < 0
            outputArray(s,4) = naomi.compute.nanstd(phiArray(:));
            outputArray(s,6) = naomi.compute.nanstd(residualArray(:));
        else
            outputArray(s,4) = naomi.compute.rms_tt(phiArray);
            outputArray(s,6) = naomi.compute.rms_tt(residualArray);
        end
        
        
    end
    strokeData = naomi.data.Stroke(outputArray, h, {bench});

    if config.plotVerbose
    	naomi.plot.figure('Modal Stroke'); clf;
    	strokeData.plot();
    end
end