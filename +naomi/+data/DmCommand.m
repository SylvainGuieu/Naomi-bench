classdef DmCommand < naomi.data.BaseData
	properties
	
    % clip the command to +1 -1 in plot
    clipped = true; 
   
    end	
        
    
	methods
        function obj = DmCommand(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'DM_VECTOR', naomi.KEYS.DPRTYPEc}};
        end
        
            
        function nSaturated = nSaturated(obj)
           nSaturated = sum(abs(obj.data)>=1);
        end
        function plot(obj, axes)
            if nargin<2; axes= gca();end;
            
            cmdVector = obj.data;
            plot(axes, cmdVector);            
            title( axes, sprintf('DM Mean = %.1f%%  Max abs = %.1f%%', mean(cmdVector)*100,max(cmdVector)*100));
            xlabel('Actuator'); ylabel('cmd');
        end
        
    	function plotImage(obj, axes)
            if nargin<2; axes= gca();end;
            
            % get the orientation from header 
            orientation = obj.getKey(naomi.KEYS.ORIENT, naomi.KEYS.ORIENTd);
    		
	    	[~,~,mask] = naomi.compute.actuatorPosition(orientation);
            
            [nActY, nActX] = size(mask);
            
	    	values = mask*1.0;
    		values(mask) = mask(mask).*obj.data(':');
    		values(~mask) = nan;
            % clip to +1 / -1
            if obj.clipped
                values(values>1) = 1.0;
                values(values<-1) = -1.0;
            end
    		cla(axes); imagesc(axes, values);
            colorbar(axes);    
            xlim(axes, [1-0.5,nActX+0.5]);
            ylim(axes, [1-0.5,nActY+0.5]);
            daspect(axes, [1 1 1]); %square aspect ratio
            
    	end
 	end
end