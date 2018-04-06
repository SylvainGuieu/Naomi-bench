function isConfigured = pixelScale(bench, xScale, yScale)
	% 
	% setup the pixel scale should in m/pix
	if nargin<2
		isConfigured = ~isempty(bench.xScale);
		return 
	end
	
	if nargin==2
		if ischar(xScale)
		switch xScale
		case 'measure'
			[xScale, yScale] = naomi.measure.pixelScale(bench);
		otherwise
			error('isConfigured accept only "measure" as a char argument')
		end
	end


	isConfigured = true;
	bench.xPixelScale = xScale;
	bench.yPixelScale = yScale;
	bench.config.log(sprintf('Pixel scale configured  xS=%.2f yX=%.2f ', xScale, yScale), 2);
end