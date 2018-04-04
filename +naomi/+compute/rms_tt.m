function Rms = rms_tt(phi)
% rms_tt Compute the RMS of a phase screen filtering the Tilt/tilt
%
%   Rms = rms_tt(phi)
%
%   The input phase screen can contain NaN, they will be ignored
%   properly. The toutput is 0.0 for a constant phase screen.
%   The function actully call nanstd.
%
%   phi(Nsub,Nsub): input phase screen, can contain NaN
%   
%   Rms: output rms

% Get size
[Nsub,~] = size(phi);
[Y,X] = meshgrid(1:Nsub,1:Nsub);

% Clean tip-tilt
phic = phi;
xdelta = diff(phic);
phic = phic - (X-Nsub/2) * median(xdelta(~isnan(xdelta)));
ydelta = diff(phic');
phic = phic - (Y-Nsub/2) * median(ydelta(~isnan(ydelta)));

Rms = naomi.compute.nanstd(phic(:));
% Ptv = max(phic(:)) - min(phic(:));
end

