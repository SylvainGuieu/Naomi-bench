function [dX,dY,dTip,dTilt,dFoc] = missalignment(bench, phaseArray)
	% measure the miss alignment of the mirror
	% measure it from a given phase screen or take a phase screen if not given.  
	% Return 
	% - dX: in m
	% - dY : in m 
	% - dTip : in um rms
	% - dTilt  : in um rms  
	% - dFoc  : un um rms 
    pscale = bench.meanPixelScale;
    diam = bench.config.fullPupillDiameter;
    orientation = bench.config.phaseOrientation;
    
    [dXPix, dYPix, dTip, dTilt, dFoc] = naomi.compute.missalignment(phaseArray, diam/pscale, orientation);
    dX = dXPix*pscale;
    dY = dYPix*pscale;
end