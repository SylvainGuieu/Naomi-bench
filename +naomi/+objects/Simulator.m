classdef Simulator < naomi.objects.BaseObject
    %SIMULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sSerialName = 'simulator';
        IFM; % IFM matrix
        
        simuBiasVector;  % the simulated bias vector 
        biasVector; % the configured bias vector 
        turbuArray; % tubulances array must be ntubu x nSub x nSub array 
        turbuIndex =1;
        simuTurbuStrength = 1;
        simuOrientation = '-xy';
        
        zernike2Command; % the zernike to command configured 
        ZtPtheoricArray;
        PtZtheoricArray;
        cmdVector;% the command vector  name as aco 
        staticZernike = [0 0 0]; % at least 3
        phase2Command;
        
        ztcNzernike = 100;
        ztcNeigenValue = 140;
        
        ifmCleanPercentil = 50;
        ifmNexclude = 24;
        
        dmVector; 
        
        % leave empty will set in the middle
        xCenter;
        yCenter;
        pixelScale = 3.8000e-04;
        
        
        fullPupillDiameter = 36.5e-3;
        dmCenterAct = 121;
        orientation = 'yx';
        
        rXMotorPosition = 0.0;
        rYMotorPosition = 0.0;
        rXgain = 3300;
        rYgain = 5000;
        rXzero = 14.5;
        rYzero = 15.7;
        
        rXOrder = 3;  %tilt
        rYOrder = 2; % not used just for consistancy
        % Sign of rX movement regarding to zernic order 
        rXSign = 1;
        rYSign = 1;
        
        pause = 0.2;
        
        simuDmActuatorSeparation = 0.0025;
        
        model = 'simu';
        
    end
    
    methods
        function obj = Simulator(IFM, biasVector, turbuArray)
            %SIMULATOR Construct an instance of this class
            %   Detailed explanation goes here
            
            
            
            obj.setIFM(IFM);
            
            if nargin>=2 && ~isempty(biasVector)                
                obj.simuBiasVector = biasVector;
            else
                obj.simuBiasVector = zeros(obj.nActuator,1);               
            end
            if nargin>=3 && ~isempty(turbuArray)
                obj.turbuArray = turbuArray;
                
                
            end
            obj.biasVector = 0.0;
            
            [obj.ZtPtheoricArray, obj.PtZtheoricArray] = naomi.compute.theoriticalZtP(...
                        obj.nSubAperture,...
                        obj.xCenter,obj.yCenter, ... 
                        obj.fullPupillDiameter/obj.pixelScale, ...
                        0.0, ...
                        obj.ztcNzernike, ...
                        obj.simuOrientation, 0.0);
                    
            obj.cmdVector = zeros(obj.nActuator, 1);            
        end
        function Reset(obj)
            obj.cmdVector = zeros(obj.nActuator, 1);
        end
        function img = getRawImage(obj)
            img = ones(10,10)*0.8+rand(1)*0.1;
            %img = zeros(10,10);
        end
        function haso = haso(obj)
            haso = obj;
        end
        function StopAlignmentRtd(obj)
        end
        function StartAlignmentRtd(obj)
        end
        function rawPhase = getRawPhase(obj)
            pause(obj.pause);
            
            cmdVector = obj.cmdVector - obj.simuBiasVector + obj.biasVector;
            %cmdVector = obj.cmdVector  + obj.biasVector;
            nActuator = obj.nActuator;
            nSubAperture = obj.nSubAperture;
            IFMArray = reshape( obj.IFM, nActuator, nSubAperture*nSubAperture);
%             if ~isempty(obj.turbuArray)
%                 IFMArray = IFMArray + reshape(obj.turbuArray,nActuator,  nSubAperture*nSubAperture);
%             end
            
            if isempty(obj.xCenter)
                xCenter = nSubAperture/2.;
                yCenter = nSubAperture/2.;
            else
                xCenter  = obj.xCenter;
                yCenter  = obj.yCenter;
            end
            
            staticZernike = obj.staticZernike;
            
            staticZernike(obj.rXOrder) = staticZernike(obj.rXOrder) +...
                    (obj.rXMotorPosition - obj.rXzero)*obj.rXgain * ...
                    obj.fullPupillDiameter*4.8e-6 /...
                    (obj.rXSign*1e-6 * 4/2);
            staticZernike(obj.rYOrder) = staticZernike(obj.rYOrder) + ...
                    (obj.rYMotorPosition - obj.rYzero)*obj.rYgain * ...
                    obj.fullPupillDiameter*4.8e-6 /...
                    (obj.rYSign*1e-6 * 4/2);
               
                % add static aberation
                nStatic = length(obj.staticZernike);
                ZtP = naomi.compute.theoriticalZtP(nSubAperture, xCenter , yCenter, obj.fullPupillDiameter/obj.pixelScale, 0.0, nStatic , obj.simuOrientation, 0.0);
                ZtP = (reshape(ZtP, nStatic, nSubAperture*nSubAperture)'.*staticZernike)';
                rawPhase = sum(ZtP,1)';
                
             
             %rawPhase = rawPhase + IFMArray'*-obj.simuBiasVector;
                
                
                
            
            
            
            
            rawPhase = IFMArray'*cmdVector + rawPhase;
            rawPhase = reshape(rawPhase, nSubAperture, nSubAperture);
            if ~isempty(obj.turbuArray) && obj.simuTurbuStrength
                [turbuLength, ~, ~] = size(obj.turbuArray);
                if obj.turbuIndex>turbuLength; obj.turbuIndex = 1; end;
                rawPhase = rawPhase + squeeze(obj.turbuArray(obj.turbuIndex,:,:))*obj.simuTurbuStrength;
                obj.turbuIndex = obj.turbuIndex+1;
            end
            
        end
        
        function zernikeVector = zernikeVector(obj, varargin)
            % need to compute the PtC matrix (need the ace)
            nActuator = obj.nActuator;
            nSubAperture = obj.nSubAperture;
            
            IFMArray = reshape( obj.IFM, nActuator, nSubAperture*nSubAperture);
            phaseArray = IFMArray'*obj.cmdVector;
            
            zernikeVector = naomi.compute.nanzero(phaseArray(:)') * reshape(obj.PtZtheoricArray,[],obj.ztcNzernike);
            if ~isempty(varargin);zernikeVector = zernikeVector(varargin{:});end
        end
        
        function setZernike(obj, zernikeIndex, zernikeVector)
            
            if isempty(obj.zernike2Command)
                error('No zernike2Command configured');
            end
            if nargin<3
                zernikeVector = zernikeIndex;
                zernikeIndex = 1:length(zernikeVector);
            end
            [~, nZer] = size( zernikeVector);
                
            
            
            if nZer>obj.ztcNzernike
                error('zernike vector is too large');
            end
            allZernikeVector = zeros(obj.ztcNzernike, 1);
            allZernikeVector(zernikeIndex) = zernikeVector;
            
            obj.cmdVector(:) = allZernikeVector'*obj.zernike2Command;
            
        end
        
        function nActuator = nActuator(obj)
            [nActuator, ~, ~] = size(obj.IFM);
        end
        function nSubAperture = nSubAperture(obj)
            [ ~,nSubAperture, ~] = size(obj.IFM);
        end
        function setIFM(obj, IFM)
           obj.IFM = IFM;
           
           IFC = squeeze(IFM(obj.dmCenterAct,:,:));
           [xCenter,yCenter] = naomi.compute.IFCenter(IFC);
           obj.xCenter = xCenter;
           obj.yCenter = yCenter;

           [xpixelScale, yPixelScale] = naomi.compute.IFMScale(IFM, obj.simuDmActuatorSeparation, obj.simuOrientation);
           obj.pixelScale = 0.5* (xpixelScale + yPixelScale);
%            if isempty(obj.pixelScale)
%                [xS,yS] = naomi.compute.IFMScale(IFM);
%                obj.pixelScale = 0.5 * (xS + yS);
%            end
            
        end
        
        %%% Motor
        function moveDirecTo(obj, axis, position)
            switch axis
                case 'rX'
                    obj.rXMotorPosition = position;
                case 'rY'
                    obj.rYMotorPosition = position;
            end
        end
        
        function moveToZero(obj, axis)
            
            if nargin<2
                obj.rXMotorPosition = obj.rXzero;
                obj.rYMotorPosition = obj.rYzero;         
            else
                switch axis
                    case 'rX'
                        obj.rXMotorPosition = obj.rXzero;
                    case 'rY'
                        obj.rYMotorPosition = obj.rYzero; 
                    otherwise
                        error('axis should be rX or rY');
                end
            end
        end
        
        function moveTo(obj, axis, position)
            switch axis
                case 'rX'
                    obj.rXMotorPosition = position;
                case 'rY'
                    obj.rYMotorPosition = position;
            end
        end
        function moveBy(obj, axis, relPos)
            switch axis
                case 'rX'
                    obj.rXMotorPosition = obj.rXMotorPosition + relPos;
                case 'rY'
                    obj.rYMotorPosition = obj.rYMotorPosition + relPos;
            end
        end
        function moveByArcsec(obj, axis, arcsec)
            switch axis
                case 'rX'
                    obj.rXMotorPosition = obj.rXMotorPosition + arcsec/obj.rXgain;
                case 'rY'
                    obj.rYMotorPosition = obj.rYMotorPosition + arcsec/obj.rYgain;
            end
        end
        function pos = getPos(obj, axis)
            switch axis
                case 'rX'
                    pos = obj.rXMotorPosition;
                case 'rY'
                    pos = obj.rYMotorPosition;
            end
        end
        
        function init(obj, axis)
            if nargin>1
                switch axis
                    case 'rX'
                        obj.rXMotorPosition = obj.rXzero;
                        pause(2);
                    case 'rY'
                        obj.rYMotorPosition = obj.rYzero;
                        pause(2);
                end
            else
                obj.rXMotorPosition = obj.rXzero;
                 pause(2);
                obj.rYMotorPosition = obj.rYzero;
                 pause(2);
            end
        end
        function populateHeader(obj,h)
          K = naomi.KEYS;
          naomi.addToHeader(h, K.WFSNSUB, obj.nSubAperture, K.WFSNSUBc);
          naomi.addToHeader(h, K.WFSNAME, obj.model, K.WFSNAMEc);
        end
    end
end

