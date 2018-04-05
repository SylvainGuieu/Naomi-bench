classdef PtZ < naomi.data.PhaseCube
	properties
	

	end	
	methods
        function obj = PtZ(varargin)
            obj = obj@naomi.data.PhaseCube(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ZTP_MATRIX', ''}};
        end
        
        function plotOneMode(obj, z)
        	clf; 
        	imagesc(squeeze(obj.data(:,:,z))); 
        	colorbar;
		    title(sprintf('Mode %i',z));
		    xlabel('Y  =>'); ylabel('<=  X');
        end

    	function plot(obj)
            IF = obj.data;
            clf; imagesc(IF);
            ttl = 'Zernique to command';
            title(ttl);                    
            xlabel('Zerniques');
            ylabel('commands');
            colorbar;    
     	end
 	end
end