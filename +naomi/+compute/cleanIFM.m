function IFM_clean = cleanIFM (IFM, rad, prc)
% cleanIFM  Remove piston and tip-tilt from
%           Influence Function matrix.
%
%   IFM_clean = cleanIFM (IFM, rad, prc)
%
%   For each Influence Function, a radius of rad pixel around
%   its maximum is discarded, supposedly containing most of
%   the actuator influence. The remainging part is considered
%   to be the 'floor', where tip/tilt and piston are estimated.
%   These tip/tilt/piston are then removed from the full
%   influence function.
% 
%   IFM(Nact,Nsub,Nsub): input Influence Functions
%   rad: radius to be discarded around each actuator
%   prc: percentile to define the piston in the floor
%
%   IFM_clean(Nact,Nsub,Nsub): output Influence Functions

size_IFM = size(IFM);
Nsub = size_IFM(2);
Nact = size_IFM(1);

if rad > 0.5*Nsub
    error('Radius is too large');
end

% Verbose
fprintf('Clean IFM with rad=%ipix and prc=%.1f%%\n',rad,prc);

% Pixel grid
[Y,X] = meshgrid(1:Nsub,1:Nsub);

% Clean output
IFM_clean = zeros(Nact,Nsub,Nsub);

% Loop on actuators
for a=1:Nact
    ctp = squeeze(IFM(a,:,:));
    
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
    ctp = ctp - (X-Nsub/2) * median(xdelta(~isnan(xdelta)));
    ydelta = diff(transpose(ctp_f));
    ctp = ctp - (Y-Nsub/2) * median(ydelta(~isnan(ydelta)));
    
    % Clean piston with percentil
    ctp_f = ctp;
    ctp_f(maska) = NaN;
    ctp_fs = sort(abs(ctp_f(~isnan(ctp_f))));
    idx = int32(prc/100.0*length(ctp_fs));
    piston = ctp_fs(idx);
    ctp = ctp - piston;
    
    % Set Back
    IFM_clean(a,:,:) = ctp;
end

end

