classdef ZtP < naomi.data.PhaseCube
	properties
	

	end	
	methods
        function obj = ZtP(varargin)
            obj = obj@naomi.data.PhaseCube(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ZTP_MATRIX', ''}};
        end
        function ZtPSpartaData = toSparta(obj)
            ZtPSpartaData = naomi.data.ZtPSpartaData(obj.data, obj.header, obj.context);
        end
        
        function plotOneMode(obj, z, axes)
            if nargin<3; axes = gca; end;
        	cla(axes); 
        	imagesc(axes, squeeze(obj.data(z,:,:))); 
        	colorbar(axes);
		    title(axes, sprintf('Mode %i',z));
		    xlabel(axes, 'Y  =>'); ylabel(axes, '<=  X');
        end
        function axesList = makeAxesList(maxZernike)
            axesList = {};
            n = 7; m =6; % :TOTO adapt n and m in function to maxZernike 
            for iZernike=1:maxZernike
                axesList{length(axesList)+1} = subplot(n,m,iZernike*2-1); % screen phase
                axesList{length(axesList)+1} = subplot(n,m,iZernike*2); % residuals
            end
        end
        
    	function plotModes(obj, maxZernike, axesList)
            if nargin<2; maxZernike=21;end;
            if nargin<3; gcf; axesList = obj.makeAxesList(maxZernike); end;
    		
    		ZtPArray = obj.data;
    		
            [nZernike,nSubAperture,~] = size(ZtPArray);
    		ZtPRefArray = naomi.compute.theoriticalZtP(...
    						 nSubAperture, ...
                             obj.getKey('XCENTER', 0), ...
                             obj.getKey('YCENTER', 0), ...
                             obj.getKey('ZTPDIAMP', 74), ...
                             maxZernike); 
    		
			nZernike = min(nZernike,maxZernike);			
			
			clf;
			[residualVector, ~] = naomi.compute.ztpDifference(ZtPArray, ZtPRefArray, maxZernike);
			
    		for iZernike=1:nZernike
			    ax = axesList{iZernike*2-1};
			    imagesc(ax, squeeze(ZtPArray(iZernike,:,:)));
			    set(ax,'XTickLabel','','YTickLabel','');
			    title(ax, sprintf('Mode %i',iZernike));
			    ax = axesList{iZernike*2};
			    imagesc(ax, squeeze(ZtPArray(iZernike,:,:) - ZtPRefArray(iZernike,:,:)));
			    set(ax,'XTickLabel','','YTickLabel','');
			    title(ax, sprintf('%.3fum',residualVector(iZernike)));
			end	
     	end
 	end
end