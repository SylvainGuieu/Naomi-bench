function newPhiArray = tipTiltCleanedPhase(phiArray)
	% compute the tipTil of a phase screen
    
    [nSubAperture,~] = size(phiArray);
    [Y,X] = meshgrid(1:nSubAperture);           
    xdelta = diff(phiArray);
    ydelta = diff(phiArray');
    
    newPhiArray = phiArray;
    
    newPhiArray = newPhiArray + (X-nSubAperture/2) * median(xdelta(~isnan(xdelta)));
    newPhiArray = newPhiArray + (Y-nSubAperture/2) * median(ydelta(~isnan(ydelta))); 	
end