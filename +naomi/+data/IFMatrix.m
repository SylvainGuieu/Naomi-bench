classdef IFMatrix < naomi.data.PhaseCube
	properties
        profileResult; % store the result of a fitted profile
        fitType = 'gauss' % the type of fitting
	end	
	methods
        function obj = IFMatrix(varargin)
            obj = obj@naomi.data.PhaseCube(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IFM', ''}};
        end
        function setData(obj, data)
            setData@naomi.data.PhaseCube(data);
            obj.profileResult = []; % empty profiles since data has changed 
        end
        function data = fitsReadData(obj, file)
            % for historical reason anc compatibility with sparta 
            % the data is stored with the last dimension beeing 
            % the actuator number
            data = matlab.io.fits.readImg(file);
            data = permute(data, [3,1,2]);
            data = double(data);
        end
        function fitsWriteData(obj, fileName)
            fitswrite(single(permute(obj.data, [2,3,1])),fileName);
            %matlab.io.fits.writeImg(.file, obj.getData());
        end
        
        function fit = fitResult(obj)
            if isempty(obj.profileResult) || ~strcmp(obj.profileResult.type, obj.fitType)
                obj.profileResult = naomi.compute.fittedIFMprofile(obj.data, obj.fitType);
            end
            fit = obj.profileResult;
        end
        function [xS,yS] = computeScale(obj)
            naomi.compute.IFMScale(obj.data);            
        end        
        function IFMatrixSpartaData = toSparta(obj)
            IFMatrixSpartaData = naomi.data.IFMatrixSpartaData(obj.data, obj.header, obj.context);
        end
        function IFData = IF(obj, actNumnber)
            data = obj.data;
            data = squeeze(data(actNumnber,:,:));

            IFData = naomi.data.IF(data, {{'ACTNUM', actNumnber, 'Pushed actuator'}}, obj.context); 
            IFData.fitType = obj.fitType;
        end

        

        function [xVector, yVector, signVector] = computeActuatorPosition(obj)
            IFM = obj.data;
            [nAct,nSubAperture,~] = size(IFM);

            xVector = zeros(nAct,1);
            yVector = zeros(nAct,1);
            signVector = zeros(nAct,1);

            for a=1:nAct
                [x,y] = naomi.compute.IFCenter(squeeze(IFM(a,:,:)));
                xVector(a) = x;
                yVector(a) = y;
                signVector(a) = sign(IFM(a,int32(x),int32(y)));
            end            
        end

        function maxVector = computeMaximums(obj, signVector)
            IFM = obj.data;
            [nAct,nSubAperture,~] = size(IFM);
            IFMa = abs(IFM);
            if nargin<2
                signVector = ones(nAct,1);
            end
            % Get maximum
            [maxVector,~] = max(reshape(IFMa,nAct,nSubAperture*nSubAperture),[],2);
            maxVector = maxVector .* signVector;
            
        end

        function hwhmVector = computeHwhm(obj, maxVector, signVector)
            IFM = obj.data;
            [nAct,nSubAperture,~] = size(IFM);
            IFMa = abs(IFM);
            if nargin<2
                maxVector = obj.computeMaximums();
            end
            if nargin<3
                signVector = ones(nAct,1);
            end
            hwhmVector = zeros(nAct,1);
            for a=1:nAct
                num = naomi.compute.nansum(reshape(IFMa(a,:,:),nSubAperture*nSubAperture,1) > maxVector(a) * 0.5);
                hwhmVector(a) = sqrt(num/3.14159);
            end 
        end
        
        
                
        function plotQc(obj, emphasizedActuatorNumber, axesList)
            % emphasizedActuatorNumber if the emphasized actuator 
            % axesList (optional) must have 4 axes 
            if nargin<2
                emphasizedActuatorNumber = 0;
            end
            if nargin<3; 
                gcf();
                axesList = {subplot(6,1,1), subplot(6,1,2), ...
                            subplot(6,1,3), subplot(2,1,2)};
            end
            % plot the QC plot for the ifm
            IFM = obj.data;
            [nAct,nSubAperture,~] = size(IFM);


            
            threshold = 0.2;
            
            fit = obj.fitResult;

            %[xVector, yVector, signVector] = obj.computeActuatorPosition();
            %maxVector = obj.computeMaximums(signVector);
            %hwhmVector = obj.computeHwhm(maxVector, signVector);

            % Accept threshold around median
            flag = (abs(fit.amplitude - median(fit.amplitude))/median(fit.amplitude) < threshold);
            flag = flag .* (abs(fit.hwhm - median(fit.hwhm))/median(fit.hwhm) < threshold);
            nNotOk = nAct - sum(flag);

           
            ax = axesList{1};
            
            plot(ax, abs(fit.amplitude), 'o-');
            if emphasizedActuatorNumber
                hold(ax, 'on');
                plot(ax,emphasizedActuatorNumber, abs(fit.amplitude(emphasizedActuatorNumber)),'rx'); 
                hold(ax, 'off');
            end
            ylim(ax, [0,1.2*max(fit.amplitude)]);
            grid(ax);  set(ax,'xminorgrid','on','yminorgrid','on');
            xlabel(ax, 'Actuator');
            ylabel(ax, 'amp (um/1)');
            title(ax, 'Influence Functions of all actuators');
            
            
            ax = axesList{2};
            plot(ax, sign(fit.amplitude),'o-');
            if emphasizedActuatorNumber
                hold(ax, 'on');
                plot(ax, emphasizedActuatorNumber,sign(fit.amplitude(emphasizedActuatorNumber)) ,'rx');
                hold(ax, 'off');
            end
            ylim(ax, [-1.2,1.2]);
            grid(ax);  set(ax,'xminorgrid','on','yminorgrid','on');
            xlabel(ax, 'Actuator');
            ylabel(ax, 'sign');

            
            ax = axesList{3};
            plot(ax, 2*fit.hwhm,'o-');
            if emphasizedActuatorNumber
                hold(ax, 'on');
                plot(ax,emphasizedActuatorNumber,  2*fit.hwhm(emphasizedActuatorNumber),'rx'); 
                hold(ax, 'off');
            end;
            ylim(ax, [0,1.2*max(2*fit.hwhm)]);
            grid(ax, 'on'); set(ax,'xminorgrid','on','yminorgrid','on');
            xlabel(ax, 'Actuator');
            ylabel(ax, 'fwhm (pix)');

            
            ax = axesList{4};
            scatter(ax, fit.xCenter , fit.yCenter);
            hold(ax, 'on');
                plot(ax, fit.xCenter(1), fit.yCenter(1) ,'gO'); 
            hold(ax, 'off');
            if emphasizedActuatorNumber
                hold(ax, 'on');
                plot(ax, fit.xCenter(emphasizedActuatorNumber), fit.yCenter(emphasizedActuatorNumber) ,'rx'); 
                hold(ax, 'off');
            end
            xlim(ax, [0,nSubAperture]);
            ylim(ax, [0,nSubAperture]);
            set(ax,'ydir','reverse');
            grid(ax);  set(ax,'xminorgrid','on','yminorgrid','on');
            xlabel(ax, 'Y   => +');
            ylabel(ax, '+ <=   X');
            daspect(ax, [1 1 1])
        end
        
        function gui(obj)
            ifmExplorerGui(obj);
        end
    end
end