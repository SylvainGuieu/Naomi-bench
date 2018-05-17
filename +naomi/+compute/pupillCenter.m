function [x,y] = pupillCenter(phaseArray)
	% measure the miss alignment of the mirror
	% measure it from a given phase screen or take a phase screen if not given.  
	% Return 
	% - dX: in pixel
	% - dY: in pixel
	% - dTip : in um rms
	% - dTilt  : in um rms  
	% - dFoc  : un um rms 
    
	[nSubAperture, ~]= size(phaseArray);
	% Filter pixel with light 
	alight = ~isnan(phaseArray);
	[xArray,yArray] = meshgrid(1:nSubAperture, 1:nSubAperture);
	norm = sum(sum(alight));
	x = sum(sum(alight.*xArray))./norm;
	y = sum(sum(alight.*yArray))./norm;
end