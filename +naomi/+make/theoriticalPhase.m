function [phaseArray] = theoriticalPhase(bench, zernike, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    P = naomi.parseParameters(varargin, {'ztcMode', 'xCenter','yCenter','nZernike', 'mask', 'angle', 'orientation'}, 'make.theoriticalPhase');
    ztcMode    = naomi.getParameter([], P, 'ztcMode', [], []); % empty ztcMode is the bench default
    mask =  naomi.getParameter([], P, 'mask', [], []); % mask is empty take the one of the given ztcMode 
    xCenter  = naomi.getParameter([], P, 'xCenter', [], bench.xCenter);
    yCenter  =  naomi.getParameter([], P, 'yCenter', [], bench.yCenter);
    amplitude = naomi.getParameter([], P, 'amplitude', [], 1.0);
    angle = naomi.getParameter([], P, 'angle', [], bench.dmAngle);
    
    
    if isempty(mask)
        [mask, ~,  ~, ~, ~, orientation] = bench.ztcParameters(ztcMode, 'pixel'); 
        orientation = naomi.getParameter([], P, 'orientation', [], orientation); % check if not overwriten 
    else
        mask = bench.getPupillMask(mask, 'pixel');
        orientation = naomi.getParameter([], P, 'orientation', [], 'xy');
    end
    
    pupillDiameterPix = mask{1};
    centralObscurationPix = mask{2};
    
    phaseArray = naomi.compute.theoriticalPhase(bench.nSubAperture, ...
                                                xCenter, ...
                                                yCenter, ...
                                                pupillDiameterPix,...
                                                centralObscurationPix, ...
                                                zernike, ...
                                                orientation, angle);
    phaseArray = phaseArray*amplitude;                                      
%     K = naomi.KEYS;
%     h = {{K.ZERN, zernike, K.ZERNc}};
%     phaseData = naomi.data.Phase(phaseArray* amplitude, h);
                               
end

