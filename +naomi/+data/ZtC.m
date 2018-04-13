classdef ZtC < naomi.data.BaseData
	properties
	

	end	
	methods
        function obj = ZtC(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
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

        function ZtCSpartaData = toSparta(obj)
            ZtCSpartaData = naomi.data.ZtCSpartaData(obj.data, obj.header, obj.context);
        end
 	end
end