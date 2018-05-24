function [xS,yS] = IFMScale(IFM, actuatorSeparation, orientation)
	% IFMScale  Copute the scale of IFM
	%
	%   The scale in mm/pix assuming 2.5mm between
	%   consecutive actuators.
	%
	%   IFM:     Input matrix of Influence Function (nActuator,nSubAperture,nSubAperture)
  %   
	%   [xS,yS]: [meter/pixel] output scale in x and y direction. 
  %   actuatorSeparation : [meter] the transversal separation distance between actuator
  %   orientation : 'yx', 'xy', etc ... (see config) phase to dm orientation 
	% Collapse IFM in x and y
    if nargin<2
        orientation = 'yx';
    end
	IfXArray = squeeze(naomi.compute.nansum(IFM,3));
	IfYArray = squeeze(naomi.compute.nansum(IFM,2));

	% Parameters
	[i,j,~] = naomi.compute.actuatorPosition(orientation);
	N = 2048*4;

	% Compute scaling in m/pix, assuming
	% 5mm period in the above signals
	% Discard the 100-first frequencies
	xVector = (sum(IfXArray(~mod(i,2),:),1) - sum(IfXArray(~~mod(i,2),:),1));
	xFFTVector = abs(fft(xVector(~isnan(xVector)),N));
	xFFTVector(1:100) = 0.0;
	[~,xf] = max(xFFTVector(1:N/2));
	xS = actuatorSeparation*2 / (N./xf);

	yVector = (sum(IfYArray(~mod(j,2),:),1) - sum(IfYArray(~~mod(j,2),:),1));
	yFFTVector = abs(fft(yVector(~isnan(yVector)),N));
	yFFTVector(1:100) = 0.0;
	[~,yf] = max(yFFTVector(1:N/2));
	yS = actuatorSeparation*2 / (N./yf);

end

