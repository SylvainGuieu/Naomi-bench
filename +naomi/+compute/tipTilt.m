function [tip,tilt] = tipTilt(phiArray)
	% compute the tipTil of a phase screen
    
    xdelta = diff(phiArray);
    ydelta = diff(phiArray');
    
    tip  = median(xdelta(~isnan(xdelta)));
    tilt = median(ydelta(~isnan(ydelta)));    	
end