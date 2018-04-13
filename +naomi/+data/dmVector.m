classdef IF < naomi.data.dmVector
	properties
	
	dmMask;
	end	
	methods
        function obj = dmVector(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'DM_VECTOR', ''}};
        end

    	function plot(obj)
    		if isempty(obj.dmMask)
	    		[xi,yi,mask] = naomi.compute.actuatorPosision();
	    		dmMask = mask;
	    	end
	    	values = mask*1.0;
    		values(mask) = mask(mask)*obj.data;
    		values(~mask) = nan;
    		clf; imagesc(values);
            colorbar;    
    	end
 	end
end