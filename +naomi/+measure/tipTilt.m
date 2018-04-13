function [tip,tilt] = tipTilt(bench)
	% measure a phase screen and compute its tiptil 
	% tip and tilt are in micro meter rms 
	wfs = bench.wfs;
	phaseArray = naomi.measure.phase(bench, [], false); % measure phase without removing tiptilt
	[tip, tilt] = naomi.compute.tipTilt(phaseArray);
end