function [x,y] = pupillCenter(bench)
	% measure the central position of the pupill footprint 
	% measure it from a given phase screen or take a phase screen if not given.  
	% Return 
	% - x: in pixel
	% - y: in pixel
	
    [x, y] = naomi.compute.pupillCenter(naomi.measure.phase(bench,1,0,0));
end