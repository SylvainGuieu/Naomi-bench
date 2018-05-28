classdef DmBias < naomi.data.DmCommand
	properties
	
	end	

    
	methods
        function obj = DmBias(varargin)
            obj = obj@naomi.data.DmCommand(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'DM_BIAS', naomi.KEYS.DPRTYPEc}};
        end
        function fitsWriteData(obj, fileName)
            fitswrite(obj.data, fileName);
            % save bias as extention if any 
        end
        function data = fitsReadData(obj, fileName)
            data = fitsread(fileName);
        end
        function plotQc(obj, axesList)
            if nargin<2; axesList = {subplot(2,1,1),subplot(2,2,3),subplot(2,2,4)};end
            obj.plot(axesList{1});
            obj.plotContour(axesList{2});
            
            obj.plotImage(axesList{3});
            title(axesList{3}, obj.shortInfo);
        end
        function plotContour(obj, axes)
            if nargin<2; axes= gca();end;
            
            % get the orientation from header 
            orientation = obj.getKey(naomi.KEYS.DMORIENT, naomi.KEYS.DMORIENTd);
    		
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