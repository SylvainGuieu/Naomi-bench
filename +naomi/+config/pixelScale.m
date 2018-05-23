function success = pixelScale(bench, xScale, yScale)
	% 
	% setup the pixel scale should in m/pix
	success = false;

	
	bench.measuredXpixelScale = xScale;
	bench.measuredYpixelScale = yScale;
	bench.log(sprintf('NOTICE Pixel scale configured as xS=%.4fmm/pix yS=%.4fmm/pix', xScale*1000, yScale*1000), 2);
	success = true;
end