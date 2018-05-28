function [dX,dY,dTip,dTilt,dFoc] = missalignment(phaseArray, diameter, orientation)
	% measure the miss alignment of the mirror
	% measure it from a given phase screen or take a phase screen if not given.  
	% Return 
	% - dX: in pixel
	% - dY: in pixel
	% - dTip : in um rms
	% - dTilt  : in um rms  
	% - dFoc  : un um rms 
    
    if nargin<3
        orientation = 'xy';    	
    end
    
	
	[nSubAperture, ~]= size(phaseArray);
	x0 = nSubAperture/2;
    y0 = nSubAperture/2;
   
    [xTarget, yTarget] = naomi.compute.pupillCenter(phaseArray);
    
	[~,PtZ] = naomi.compute.theoriticalZtP(nSubAperture,xTarget,yTarget,diameter,0.0,4, orientation);
    
	zer = naomi.compute.nanzero(phaseArray(:)') * reshape(PtZ,[],4);
	dX = (xTarget-x0);
	dY = (yTarget-y0);
	dTip  = zer(2);
	dTilt = zer(3);
	dFoc  = zer(4);	
end