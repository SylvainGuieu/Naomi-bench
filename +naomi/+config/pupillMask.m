function success = pupillMask(bench, mask, maskCenter)
	% Configure the Mask for the WFS
	%
	% configure.pupillMask(bench)
	% configure.pupillMask(bench, 28e-3)
	% configure.pupillMask(bench, 28e-3, 3.2, 5.6)
	% configure.pupillMask(bench, 28e-3, 3.2, 5.6, 1.5e-3)
	% - bench : the bench object 
	% all other parameters are optional they are taken from config if not given
	% - mask : can be :
  %            -a string: name matching a mask defined in config 
  %                      bench.config.maskChoices gives a list of mask names
  %            -a 3 cell array defining {diameter, central-obscuration-diameter, unit}
  %                      unit must be 'm' or 'pixel'
  %            -a Matrix only the dimention of the matrix is checked, the mask is 
  %                       then return as is. Or an error is raised. If maskCenter 
  %                       is given it will be ignored
  % - maskCenter  (optional) is a 2 array giving the [xCenter yCenter] of the mask in pixel
  %               if mask center is not given, the previously measured (or default) mirror center 
	%               will be taken 
	if nargin<3; maskCenter = []; end
	if nargin<2;mask = bench.config.ztcMask; end
	[~,maskData] = naomi.make.pupillMask(bench,  mask, maskCenter);
	naomi.config.mask(bench, maskData);
	
	success = true;
end