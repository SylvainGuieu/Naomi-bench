classdef ZtC < naomi.data.Phase
	properties
	

	end	
	methods
        function obj = ZtC(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ZTC_MATRIX', ''}};
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