classdef Simulator < naomi.objects.BaseObject
    %SIMULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sSerialName = 'simulator';
        IFM; % IFM matrix
        
        biasVector % the bias vector name as aco 
        turbuArray; % tubulances array must be ntubu x nSub x nSub array 
        turbuIndex =1;
        
        zernike2Command; % the matrix name as aco 
        ZtPtheoricArray;
        PtZtheoricArray
        cmdVector;% the command vector  name as aco 
        staticZernike;
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
        
        rXOrder = 2;  %tip
        rYOrder = 3; % not used just for consistancy
        % Sign of rX movement regarding to zernic order 
        rXSign = -1;
        rYSign = -1;
        
    end
    
    methods
        function obj = Simulator(IFM, biasVector, turbuArray, zernike2Command)
            %SIMULATOR Construct an instance of this class
            %   Detailed explanation goes here
            
            if nargin>=4
                obj.zernike2Command = zernike2Command; % if not set it will be computed by setIFM
            end
            
            obj.setIFM(IFM);
            
            if nargin>=2 && ~isempty(biasVector)                
                obj.biasVector = biasVector;
            else
                obj.biasVector = zeros(obj.nActuator,1);               
            end
            if nargin>=3 && ~isempty(turbuArray)
                obj.turbuArray = turbuArray;
                
                
            end
            
            
            [obj.ZtPtheoricArray, obj.PtZtheoricArray] = naomi.compute.theoriticalZtP(...
                        obj.nSubAperture,...
                        obj.xCenter,obj.yCenter, ... 
                        obj.fullPupillDiameter/obj.pixelScale, ...
                        obj.ztcNzernike, ...
                        obj.orientation);
                    
            obj.cmdVector = zeros(obj.nActuator, 1);            
        end
        function Reset(obj);
            obj.cmdVector = zeros(obj.nActuator, 1);
        end
        function rawPhase = getRawPhase(obj)
            
            
            cmdVector = obj.cmdVector - obj.biasVector;
            nActuator = obj.nActuator;
            nSubAperture = obj.nSubAperture;
            IFMArray = reshape( obj.IFM, nActuator, nSubAperture*nSubAperture);
%             if ~isempty(obj.turbuArray)
%                 IFMArray = IFMArray + reshape(obj.turbuArray,nActuator,  nSubAperture*nSubAperture);
%             end
            
            if ~isempty(obj.staticZernike)
                zernikeVector = obj.staticZernike;
                nZer = length( zernikeVector);
                
            
            
                if nZer>obj.ztcNzernike
                    error('zernike vector is too large');
                end
                allZernikeVector = zeros(obj.ztcNzernike, 1);
                allZernikeVector(1:nZer) = zernikeVector;
                
                 
                allZernikeVector(obj.rXOrder) = allZernikeVector(obj.rXOrder) +...
                    (obj.rXMotorPosition - obj.rXzero)*obj.rXgain * ...
                    obj.fullPupillDiameter*4.8e-6 /...
                    (obj.rXSign*1e-6 * 4/2);
                allZernikeVector(obj.rYOrder) = allZernikeVector(obj.rYOrder) + ...
                    (obj.rYMotorPosition - obj.rYzero)*obj.rYgain * ...
                    obj.fullPupillDiameter*4.8e-6 /...
                    (obj.rYSign*1e-6 * 4/2);
                
                
                cmdVector = cmdVector + (allZernikeVector'*obj.zernike2Command)';
                
            else
                allZernikeVector = zeros(obj.ztcNzernike, 1);
                allZernikeVector(obj.rXOrder) = allZernikeVector(obj.rXOrder) +...
                    (obj.rXMotorPosition - obj.rXzero)*obj.rXgain * ...
                    obj.fullPupillDiameter*4.8e-6 /...
                    (obj.rXSign*1e-6 * 4/2);
                allZernikeVector(obj.rYOrder) = allZernikeVector(obj.rYOrder) + ...
                    (obj.rYMotorPosition - obj.rYzero)*obj.rYgain * ...
                    obj.fullPupillDiameter*4.8e-6 /...
                    (obj.rYSign*1e-6 * 4/2);
                
                cmdVector = cmdVector + (allZernikeVector'*obj.zernike2Command)';
            end
            
            
            
            
            rawPhase = IFMArray'*cmdVector;
            rawPhase = reshape(rawPhase, nSubAperture, nSubAperture);
            if ~isempty(obj.turbuArray)
                [turbuLength, ~, ~] = size(obj.turbuArray);
                if obj.turbuIndex>turbuLength; obj.turbuIndex = 1; end;
                rawPhase = rawPhase + squeeze(obj.turbuArray(obj.turbuIndex,:,:));
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
           if isempty(obj.xCenter)
               IFC = squeeze(IFM(obj.dmCenterAct,:,:));
               [xCenter,yCenter] = naomi.compute.IFCenter(IFC);
               obj.xCenter = xCenter;
               obj.yCenter = yCenter;
           end
%            if isempty(obj.pixelScale)
%                [xS,yS] = naomi.compute.IFMScale(IFM);
%                obj.pixelScale = 0.5 * (xS + yS);
%            end
            
           
           if isempty(obj.zernike2Command)
                
               cleanIFMArray = naomi.compute.cleanIFM(IFM, obj.ifmNexclude, obj.ifmCleanPercentil); 
               [~,ZtC,~] = commandMatrix(IFM, obj.xCenter, obj.yCenter, obj.fullPupillDiameter/obj.pixelScale, 0.0, obj.ztcNeigenValue, obj.ztcNzernike, 1);
               if isempty(obj.zernike2Command)
                obj.zernike2Command = ZtC;         
               end
               
           else
               [obj.ztcNzernike, ~] = size(obj.zernike2Command);
           end
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
            switch axis
                case 'rX'
                    obj.rXMotorPosition = rXzero;
                case 'rY'
                    obj.rYMotorPosition = rYzero;
            end
        end    
    end
end

