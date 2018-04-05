function pupillMask(bench, varargin)
	% Configure the Mask for the WFS 
	% - bench : the bench object 
	% - pupillDiameter : the Pupill diamter for the mask in [m]
	%                    if not given takes the bench.config.ztcPupillDiameter
	% - xCenter, yCenter : position of the pupill center 
	%                      if not given takes the one defined in bench
	%                      normaly measure at startup
	% - centralObscurtion : central obscurtion in [m]
	naomi.config.mask(naomi.make.pupillMask(bench,  varargin{:}));
end