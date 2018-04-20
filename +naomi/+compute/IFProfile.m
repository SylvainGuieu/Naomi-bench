function [amplitude, xCenter, xHwhm, yCenter, yHwhm, angle] = IFProfile(IFArray)
	
	if nargout>5
    	args = naomi.compute.gauss2dFit(IFArray, 1);
    else
    	args = naomi.compute.gauss2dFit(IFArray, 0);
    end

    amplitude = args(1);
    xCenter = args(2);
    xHwhm = args(3);
    yCenter = args(4);
    yHwhm = args(5);
    if nargout>5
        angle = args(6);
    end

end
