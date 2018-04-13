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
        
        function plotOneMode(obj, z)
        	clf; 
        	imagesc(squeeze(obj.data(z,:,:))); 
        	colorbar;
		    title(sprintf('Mode %i',z));
		    xlabel('Y  =>'); ylabel('<=  X');
        end
        
    	function plotModes(obj, maxZernike)
    		if nargin<2; maxZernike=21;end;
    		ZtPArray = obj.data;
    		[~, nSubAperture, ~] = size(ZtPArray);
    		ZtPRefArray = naomi.compute.theoriticalZtP(
    						 nSubAperture, obj.getKey('XCENTER', 0),  obj.getKey('YCENTER', 0),
    						       ATOTOTOTOTOT FIFNFIFNINQIASNIFNAISFIASNFIN
    						       ) 

    			);

    		[nZernike,nSubAperture,~] = size(ZtPArray);
			nZernike = min(nZernike,maxZernike);			
			
			clf;
			[residualVector, gainVector] = naomi.compute.ztpDifference(ZtPArray, ZtPRefArray, maxZernike);
			
    		for iZernike=1:nZernike
			    subplot(7,6,iZernike*2-1);
			    imagesc(squeeze(ZtPArray(iZernike,:,:)));
			    set(gca,'XTickLabel','','YTickLabel','');
			    title(sprintf('Mode %i',iZernike));
			    subplot(7,6,iZernike*2);
			    imagesc(squeeze(ZtPArray(iZernike,:,:) - ZtPRefArray(iZernike,:,:)));
			    set(gca,'XTickLabel','','YTickLabel','');
			    title(sprintf('%.3fum',residualVector(iZernike)));
			end	
     	end
 	end
end