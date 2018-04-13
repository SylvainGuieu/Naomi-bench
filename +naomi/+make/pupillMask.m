function maskData = pupillMask(bench, puppillDiameter, xCenter, yCenter, centralObscurtionDiameter)
	% Make a mask for the WFS
	% - bench : the bench object 
	% - pupillDiameter : the Pupill diamter for the mask in [m]
	%                    if not given takes the bench.config.ztcPupillDiameter
	% - xCenter, yCenter : position of the pupill center 
	%                      if not given takes the one defined in bench
	%                      normaly measure at startup
	% - centralObscurtionDiameter : central obscurtion in [m]
	if nargin<2; pupillDiameter = bench.config.ztcPupillDiameter; end;
	if nargin==3; error('config.mask should take 2 or 4 argument not 3');end
	if nargin<3
		xCenter = bench.xCenter;
		yCenter = bench.yCenter;
		if isempty(xCenter) || isempty(yCenter)
			error('WFs center has not been measured');
		end
	end	
	if nargin==4; centralObscurtionDiameter = bench.config.centralObscurtionDiameter; end;
	
	diamPix = bench.sizePix(pupillDiameter);
	obsPix  = bench.sizePix(centralObscurtionDiameter);
	
	maskArray = naomi.compute(bench.nSubAperture, diamPix, obsPix, xCenter, yCenter);

    h = {{'PUPDIAM', pupillDiameter, 'Mask pupill diameter in [m]'}, 
    	 {'XCENTER', xCenter, 'Mask X Center [pixel]'},
    	 {'YCENTER', xCenter, 'Mask Y Center [pixel]'},
    	 {'OBSCU', centralObscurtionDiameter, 'Mask central obscurtion diameter [m]'}
    	};
    maskData = naomi.data.Mask(maskArray, h, {bench});
end
