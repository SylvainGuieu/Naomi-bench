function [residual, gain, residualArray] = phaseDifference(phaseArray, phaseRefArray)
	% compute.phaseDifference compare two phases Array
	% typicaly one measured and one theoritical representing the same mode
	% 
	%  [residual, gain] = phaseDifference(phaseArray, phaseRefArray)
	%  

   

	% Compute a version of ZtP over the Z pupil
	% 

    maskedPhaseArray = phaseArray;
    maskedPhaseArray(isnan(phaseRefArray)) = nan;
    


	% Compute piston and remove since arbitrary
	piston = naomi.compute.nanmean(maskedPhaseArray(:));
	maskedPhaseArray = maskedPhaseArray-piston;
    
    piston = naomi.compute.nanmean(phaseRefArray(:));
	phaseRefArray = phaseRefArray-piston;
    

	% Compute gainVector
	gain = naomi.compute.nanstd(maskedPhaseArray(:));

	% Multiply reference by gain:
	phaseRefArray = phaseRefArray .* gain;

    
	% Residual across the pupil
    residualArray = phaseRefArray - maskedPhaseArray;
	residual = naomi.compute.nanstd(residualArray(:));
end