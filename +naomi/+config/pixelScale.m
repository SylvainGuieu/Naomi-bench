function success = pixelScale(bench, xScale, yScale)
	% 
	% setup the pixel scale should in m/pix
	success = false;

	
	bench.xPixelScale = xScale;
	bench.yPixelScale = yScale;
	bench.config.log(sprintf('Pixel scale configured  xS=%.2f yX=%.2f ', xScale, yScale), 2);
	success = true;
end