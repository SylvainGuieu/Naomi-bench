classdef DmBias < naomi.data.BaseData
	properties
	
	end	

    
	methods
        function obj = DmBias(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'DM_BIAS', naomi.KEYS.DPRTYPEc}};
        end
        function plotContour(obj, axes)
            if nargin<2; axes= gca();end;
            
            % get the orientation from header 
            orientation = obj.getKey(naomi.KEYS.ORIENT, naomi.KEYS.ORIENTd);
    		
	    	[x,y,mask] = naomi.compute.actuatorPosition(orientation);
            [nAct, ~] = size(mask);
            [X,Y] = naomi.compute.orientedMeshgrid(0:nAct-1, orientation);
            X = X-nAct/2;
            Y = Y-nAct/2;
            
            cmdVector = obj.data(':');
            
	    	values = mask*1.0;
    		values(mask) =  mask(mask).*cmdVector;
    		values(~mask) = nan;
            hold(axes, 'on');
            scatter(axes, x,y,20, cmdVector);
            contour(axes, X,Y,values, [-0.1,-0.05, 0.0, 0.05, 0.1, 0.2],'-.k','ShowText','on');
            colorbar;
            hold(axes, 'off');
            xlim([-nAct/2, +nAct/2]);
            ylim([-nAct/2,  nAct/2]);
            text(axes, x(1),y(1), '1', 'Color', 'red');
            daspect(axes, [1 1 1]); %square aspect ratio
            %naomi.plot.phaseAxesLabel(axes, orientation);
        end
        function gui(obj)
            dmBiasExplorerGui(obj);
        end
 	end
end