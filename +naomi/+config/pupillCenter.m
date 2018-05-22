function success = pupillCenter(bench, xCenter, yCenter)
	% 
	% setup the pupill center as measured by naomi.measure.pupillCenter
	success = false;
    
	bench.measuredPupillXcenter = xCenter;
	bench.measuredPupillYcenter = yCenter;
	bench.log(sprintf('Pupill center configured as xCenter=%.2f yCenter=%.2f ', xCenter, yCenter), 2);
	success = true;
end