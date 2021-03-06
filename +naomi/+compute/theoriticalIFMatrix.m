function IFM_t = theoriticalIFM(IFM,amplitude,iFWidth)
% theoriticalIFM  Compute theoretical IFM. Position of actuators
%             are red from the input IFM.
%
%   tIFM = theoriticalIFM (IFM, amplitude, iFWidth)
%
%   The position of actuator is red form the input IFM
%   The gain is similar for all actuators, but the sign is
%   matched to the sign from input IFM. Size is also the same
%   for all actuators. The output synthetic IFM are filled with
%   valid numbers over the nSubAperturexnSubAperture geometry. Floor is zero.
%
%   IFM(nActuator,nSubAperture,nSubAperture) : input IFM
%   amplitude: amplitude of IFM, typically 10
%   iFWidth: width of IFM, typically 6.5 pix
%
%   tIFM(nActuator,nSubAperture,nSubAperture): synthetic IFM
%

% Get sizes
[nActuator,nSubAperture,~] = size(IFM);

% Pixel grid
[X,Y] = meshgrid(1:nSubAperture); 

% Create outputs
tIFM = zeros(nActuator,nSubAperture,nSubAperture);

% Loop on actuator
for iActuator=1:nActuator
    
    % Position of maximum
    ctp = squeeze(IFM(iActuator,:,:));
    [~,idx] = max(abs(ctp(:)));
    [xA,yA] = ind2sub(size(ctp),idx);
   	
    % Fill 
    rad = ((X-xA).^2 + (Y-yA).^2) / iFWidth.^2;
    ifm = exp( - rad.^0.75);
    ifm = ifm * amplitude * sign(ctp(xA,yA));
    tIFM(iActuator,:,:) = ifm;
end

end

