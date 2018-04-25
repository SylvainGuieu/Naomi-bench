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
            naomi.plot.phaseAxesLabel(  axes, obj.getKey(naomi.KEYS.ORIENT, naomi.KEYS.ORIENTd));
		    
        end

    	function plot(obj, axes)
            if nargin<2; axes= gca;end;
            IF = obj.data;
            cla(axes); imagesc(axes, IF);
            ttl = 'Zernique to command';
            title(axes, ttl);                    
            xlabel(axes, 'Zerniques');
            ylabel(axes, 'commands');
            colorbar(axes);    
     	end
 	end
end