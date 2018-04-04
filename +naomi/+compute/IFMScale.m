function [xS,yS] = IFMScale(IFM)
	% IFMScale  Copute the scale of IFM
	%
	%   The scale in mm/pix assuming 2.5mm between
	%   consecutive actuators.
	%
	%   IFM:     Input matrix of Influence Function (Nact,Nsub,Nsub)
	%   [xS,yS]: output scale in x and y direction. 

	% Collapse IFM in x and y
	IFx = squeeze(naomi.compute.nansum(IFM,3));
	IFy = squeeze(naomi.compute.nansum(IFM,2));

	% Parameters
	[i,j,~] = naomi.compute.actPos();
	N = 2048*4;

	% Compute scaling in m/pix, assuming
	% 5mm period in the above signals
	% Discard the 100-first frequencies
	X = (sum(IFx(~mod(i,2),:),1) - sum(IFx(~~mod(i,2),:),1));
	Xf = abs(fft(X(~isnan(X)),N));
	Xf(1:100) = 0.0;
	[~,xf] = max(Xf(1:N/2));
	xS = 5.0e-3 / (N./xf);

	Y = (sum(IFy(~mod(j,2),:),1) - sum(IFy(~~mod(j,2),:),1));
	Yf = abs(fft(Y(~isnan(Y)),N));
	Yf(1:100) = 0.0;
	[~,yf] = max(Yf(1:N/2));
	yS = 5.0e-3 / (N./yf);

end

