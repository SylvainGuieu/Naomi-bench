function phase(bench, axes) 
		% plot the last phase received  
		if nargin<2; axes = gca; end;
        
	    phase = bench.lastPhaseArray;
		if isempty(phase)
			cla(axes);
			title(axes,'No phase screen received yet');
			return 
		end	    
		

        cla(axes); imagesc(axes, phase);		        
        if bench.isPhaseReferenced  
        	tit = 'Phase screen - reference'; 
        else  
        	tit = 'Phase screen'; 
        end 
        	
        	
        title(axes, {tit,...
               sprintf('rms=%.3fum ptv=%.3fum',...
               naomi.compute.nanstd(phase(:)),...
               max(phase(:)) - min(phase(:)))});
        naomi.plot.phaseAxesLabel(axes, bench.orientation);
        colorbar(axes);    
end