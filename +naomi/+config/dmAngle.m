function success = dmAngle(bench, angle)
	% 
	% setup the pixel scale should in m/pix
	success = false;

	
	bench.measuredDmAngle = angle;
	
	bench.log(sprintf('NOTICE dmAngle configured as dmAngle=%.4frad',angle), 2);
	success = true;
end