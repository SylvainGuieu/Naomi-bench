function [Gain, Res] = compareZtP(ZtPArray, ZtPRefArray, NzerMax)
	
	% sizes
    [Nzer,Nsub,~] = size(ZtPArray);
	Nzer = min(Nzer,NzerMax);			
	ZtPRefArray = ZtPRefArray(1:Nzer,:,:);
	ZtPArray = ZtPArray(1:Nzer,:,:);

	% Compute a version of ZtP over the Z pupil
	% (assume mode 1 is piston, and has NaN outside)
	mask = ZtPRefArray(1,:,:);
	ZtPm = bsxfun(@times,ZtPArray,reshape(mask,1,Nsub,Nsub));

	% Compute piston and remove since arbitrary
	Pst = naomi.compute.nanmean(reshape(NtPm,Nzer,Nsub*Nsub),2);
	NtPm = bsxfun(@minus,NtPm,reshape(Pst,Nzer,1,1));

	% Compute gain
	Gain = naomi.compute.nanstd(reshape(NtPm,Nzer,Nsub*Nsub),2);

	% Multiply reference by gain:
	ZtPm = ZtPm * median(Gain);

	% Residual across the pupil
	Res = naomi.compute.nanstd(reshape(ZtPm - NtPm,Nzer,[]),2);
end