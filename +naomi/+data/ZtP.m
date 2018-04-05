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
        
        function plotOneMode(obj, z)
        	clf; 
        	imagesc(squeeze(obj.data(z,:,:))); 
        	colorbar;
		    title(sprintf('Mode %i',z));
		    xlabel('Y  =>'); ylabel('<=  X');
        end
        
    	function plotModes(obj, ZtPRefArray, NzerMax)
    		if nargin<3; NzerMax=21;end;
    		ZtPArray = obj.data;

    		[Nzer,Nsub,~] = size(ZtPArray);
			Nzer = min(Nzer,NzerMax);			
			

			clf;
			[Gain, Res] = naomi.compute.compareZtP(ZtPArray, ZtPRefArray);

    		for z=1:Nzer
			    subplot(7,6,z*2-1);
			    imagesc(squeeze(ZtPArray(z,:,:)));
			    set(gca,'XTickLabel','','YTickLabel','');
			    title(sprintf('Mode %i',z));
			    subplot(7,6,z*2);
			    imagesc(squeeze(ZtPArray(z,:,:) - ZtPRefArray(z,:,:)));
			    set(gca,'XTickLabel','','YTickLabel','');
			    title(sprintf('%.3fum',Res(z)));
			end	
     	end
 	end
end