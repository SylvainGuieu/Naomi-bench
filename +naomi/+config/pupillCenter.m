function success = pupillCenter(bench, xCenter, yCenter)
	% 
	% setup the pupill center as measured by naomi.measure.pupillCenter
	success = false;
    
	bench.measuredPupillXcenter = xCenter;
	bench.measuredPupillYcenter = yCenter;
	bench.config.log(sprintf('Pupill center configured xS=%.2f yX=%.2f ', xCenter, yCenter), 2);
	success = true;
end