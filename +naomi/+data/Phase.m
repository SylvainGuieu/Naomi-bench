classdef Phase < naomi.data.BaseData
	properties
	

	end	
	methods
        function obj = Phase(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'PHASE', ''}};
        end
        
        function nSubAperture = nSubAperture(obj)
            [nSubAperture, ~] = size(obj.data);
        end
        
        
        function xScale = xScale(obj)
            % the x pixelScale as measured by the bench 
            xScale = obj.getKey(naomi.KEYS.XPSCALE,naomi.KEYS.XPSCALEd);
        end
        function yScale = yScale(obj)
            % the y pixelScale as measured by the bench 
            yScale = obj.getKey(naomi.KEYS.YPSCALE,naomi.KEYS.YPSCALEd);
        end
        
        function diameterPix = pupillDiameterPix(obj)
            % return the diameter of the active pupill, the one used to
            % compute the Zernike to Command matrix
            % the returned diameter is in pixel
            
            K = naomi.KEYS;
            diam = obj.pupillDiameter;
            xp   = obj.xScale;
            yp   = obj.yScale;
            diameterPix = diam/((xp+yp)/2.0);
        end
        
        function diameterPix = fullPupillDiameterPix(obj)
            % return the diameter of the active pupill, the one used to
            % compute the Zernike to Command matrix
            % the returned diameter is in pixel
            
            K = naomi.KEYS;
            diam = obj.fullPupillDiameter;
            xp   = obj.xScale;
            yp   = obj.yScale;
            diameterPix = diam/((xp+yp)/2.0);
        end
        
        function diam = pupillDiameter(obj)
            % return the diameter of the active pupill, the one used to
            % compute the Zernike to Command matrix
            % the returned diameter is in meter 
            diam = obj.getKey(naomi.KEYS.ZTCDIAM,naomi.KEYS.ZTCDIAMd).*...
                   obj.getKey(naomi.KEYS.DIAMRESC,1.0);
        
        end
        
				
        function diam = fullPupillDiameter(obj)
            % return the diameter of the full pupill
            % the returned diameter is in meter 
            diam = obj.getKey(naomi.KEYS.FPUPDIAM,naomi.KEYS.FPUPDIAMd);
        end
        
        
        function xCenter = xCenter(obj)
            % xCenter = phaseData.xCenter
            % the pixel position of the center (center actuator) as measured by
            % the bench.
            xCenter = obj.getKey(naomi.KEYS.XCENTER, naomi.KEYS.XCENTERd)+...
                      obj.getKey(naomi.KEYS.XOFFSET, 0.0);
        
        end
              
        function yCenter = yCenter(obj)
            % xCenter = phaseData.xCenter
            % the pixel position of the center (center actuator) as measurd by
            % the bench. 
            yCenter = obj.getKey(naomi.KEYS.YCENTER, naomi.KEYS.YCENTERd)+...
                      obj.getKey(naomi.KEYS.YOFFSET, 0.0);
        end
        function orientation = orientation(obj)
            % return the orientation has defined by the zernike to command
            % orientation. It is used to build and compare a phase model 
            % see help on naomi.compute.orientedMeshgrid
            orientation = obj.getKey(naomi.KEYS.ZTCORIENT, naomi.KEYS.ZTCORIENTd);
        end
         function [pupillDiameterPix, centralObscurtionPix, xCenter, yCenter] = pupillMaskParameters(obj)
            if obj.getKey(naomi.KEYS.MASKED, 0)
                if strcmp(obj.getKey(naomi.KEYS.MASKNAME,naomi.KEYS.CUSTOM), naomi.KEYS.CUSTOM)
                    error('phase was taken with a custom mask cannot determine mask parameters');
                end
                
                pupillDiameterPix = obj.getKey(naomi.KEYS.MPUPDIAMPIX);
                centralObscurtionPix = obj.getKey(naomi.KEYS.MCOBSDIAMPIX);
                xCenter = obj.getKey(naomi.KEYS.MXCENTER);
                yCenter = obj.getKey(naomi.KEYS.MYCENTER);
            else % make a mask bigger than image
                 pupillDiameterPix = obj.nSubAperture*2;
                 centralObscurtionPix = 0.0;
                 xCenter = obj.nSubAperture/2;
                 yCenter = obj.nSubAperture/2;
            end
         end
        
        function pupillMaskArray = pupillMaskArray(obj, varargin)
            % the mask array defining the active pupill 
            % 
            %  ones are inside the pupill 0 are outside
            [pupillDiameterPix, centralObscurtionPix, xCenter, yCenter] = obj.pupillMaskParameters;
            pupillMaskArray = naomi.compute.pupillMask(obj.nSubAperture, ...
                                            pupillDiameterPix, centralObscurtionPix, ...
                                            xCenter, yCenter);
            if ~isempty(varargin); pupillMaskArray = pupillMaskArray(varargin{:}); end                        
        end
        
        
        function maskedPhaseArray = maskedPhaseArray(obj, varargin)
            % the phase all subaperture outside of the active pupill are
            % replaced by nan
            phase = obj.data;         
            maskedPhaseArray = phase;            
            maskedPhaseArray(~obj.pupillMaskArray) = nan;
            if ~isempty(varargin); maskedPhaseArray = maskedPhaseArray(varargin{:});end
        end
        
        function maskedPhaseData = maskedPhaseData(obj)
            K = naomi.KEYS;
            h = {...
                {K.ORIGIN, obj.getKey(K.ORIGIN, ''), K.ORIGIN},...
                {K.XCENTER, obj.xCenter,K.XCENTERc}, ...
                {K.YCENTER, obj.yCenter,K.YCENTERc}, ... 
                {K.XPSCALE, obj.xScale ,K.XPSCALEc}, ...
                {K.YPSCALE, obj.yScale ,K.YPSCALEc}, ... 
                {K.ZTCDIAM, obj.pupillDiameter, K.ZTCDIAMc}, ... % full pupill becomes ZTC pupill
                {K.FPUPDIAM,obj.pupillDiameter, K.FPUPDIAMc},... 
                {K.ORIENT, obj.getKey(K.ORIENT, K.ORIENTd),K.ORIENTc}};
            
            maskedPhaseData = naomi.data.Phase(obj.maskedPhaseArray, h);
        end

        function phaseArray = phaseArray(obj, varargin)
            % return the phase Array of this measurement
            phaseArray = obj.data;
            if ~isempty(varargin);phaseArray = phaseArray(varargin{:});end
        end
        
        function normalizedPhaseArray = normalizedPhaseArray(obj, varargin)
            % return the  phase where the piston has been removed
            % and the gain (the std over the active pupill) is one
            normalizedPhaseArray = (obj.phaseArray - obj.piston)./obj.gain;
            if ~isempty(varargin);normalizedPhaseArray = normalizedPhaseArray(varargin{:});end
        end
        
        function piston = piston(obj)
            % compute the piston over the active pupill
            % piston in mum rms 
            piston = naomi.compute.nanmean(obj.maskedPhaseArray(':'));
        end
        
        function gain = gain(obj)
            % compute the gain (std) over the active pupill 
            % gain is in mum rms unless the gain is set inside the header
            % in this case return it 
            gain = obj.getKey(naomi.KEYS.GAIN, []);
            if isempty(gain)
                gain = naomi.compute.nanstd(obj.maskedPhaseArray(':'));
            end
        end
            
        
        function stdValue = std(obj)
            % compute the standard deviation over the entire pupill
            stdValue = naomi.compute.nanstd(obj.data(':'));
        end
        
        function ptvValue = ptv(obj)
            % compute the pic to valey over the entire pupill
            phase = obj.data;
            ptvValue = max(phase(:)) - min(phase(:));
        end
        
        function zernikeVector = zernikeVector(obj, nZernike)
            if nargin<2; nZernike=21; end
            
            [~,PtZ] = naomi.compute.theoriticalZtP(...
                        obj.nSubAperture,...
                        obj.xCenter,...
                        obj.yCenter,...
                        obj.fullPupillDiameterPix,...
					    0.0,... 
                        nZernike, ...
                        obj.orientation);
            
            zernikeVector = naomi.compute.nanzero(obj.phaseArray(':')') * reshape(PtZ,[],nZernike);
        end
        function zernikesData = zernikesData(obj, nZernike)
            if nargin<2; nZernike=21; end
            zernikesData = naomi.data.Zernikes(obj.zernikeVector(nZernike));
            
        end
        
        function plot(obj, axes)
            if nargin<2; axes= gca;end;
        	phaseArray = obj.phaseArray;
            nSubAperture = obj.nSubAperture;
            cla(axes); imagesc(axes, phaseArray);
            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);
            
            
            	
            title(axes, ...
                  sprintf('rms=%.3fum ptv=%.3fum',obj.std,obj.ptv));
            
            naomi.plot.phaseAxesLabel(axes, obj.orientation);
            colorbar(axes);
            daspect(axes, [1,1,1]); % square figure 
        end
        function plotPupill(obj, axes)
            % plot the circle that define the active pupill
            if nargin<2; axes = gca;end;
            radius = obj.pupillDiameterPix/2;
            
            alpha = linspace(0, 2*pi, 50);
            plot(axes,radius*cos(alpha)+obj.xCenter, ...
                      radius*sin(alpha)+obj.yCenter, 'k-');
        end
        
        function gui(obj)
            naomi.gui.phaseExplorerGui(obj);
        end
    end
end