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
           
            zernike = obj.getKey(naomi.KEYS.ZERN,-1); 	
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
                                                zernike, ...
                                                obj.orientation);
            theoreticalPhaseArray = theoreticalPhaseArray(varargin{:});                               
        end
        function theoreticalPhaseData  = theoreticalPhaseData(obj)
               theoreticalPhaseArray = obj.theoreticalPhaseArray;
               K = naomi.KEYS;
               h = {{K.ORIGIN, 'Model', K.ORIGINc},...
                    {K.ZERN, obj.getKey(K.ZERN, 1),K.ZERNc}, ...
                    {K.XCENTER, obj.getKey(K.XCENTER, K.XCENTERd),K.XCENTERc}, ...
                    {K.YCENTER, obj.getKey(K.YCENTER, K.YCENTERd),K.YCENTERc}, ... 
                    {K.XPSCALE, obj.getKey(K.XPSCALE, K.XPSCALEd),K.XPSCALEc}, ...
                    {K.YPSCALE, obj.getKey(K.YPSCALE, K.YPSCALEd),K.YPSCALEc}, ... 
                    {K.ZTCDIAM, obj.getKey(K.ZTCDIAM, K.ZTCDIAMd),K.ZTCDIAMc}, ...
                    {K.FPUPDIAM,obj.getKey(K.ZTCDIAM, K.ZTCDIAMd),K.FPUPDIAMc},... % full pupill becomes ZTC pupill
                    {K.ORIENT, obj.getKey(K.ORIENT, K.ORIENTd),K.ORIENTc}};
              theoreticalPhaseData = naomi.data.PhaseZernike( theoreticalPhaseArray, h);
        end
        
        function residualArray = residualArray(obj, varargin)
            tPhase = obj.theoreticalPhaseArray;
            phase  = obj.normalizedPhaseArray;
            residualArray = phase - tPhase;
            residualArray = residualArray(varargin{:});
        end
        
        
            
        function residualData = residualData(obj)
             residualData  = ...
                 naomi.data.PhaseResidual(obj.residualArray, ...
                                          obj.header);   
        end
        
        function zernikeData = zernikeData(obj)
            zernikeData = naomi.data.Zernike(obj.getKey(naomi.KEYS.ZERN,1));
        end   
    end
    
end