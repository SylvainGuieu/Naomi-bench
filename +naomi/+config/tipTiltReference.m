function tipTiltReference(bench, tip, tilt)
	% remove the given tip and tilt to the Phase reference array 
	phaseReferenceArray = bench.phaseReferenceArray;

	[nSubAperture, ~] = size(phaseReferenceArray);
	[yArray,xArray] = meshgrid(1:nSubAperture, 1:nSubAperture);
    phaseReferenceArray = phaseReferenceArray + (xArray-nSubAperture/2) * tip;
    phaseReferenceArray = phaseReferenceArray + (yArray-nSubAperture/2) * tilt;

    % this will also update the bench.phaseReferenceData
    bench.phaseReferenceArray = phaseReferenceArray;
    % make sure all is working 
    bench.measure.phase();

    if bench.config.plotVerbose
		bench.config.figure('Phase Reference');
		bench.phaseReferenceData.plot();
	end	
end