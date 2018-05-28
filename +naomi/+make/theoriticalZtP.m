function [ZtPArray,PtZArray] = theoriticalZtP(bench, ztcMode, maskCenter, nZernike)
	% Theoretical zernike to phase for the bench 
	nSubAperture = bench.nSubAperture;	
	
	if nargin<2
        ztcMode = [];% will take the defaul
	end
	if nargin<3 || isempty(maskCenter)
		x0 = bench.xCenter;
		y0 = bench.yCenter;
	else
		x0 = maskCenter(1);
		y0 = maskCenter(2);
    end	
    if nargin<4 || isempty(nZernike)
        nZernike = bench.nZernike;
    end
    [mask, ~,  ~, ~, ~, orientation] = bench.config.ztcParameters(ztcMode, 'pixel');
    pupillDiameterPix = mask{1};
    centralObscurationPix = mask{2};
	[ZtPArray,PtZArray] = naomi.compute.theoriticalZtP(nSubAperture,x0,y0, pupillDiameterPix, centralObscurationPix, nZernike, orientation);
end