function phaseArray = phase(bench, nPhase, filterTipTilt, substractReference)
	% phaseArray = phase(bench)
	% phaseArray = phase(bench, nPhase)
	% phaseArray = phase(bench, nPhase, filterTipTilt)
	%  
	% Measure a phase. The raw phase is receive from the 
	% wave front. Then the reference is removed (if any configured).
	% and eventually the tip tilt is removed if filterTipTilt is true
	% 
	% nPhase: is the number of phase taken and averaged
    % filterTipTilt: true/false if not given or empty takes bench.filterTipTilt
    % substractReference: true/false if not given takes bench.substractReference
	if nargin<2 || isempty(nPhase); 
		nPhase = bench.config.defaultNphase;
	end
	if nargin<3 || isempty(filterTipTilt); filterTipTilt = bench.filterTipTilt; end;
	if nargin<4 || isempty(substractReference); substractReference = bench.substractReference; end;

	nSubAperture = bench.nSubAperture;
	phase = zeros(nSubAperture, nSubAperture)*0.0;
	

	maskArray = bench.maskArray;
	
	simulated = bench.config.simulated;
	for iPhase=1:nPhase

		if simulated
			rawPhaseArray = bench.simulator.getRawPhase();
		else
			rawPhaseArray = bench.wfs.getRawPhase();
		end
		% Apply the mask 
		rawPhaseArray(maskArray~=1) = NaN;
		if bench.checkPhase(rawPhaseArray)
            bench.config.log('Warning Invalid sup-appertures inside the mask !!');
        end

        % Remove mean
        rawPhaseArray = rawPhaseArray - mean(rawPhaseArray(~isnan(rawPhaseArray)));

        phaseArray = phaseArray + rawPhaseArray  / nPhase;
    end



    % Remove the reference
    if substractReference
	    phaseArray = phaseArray - bench.phaseReferenceArray;
	end
	
	if filterTipTilt
		[tip,tilt] = naomi.compute.tipTilt(phaseArray);
		[yArray,xArray] = meshgrid(1:nSubAperture, 1:nSubAperture);
      	phaseArray = phaseArray + (xArray-nSubAperture/2) * tip;
      	phaseArray = phaseArray + (yArray-nSubAperture/2) * tilt;
	end
	% Remove the mean
    phaseArray = phaseArray - mean(phaseArray(~isnan(phaseArray)));


	bench.lastPhaseArray = phaseArray;
	if bench.config.plotVerbose
		naomi.config.figure('Last Phase');
		naomi.plot.phase(bench);
	end
end