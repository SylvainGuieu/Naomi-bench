function IFM_t = ComputeIFM(IFM,Amp,Width)
% ComputeIFM  Compute theoretical IFM. Position of actuators
%             are read from the input IFM.
%
%   IFM_t = ComputeIFM (IFM, Amp, Width)
%
%   The position of eactuator is read form the input IFM
%   The gain is similar for all actuators, but the sign is
%   matched to the sign from input IFM. Size is also the same
%   for all actuators. The output synthetic IFM are filled with
%   valid numbers over the NsubxNsub geometry. Floor is zero.
%
%   IFM(Nact,Nsub,Nsub) : input IFM
%   Amp: amplitude of IFM, typically 10
%   Width: widrh of IFM, typically 6.5 pix
%
%   IFM_t(Nact,Nsub,Nsub): synthetic IFM
%

% Get sizes
[Nact,Nsub,~] = size(IFM);

% Pixel grid
[Y,X] = meshgrid(1:Nsub,1:Nsub);

% Create outputs
IFM_t = zeros(Nact,Nsub,Nsub);

% Loop on actuator
for a=1:Nact
    
    % Position of maximum
    ctp = squeeze(IFM(a,:,:));
    [~,idx] = max(abs(ctp(:)));
    [xA,yA] = ind2sub(size(ctp),idx);
   
    % Fill 
    rad = ((X-xA).^2 + (Y-yA).^2) / Width.^2;
    ifm = exp( - rad.^0.75);
    ifm = ifm * Amp * sign(ctp(xA,yA));
    IFM_t(a,:,:) = ifm;
end

end

