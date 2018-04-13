function phase(bench)
		% plot the last phase received  
		
	    phase = bench.lastPhaseArray;
		if isempty(phase)
			clf;
			title('No phase screen received yet');
			return 
		end	    
		

        clf; imagesc(phase);		        
        if bench.isPhaseReferenced  
        	tit = 'Phase screen - reference'; 
        else  
        	tit = 'Phase screen'; 
        end 
        	
        	
        title({tit,...
               sprintf('rms=%.3fum ptv=%.3fum',...
               naomi.compute.nanstd(phase(:)),...
               max(phase(:)) - min(phase(:)))});
        xlabel('Y   =>+');
        ylabel('+<=   X');
        colorbar;    
end