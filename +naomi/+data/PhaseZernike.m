classdef PhaseZernike < naomi.data.Phase
    % a phase screen which is a measure of a pure zernike mode
	properties
      
	end	
	methods
        function obj = PhaseZernike(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'PHASEMODE', ''}};
        end
        
        function zernike = zernike(obj)
             zernike = obj.getKey(naomi.KEYS.ZERN,-1); 
        end
        function plot(obj, axes)
            if nargin<2; axes= gca;end
            plot@naomi.data.Phase(obj,axes);
%             phaseArray = obj.phaseArray;
%             nSubAperture = obj.nSubAperture;
%             cla(axes); imagesc(axes, phaseArray);
%             xlim(axes, [1,nSubAperture]);
%             ylim(axes, [1,nSubAperture]);
           
            zernike = obj.getKey(naomi.KEYS.ZERN,-99); 	
            ttl = sprintf('Zernike %d, rms=%.3fum ptv=%.3fum', zernike, obj.std, obj.ptv);
            
            title(axes,ttl);
        end
        function plotAll(obj, axesList)
            % plot the phase, the residual (compare) to zernike theoritical phase
            % info about the zernike and the shape of the thernike 
            % axesList mus contain 4 axes
            if nargin<2
                clf;
                axPhase = subplot(2,2,1, 'replace');
                axRes   = subplot(2,2,2);
                axInfo  = subplot(2,2,3);
                axZern = subplot('Position', [0.5 0.2 0.15 0.15]);
                axesList = {axPhase, axRes, axInfo, axZern};
            end
            ax = axesList{1};
            obj.plot(ax);
            hold(ax,'on'); 
            obj.plotPupill(ax); 
            hold(ax,'off');
            
            ax = axesList{2};
            obj.residualData.plot(ax);
            
            zernikeData = obj.zernikeData();
            
            ax = axesList{3};
            zernikeData.plotInfo(ax);
            
            ax = axesList{4};
            zernikeData.plotPhase(ax);
            
        end
        function theoreticalPhaseArray  = theoreticalPhaseArray(obj, varargin)
            % return a theoritical phase array associated to this zernike 
            zernike = obj.zernike;
            if zernike<1
                error('Unknown mode');
            end
            nSubAperture = obj.nSubAperture;
            
             theoreticalPhaseArray = ...
                 naomi.compute.theoriticalPhase(nSubAperture,...
                                                obj.xCenter, obj.yCenter,...
                                                obj.pupillDiameterPix, ...
											    0.0,...
                                                zernike, ...
                                                obj.orientation);
            if ~isempty(varargin);theoreticalPhaseArray = theoreticalPhaseArray(varargin{:}); end                              
        end
        function theoreticalPhaseData  = theoreticalPhaseData(obj)
               theoreticalPhaseArray = obj.theoreticalPhaseArray;
			   theoreticalPhaseData = naomi.data.PhaseZernike( theoreticalPhaseArray);
							 
							 K = naomi.KEYS;
							 keys = {K.ZERN, 
							         K.XCENTER, K.YCENTER, ...
							  			 K.XPSCALE, K.YPSCALE, K.ZTCDIAM, K.FPUPDIAM, K.ORIENT};
							 naomi.copyHeaderKeys(obj, theoreticalPhaseData, keys)
        end
        
        function residualArray = residualArray(obj, varargin)
            tPhase = obj.theoreticalPhaseArray;
           
            %phase  = obj.normalizedPhaseArray;
            phase = obj.phaseArray;
            residualArray = phase - tPhase;
            if ~isempty(varargin);residualArray = residualArray(varargin{:});end
        end
        
        
            
        function residualData = residualData(obj)
             residualData  = ...
                 naomi.data.PhaseResidual(obj.residualArray, ...
                                          obj.header);   
        end
        
        function zernikeData = zernikeData(obj)
            zernikeData = naomi.data.Zernike(obj.getKey(naomi.KEYS.ZERN,1), ...
                        {{naomi.KEYS.ORIENT, obj.getKey(naomi.KEYS.ORIENT, naomi.KEYS.ORIENTd), naomi.KEYS.ORIENTc}});
        end   
    end
    
end