function [xS,yS] = IFMScale(IFM)
	% IFMScale  Copute the scale of IFM
	%
	%   The scale in mm/pix assuming 2.5mm between
	%   consecutive actuators.
	%
	%   IFM:     Input matrix of Influence Function (nActuator,nSubAperture,nSubAperture)
	%   [xS,yS]: output scale in x and y direction. 

	% Collapse IFM in x and y
	IfXArray = squeeze(naomi.compute.nansum(IFM,3));
	IfYArray = squeeze(naomi.compute.nansum(IFM,2));

	% Parameters
	[i,j,~] = naomi.compute.actuatorPosition();
	N = 2048*4;

	% Compute scaling in m/pix, assuming
	% 5mm period in the above signals
	% Discard the 100-first frequencies
	xVector = (sum(IfXArray(~mod(i,2),:),1) - sum(IfXArray(~~mod(i,2),:),1));
	xFFTVector = abs(fft(xVector(~isnan(xVector)),N));
	xFFTVector(1:100) = 0.0;
	[~,xf] = max(xFFTVector(1:N/2));
	xS = 5.0e-3 / (N./xf);

	yVector = (sum(IfYArray(~mod(j,2),:),1) - sum(IfYArray(~~mod(j,2),:),1));
	yFFTVector = abs(fft(yVector(~isnan(yVector)),N));
	yFFTVector(1:100) = 0.0;
	[~,yf] = max(yFFTVector(1:N/2));
	yS = 5.0e-3 / (N./yf);

end

