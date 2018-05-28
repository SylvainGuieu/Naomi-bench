function [phaseArray] = theoriticalPhase(bench, zernike, amplitude, ztcMode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
     if nargin<4; ztcMode = []; end % take the default 
    [mask, ~, ~, ~, ~, ztcOrientation] = bench.ztcParameters(ztcMode, 'pixel');
    pupillDiameterPix = mask{1};
    centralObscurationPix = mask{2};
    phaseArray = naomi.compute.theoriticalPhase(bench.nSubAperture, ...
                                                bench.xCenter, ...
                                                bench.yCenter, ...
                                                pupillDiameterPix,...
                                                centralObscurationPix, ...
                                                zernike, ...
                                                ztcOrientation);
    phaseArray = phaseArray*amplitude;                                      
%     K = naomi.KEYS;
%     h = {{K.ZERN, zernike, K.ZERNc}};
%     phaseData = naomi.data.Phase(phaseArray* amplitude, h);
                               
end

