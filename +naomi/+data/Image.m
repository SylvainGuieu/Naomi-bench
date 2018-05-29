classdef Image < naomi.data.BaseData
	properties
	
	end	
	methods
        function obj = Image(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'DPR_TYPE', 'IMAGE',naomi.KEYS.DPRTYPE}};
        end
        function plot(obj, axis)
            if nargin<2; axis = gca; end
            imagesc(axis, obj.data); 
            colorbar(axis);
        end
    end
end