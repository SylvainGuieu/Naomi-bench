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
%                axInfo  = subplot(2,2,3);
                
%                 axPhaseCut = subplot(4,4,15);
%                 axResCut = subplot(4,4,16);
%                 axZern = subplot('Position', [0.5 0.2 0.15 0.15]);
                
                axInfo  = subplot(4,2,5);
                axPhaseCut = subplot(4,2,6);
                axZern = subplot(4,2,7);
                axResCut = subplot(4,2,8);
                
                

                
                axesList = {axPhase, axRes, axInfo, axZern,axPhaseCut,  axResCut };
            end
            nSubAperture = obj.nSubAperture;
            ax = axesList{1};
            obj.plot(ax);
            hold(ax,'on'); 
            obj.plotPupill(ax); 
            hold(ax,'off');
            
            ax = axesList{2};
            residualData = obj.residualData;
            residualData.plot(ax);
            
            zernikeData = obj.zernikeData();
            
            ax = axesList{3};
            zernikeData.plotInfo(ax);
            
            ax = axesList{4};
            zernikeData.plotPhase(ax);
            if length(axesList)>4
                mask = naomi.getFromData.ztcMask(obj, 'pixel');
                [xc, yc] = naomi.getFromData.dmCenter(obj);
                ax = axesList{5};
                cla(ax);
                plot(ax, squeeze(obj.data(int32(nSubAperture/2), ':')), 'b-');
                hold(ax,'on'); 
                plot(ax, squeeze(obj.data(':', int32(nSubAperture/2))), 'r-');
                hold(ax,'off');
                xlim(ax, [0,nSubAperture+1]);
                y1=get(ax,'ylim');
                ylabel(ax, 'x&y cut');
                hold(ax,'on'); 
                plot(ax, [mask{1}/2, +mask{1}/2.]+xc, y1,  'b:');
                plot(ax, [-mask{1}/2, -mask{1}/2.]+xc, y1, 'b:');
                 plot(ax, [mask{1}/2, +mask{1}/2.]+yc, y1, 'r:');
                plot(ax, [-mask{1}/2, -mask{1}/2.]+yc, y1, 'r:');
                hold(ax, 'off');
                %legend(ax, 'x', 'y');
                
            end
            if length(axesList)>5
                ax = axesList{6};
                cla(ax);
                plot(ax, squeeze(residualData.data(int32(nSubAperture/2), ':')), 'b-');
                hold(ax,'on'); 
                plot(ax, squeeze(residualData.data(':', int32(nSubAperture/2))), 'r-');
                hold(ax,'off');
                xlim(ax, [0,nSubAperture+1]);
                ylabel(ax, 'x&y Res. cut');
                y1=get(ax,'ylim');
                hold(ax,'on'); 
                plot(ax,  [mask{1}/2, +mask{1}/2.]+xc, y1, 'b:');
                plot(ax,  [-mask{1}/2, -mask{1}/2.]+xc, y1, 'b:');
                plot(ax,  [mask{1}/2, +mask{1}/2.]+yc, y1, 'r:');
                plot(ax,  [-mask{1}/2, -mask{1}/2.]+yc, y1, 'r:');
                hold(ax, 'off');
            end
            
            
        end
        function theoreticalPhaseArray  = theoreticalPhaseArray(obj, varargin)
            % return a theoritical phase array associated to this zernike 
            zernike = obj.zernike;
            if zernike<1
                error('Unknown zernike mode');
            end
            
            theoreticalPhaseArray  = naomi.getFromData.theoriticalPhase(obj, zernike);                             
            if ~isempty(varargin);theoreticalPhaseArray = theoreticalPhaseArray(varargin{:}); end                              
        end
        function theoreticalPhaseData  = theoreticalPhaseData(obj)
             
            theoreticalPhaseArray = obj.theoreticalPhaseArray;
			theoreticalPhaseData = naomi.data.PhaseZernike( theoreticalPhaseArray);

             K = naomi.KEYS;
             keys = [{K.ZERN} naomi.alignmentKeyList naomi.ztcKeyList];
                  
             naomi.copyHeaderKeys(obj, theoreticalPhaseData, keys);
        end
        
        function residualArray = residualArray(obj, varargin)
            [~,~,residualArray] = naomi.compute.phaseDifference(obj.phaseArray, obj.theoreticalPhaseArray);
            if ~isempty(varargin);residualArray = residualArray(varargin{:});end
        end
            
        function residualData = residualData(obj)
             residualData  = ...
                 naomi.data.PhaseResidual(obj.residualArray, ...
                                          obj.header);   
        end
        
        function zernikeData = zernikeData(obj)
            zernikeData = naomi.data.Zernike(obj.getKey(naomi.KEYS.ZERN,1));
            K = naomi.KEYS;
            keys = [{K.ZERN}  naomi.alignmentKeyList naomi.ztcKeyList];
    
            naomi.copyHeaderKeys(obj, zernikeData, keys);
        end   
    end
    
end