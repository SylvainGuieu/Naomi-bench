function success = pupillMask(bench, varargin)
	% Configure the Mask for the WFS
	%
	% configure.pupillMask(bench)
	% configure.pupillMask(bench, 28e-3)
	% configure.pupillMask(bench, 28e-3, 3.2, 5.6)
	% configure.pupillMask(bench, 28e-3, 3.2, 5.6, 1.5e-3)
	% - bench : the bench object 
	% all other parameters are optional they are taken from config if not given
	% - pupillDiameter : the Pupill diamter for the mask in [m]
	%                    if not given takes the bench.config.ztcPupillDiameter
	% - xCenter, yCenter : position of the pupill center 
	%                      if not given takes the one defined in bench
	%                      normaly measure at startup
	% - centralObscurtion : central obscurtion in [m] if not given 
	%						takes the bench.config.ztcCentralObscurtionDiameter	
	naomi.config.mask(bench, naomi.make.pupillMask(bench,  varargin{:}));
	success = true;
end