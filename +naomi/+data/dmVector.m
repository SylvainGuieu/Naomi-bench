classdef dmVector < naomi.data.BaseData
	properties
	
    % the dmMask array is cached here 
	dmMask;
    % clip the command to +1 -1 in plot
    clipped = true; 
	end	

    
	methods
        function obj = dmVector(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'DM_VECTOR', ''}};
        end

    	function plot(obj, axes)
            if nargin<2; axes= gca();end;
    		if isempty(obj.dmMask)
	    		[xi,yi,mask] = naomi.compute.actuatorPosition();
	    		dmMask = mask;
	    	end
            [nActY, nActX] = size(mask);
            
	    	values = mask*1.0;
    		values(mask) = mask(mask).*obj.data;
    		values(~mask) = nan;
            % clip to +1 / -1
            if obj.clipped
                values(values>1) = 1.0;
                values(values<-1) = -1.0;
            end
    		cla(axes); imagesc(axes, values);
            colorbar(axes);    
            xlim(axes, [1,nActX]);
            ylim(axes, [1,nActY]);
            daspect(axes, [1 1 1]);
            
    	end
 	end
end