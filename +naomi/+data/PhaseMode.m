classdef PhaseMode < naomi.data.Phase
    % a phase screen which is a measure of a pure zernike mode
	properties
      
	end	
	methods
        function obj = PhaseMode(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'PHASEMODE', ''}};
        end
       
        function plot(obj, axes)
            if nargin<2; axes= gc;end;
        	phase = obj.data;
            [nSubAperture,~] = size(phase);
            cla(axes); imagesc(axes, phase);
            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);
            
            zernike = obj.getKey('ZERN',-1); 	
            title(axes, {sprintf('Zernike %d, rms=%.3fum ptv=%.3fum',...
                        zernike, ...
                        naomi.compute.nanstd(phase(:)),...
                        max(phase(:)) - min(phase(:)))});
            
            %xlabel(axes, 'Y   =>+');
            %ylabel(axes, '+<=   X');
            colorbar(axes);
            daspect(axes, [1,1,1]);
        end
        function getThetoriticalPhaseMode(obj)
            zernike = obj.getKey('ZERN',-1); 
            if zernike<1
                error('Unknown mode');
            end
            [nSubAperture,~] = size(phase);
            xCenter = obj.getKey('XCENTER', nSubAperture/2);
            yCenter = obj.getKey('YCENTER', nSubAperture/2);
            yCenter = obj.getKey('', nSubAperture/2);
            
            naomi.compute.theoriticalPhase(512, 512/2, 512/2, 512, zernike);
        end
        function plotTheoriticalMode(obj, axes)
            
            naomi.compute.zernikeInfo(app.curentZernike);
            
    end
    
end