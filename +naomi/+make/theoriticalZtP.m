function [ZtPArray,PtZArray] = theoriticalZtP(bench, varargin)
	% Theoretical zernike to phase for the bench 
	nSubAperture = bench.nSubAperture;	
	P = naomi.parseParameters(varargin, {'ztcMode', 'xCenter','yCenter', 'nZernike', 'mask', 'angle', 'orientation'}, 'make.theoriticalZtP');
    
    ztcMode    = naomi.getParameter([], P, 'ztcMode', [], []); % empty ztcMode is the bench default
    mask =  naomi.getParameter([], P, 'mask', [], []); % mask is empty take the one of the given ztcMode 
    
    xCenter  = naomi.getParameter([], P, 'xCenter', [], bench.xCenter);
    yCenter  =  naomi.getParameter([], P, 'yCenter', [], bench.yCenter);
    nZernike = naomi.getParameter([], P, 'nZernike', [], bench.nZernike);
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
    
	[ZtPArray,PtZArray] = naomi.compute.theoriticalZtP(nSubAperture, xCenter, yCenter, pupillDiameterPix, centralObscurationPix, nZernike, orientation, angle);
end