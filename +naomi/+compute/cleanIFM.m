function IFM_clean = cleanIFM (IFM, rad, prc)
% compute.cleanIFM  Remove piston and tip-tilt from
%                   Influence Function matrix.
%   
%   IFM_clean = compute.cleanIFM (IFM, rad, prc)
%
%   For each Influence Function, a radius of rad pixel around
%   its maximum is discarded, supposedly containing most of
%   the actuator influence. The remainging part is considered
%   to be the 'floor', where tip/tilt and piston are estimated.
%   These tip/tilt/piston are then removed from the full
%   influence function.
% 
%   IFM(nActuator,nSubAperture,nSubAperture): input Influence Functions
%   rad: radius to be discarded around each actuator
%   prc: percentile to define the piston in the floor
%
%   IFM_clean(nActuator,nSubAperture,nSubAperture): output Influence Functions

[nActuator, nSubAperture] = size(IFM);

if rad > 0.5*nSubAperture
    error('Radius is too large');
end

% Verbose
fprintf('Clean IFM with rad=%ipix and prc=%.1f%%\n',rad,prc);

% Pixel grid
[X,Y] = meshgrid(1:nSubAperture);

% Clean output
IFM_clean = zeros(nActuator,nSubAperture,nSubAperture);

% Loop on actuators
for iActuator=1:nActuator
    ctp = squeeze(IFM(iActuator,:,:));
    
    % Remove median piston
    ctp = ctp - median(ctp(~isnan(ctp)));
    
    %FIXME: Gerer convenablement les actionneurs inverses 
    
    % Discard pixels around the actuator
    [~,idx] = max(abs(ctp(:)));
    [xA,yA] = ind2sub(size(ctp),idx);
    maska = (X-xA).^2 + (Y-yA).^2 < (rad*rad);
    ctp_f = ctp;
    ctp_f(maska) = NaN;
        
    % Clean tip-tilt
    xdelta = diff(ctp_f);
    ctp = ctp - (X-nSubAperture/2) * median(xdelta(~isnan(xdelta)));
    ydelta = diff(transpose(ctp_f));
    ctp = ctp - (Y-nSubAperture/2) * median(ydelta(~isnan(ydelta)));
    
    % Clean piston with percentil
    ctp_f = ctp;
    ctp_f(maska) = NaN;
    ctp_fs = sort(abs(ctp_f(~isnan(ctp_f))));
    idx = int32(prc/100.0*length(ctp_fs));
    piston = ctp_fs(idx);
    ctp = ctp - piston;
    
    % Set Back
    IFM_clean(iActuator,:,:) = ctp;
end

end

