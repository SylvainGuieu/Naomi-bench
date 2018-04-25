classdef PhaseCube < naomi.data.BaseData
	properties
	

	end	
	methods
        function obj = PhaseCube(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'PHASE_CUBE', ''}};
        end
        
         function nSubAperture = nSubAperture(obj)
            [~,nSubAperture, ~] = size(obj.data);
         end
         function nPhase = nPhase(obj)
             [nPhase, ~, ~] = size(obj.data);
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
            % return the orientation has defined by the bench
            % orientation is used to build and compare a phase model 
            % see help on naomi.compute.orientedMeshgrid
            orientation = obj.getKey(naomi.KEYS.ORIENT, naomi.KEYS.ORIENTd);
        end
        
        function pupillMaskArray = pupillMaskArray(obj, varargin)
            % the mask array defining the active pupill 
            % 
            %  ones are inside the pupill 0 are outside
            
            pupillMaskArray = naomi.compute.pupillMask(obj.nSubAperture, ...
                                            obj.pupillDiameterPix,0.0,...
                                            obj.xCenter, obj.yCenter);
            pupillMaskArray = pupillMaskArray(varargin{:});                         
        end
        
        function maskedPhaseCube = maskedPhaseCube(obj, varargin)
            phaseCube = obj.data;
            [nZ, nY, nX] = size(obj.data);
            mask = obj.pupillMaskArray(':');
            
            mask = reshape( mask, nX, nY);
            maskedPhaseCube = reshape(phaseCube,nZ,nX*nY);
            maskedPhaseCube(:,~mask) = nan;
            maskedPhaseCube = reshape(maskedPhaseCube,nZ,nX,nY);
            maskedPhaseCube = maskedPhaseCube(varargin{:});
            
        end
        function phaseCube = phaseCube(obj, varargin)
            phaseCube = obj.data(varargin{:});
        end
            
        function gainVector = gainVector(obj, varargin)
            % the gain (std) over the active pupill for all the phases 
            nPhase = obj.nPhase;
            gainVector = naomi.compute.nanstd(reshape(obj.maskedPhaseCube, nPhase, []), 2);
            %gainVector = naomi.compute.nanstd(reshape(obj.phaseCube, nPhase, []), 2);
            gainVector = gainVector(varargin{:});
        end
        function pistonVector = pistonVector(obj, varargin)
            % the piston (std) over the active pupill for all the phases 
            nPhase = obj.nPhase;
            pistonVector = naomi.compute.nanmean(reshape(obj.maskedPhaseCube, nPhase, []), 2);
            pistonVector = pistonVector(varargin{:});
        end
        
        function normalizedPhaseCube = normalizedPhaseCube(obj, varargin)
            % return the  phase where the piston has been removed
            % and the gain (the std over the active pupill) is one
            normalizedPhaseCube = (obj.phaseCube - obj.pistonVector)./obj.gainVector;
            normalizedPhaseCube = normalizedPhaseCube(varargin{:});
        end
        function phaseArray = phaseArray(obj, phaseNumber)
            % a 2D phase screen of the given phase number 
            phaseArray = squeeze(obj.phaseCube(phaseNumber, ':', ':'));
        end
        
        function phaseData = phaseData(obj, phaseNumber)
            % a naomi.data.Phase object of the given phase
            phaseData = naomi.data.Phase(obj.phaseArray(phaseNumber), obj.header);
        end
        
        function plot(obj)
        	% TODO phase cube plot
        end

    end
end