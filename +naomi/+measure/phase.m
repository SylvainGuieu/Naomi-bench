function [phaseArray, phaseData] = phase(bench, nPhase, filterTipTilt, substractReference, useMask)
	% phaseArray = phase(bench)
	% phaseArray = phase(bench, nPhase)
	% phaseArray = phase(bench, nPhase, filterTipTilt)
	% phaseArray = phase(bench, nPhase, filterTipTilt, useMask)
    %
	% Measure a phase. The raw phase is receive from the 
	% wave front. Then the reference is removed (if any configured).
	% and eventually the tip tilt is removed if filterTipTilt is true
	% 
	% nPhase: is the number of phase taken and averaged
    % filterTipTilt: true/false if not given or empty takes bench.filterTipTilt
    % substractReference: true/false if not given takes bench.substractReference
    % useMask: by default 1 the phase if masked if a mask has been
    %          configured on the bench. Put 0 to unmask (e.g. for aligment)
	if nargin<2 || isempty(nPhase); 
		nPhase = bench.config.defaultNphase;
	end
	if nargin<3 || isempty(filterTipTilt); filterTipTilt = bench.config.filterTipTilt; end;
	if nargin<4 || isempty(substractReference); substractReference = bench.config.substractReference; end;
    if nargin<5 || isempty(useMask); useMask=1;end
	nSubAperture = bench.nSubAperture;
	phaseArray = zeros(nSubAperture, nSubAperture)*0.0;
	

	maskArray = bench.maskArray;
	
	
	for iPhase=1:nPhase

		
        rawPhaseArray = bench.wfs.getRawPhase();
		
		% Apply the mask 
        if useMask
            rawPhaseArray(~maskArray) = NaN;
            if ~bench.checkPhase(rawPhaseArray)
                bench.log('WARNING: Invalid sup-appertures inside the mask !!', 2);
            end
        end

        % Remove mean
        rawPhaseArray = rawPhaseArray - mean(rawPhaseArray(~isnan(rawPhaseArray)));

        phaseArray = phaseArray + rawPhaseArray  / nPhase;
    end



    % Remove the reference
    if substractReference
	    phaseArray = phaseArray - bench.phaseReferenceArray;
	end
	% Remove the tip tilt if needed
	if filterTipTilt
        phaseArray = naomi.compute.tipTiltCleanedPhase(phaseArray);
	end
	% Remove the mean a last time
    phaseArray = phaseArray - mean(phaseArray(~isnan(phaseArray)));

    % save the phasArray in the bench 
	bench.lastPhaseArray = phaseArray;
    % anybody or thing that whatch a new phase can listen to the
    % phaseCounter of the bench
    bench.phaseCounter = bench.phaseCounter + 1;
    % If plot verbose is True plot the phase
	if bench.config.plotVerbose
		naomi.plot.figure('Last Phase', 0);
		naomi.plot.phase(bench);
    end
    
    % if the number of output argument is 2 encapsulate the phase in a
    % phaseData object.
    if nargout>1
        refSubtraced = substractReference && abs(naomi.compute.nansum(bench.phaseReferenceArray(':')))>0.0;
        K = naomi.KEYS;
        h = {{K.NPHASE, nPhase, K.NPHASEc}, ...
             {K.PHASEREF, refSubtraced, K.PHASEREFc}, ...
             {K.PHASETT, logical(filterTipTilt), K.PHASETTc}};
        phaseData = naomi.data.Phase(phaseArray, h);
				bench.populateHeader(phaseData.header);
    end
end