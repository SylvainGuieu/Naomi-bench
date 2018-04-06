function strokeData = stroke(bench,zerniqueMode,amplitudeVector)
	config = bench.config;
	wfs = bench.wfs;
	dm = bench.dm;

	if nargin<3
		maxAmp = 1./max(abs(dm.zernike2Command(zerniqueMode,:)));
		amplitudeVector = linspace(config.strokeMinAmpFrac*maxAMp, config.strokeMaxAmpFrac*maxAMp, config.strokeNstep);
	end

	[Nstep,~] = size(amplitudeVector(:));
	outputArray =  zeros(Nstep, 4);
	outputArray(:,1) = amplitudeVector;
	allPhiArray = zeros(Nsub,Nsub,Nstep);

	dm.Reset();
	
	wfs.Reset();

	phiRefArray = naomi.measure.phase(bench);
	h = {
		  {'MJD-OBS', config.mjd, 'MJD at script startup'}, 
		  {'MODE', zerniqueMode, 'Zernique mode used'}
		};
	for s=1:Nstep
	    % Set DM
	    dm.zernikeVector(zerniqueMode) = amplitudeVector(s) * (1).^(s-1);
	    if config.plotVerbose; dm.DrawMonitoring();end;
	    outputArray(s,2) = max(abs(dm.biasVector + dm.cmdVector));


	    phiArray = naomi.measure.phase(bench) - phiRefArray;
	    allPhiArray(:,:,s) = phiArray(:,:);

		% Get PtV, and Rms without TT
	    outputArray(s,3) = max(phiArray(:)) - min(phiArray(:));
	    outputArray(s,4) = naomi.compute.rms_tt(phiArray);
    end
    strokeData = naomi.data.Stroke(outputArray, h, {bench});

    if config.plotVerbose
    	bench.config.figure('Modal Stroke'); clf;
    	strokeData.plot();
    end
end