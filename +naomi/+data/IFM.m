classdef IFM < naomi.data.PhaseCube
	properties
        profileResult; % store the result of a fitted profile
        fitType = 'naomi' % the type of fitting
				environmentData;
	end	
	methods
        function obj = IFM(varargin)
            obj = obj@naomi.data.PhaseCube(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'IFM', naomi.KEYS.DPRTYPEc}};
        end
        function setData(obj, data)
            setData@naomi.data.PhaseCube(obj, data);
            obj.profileResult = []; % empty profiles since data has changed 
        end
				
        function data = fitsReadData(obj, file)
            % for historical reason anc compatibility with sparta 
            % the data is stored with the last dimension beeing 
            % the actuator number
            data = fitsread(file);
            data = permute(data, [3,1,2]);
            data = double(data);
						environmentArray = naomi.readExtention( file,'ENVIRONMENT', 1);
            if ~isempty(environmentArray)
                obj.environmentData = naomi.data.Environment(environmentArray);
            end
        end
        function fitsWriteData(obj, fileName)
            fitswrite(single(permute(obj.data, [2,3,1])),fileName);
						if ~isempty(obj.environmentData)
							naomi.saveExtention(obj.environmentData.data, fileName, 'ENVIRONMENT', 1);
						end
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
        function IFMSpartaData = toSparta(obj)
            IFMSpartaData = naomi.data.IFMSpartaData(obj.data, obj.header);
        end
        function IFData = IF(obj, actNumnber)
            data = obj.data;
            data = squeeze(data(actNumnber,:,:));
            
            K = naomi.KEYS;
            h = {{K.ACTNUM, actNumnber,K.ACTNUMc},...
                 {K.IFAMP ,obj.getKey(K.IFAMP, -99.9), K.IFAMPc},...
                 {K.IFNPP, obj.getKey(K.IFNPP, -9), K.IFNPPc}};
            
            IFData = naomi.data.IF(data, h); 
            IFData.fitType = obj.fitType;
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
            
            naomi.plot.phaseAxesLabel(ax, obj.getKey(naomi.KEYS.ORIENT, naomi.KEYS.ORIENTd));
            daspect(ax, [1 1 1])
        end
        
        function gui(obj)
            ifmExplorerGui(obj);
        end
    end
end