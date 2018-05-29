function success = pupillCenter(bench, xCenter, yCenter)
	% 
	% setup the pupill center as measured by naomi.measure.pupillCenter
	success = false;
    
	bench.measuredXpupillCenter = xCenter;
	bench.measuredYpupillCenter = yCenter;
	bench.log(sprintf('NOTICE: Pupill center xCenter=%.2f yCenter=%.2f', xCenter, yCenter), 2);
	success = true;
end