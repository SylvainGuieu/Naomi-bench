function [residualVector, gainVector] = ztpDifference(ZtPArray, ZtPRefArray, nZerMax)
	% compute.ztpDifference compare two Zernike to phase Array
	% typicaly one measured and one theoritical
	% 
	%  [gainVector, residualVector] = ztpDifference(ZtPArray, ZtPRefArray)
	%  [gainVector, residualVector] = ztpDifference(ZtPArray, ZtPRefArray, nZerMax)
	%  
	% ZtPArray : the  Zernike to Phase array 
	% ZtPRefArray : the Zernike to Phase array to compare to 
	% nZerMax : the maximum number of zernike to use (set the output dimension)
	%
	% residualVector [nZer] : The vector of computed residuals
	% gainVector [nZer] : The vector of measured gain from the ZtPArray 
    [nZer,nSubAperture,~] = size(ZtPArray);
	nZer = min(nZer,nZerMax);			
	ZtPRefArray = ZtPRefArray(1:nZer,:,:);
	ZtPArray = ZtPArray(1:nZer,:,:);

	% Compute a version of ZtP over the Z pupil
	% (assume mode 1 is piston, and has NaN outside)
	mask = ZtPRefArray(1,:,:);
	ZtPm = bsxfun(@times,ZtPArray,reshape(mask,1,nSubAperture,nSubAperture));


	% Compute piston and remove since arbitrary
	pistonVector = naomi.compute.nanmean(reshape(ZtPm,nZer,nSubAperture*nSubAperture),2);
	ZtPm = bsxfun(@minus,ZtPm,reshape(pistonVector,nZer,1,1));
    
    pistonVector = naomi.compute.nanmean(reshape(ZtPRefArray,nZer,nSubAperture*nSubAperture),2);
	ZtPRefm = bsxfun(@minus,ZtPRefArray,reshape(pistonVector,nZer,1,1));
    

	% Compute gainVector
	gainVector = naomi.compute.nanstd(reshape(ZtPm,nZer,nSubAperture*nSubAperture),2);

	% Multiply reference by gain:
	ZtPRefm = ZtPRefm * median(gainVector);

	% Residual across the pupil
	residualVector = naomi.compute.nanstd(reshape(ZtPRefm - ZtPm,nZer,[]),2);
end