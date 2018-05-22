function success = pixelScale(bench, xScale, yScale)
	% 
	% setup the pixel scale should in m/pix
	success = false;

	
	bench.measuredXpixelScale = xScale;
	bench.measuredYpixelScale = yScale;
	bench.log(sprintf('NOTICE Pixel scale configured as xS=%.2f yX=%.2f ', xScale, yScale), 2);
	success = true;
end