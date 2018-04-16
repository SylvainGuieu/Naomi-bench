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
    	function plot(obj, axes)
            if nargin <2; axes = gca; end;
            IF = obj.data;
            cla(axes); imagesc(axes, IF);
            ttl = 'Zernique to command';
            title(axes, ttl);                    
            xlabel(axes, 'Zerniques');
            ylabel(axes, 'commands');
            colorbar(axes);    
     	end

        function ZtCSpartaData = toSparta(obj)
            ZtCSpartaData = naomi.data.ZtCSpartaData(obj.data, obj.header, obj.context);
        end
 	end
end