classdef IFMatrix < naomi.data.PhaseCube
	properties
		
	end	
	methods
        function obj = IFMatrix(varargin)
            obj = obj@naomi.data.PhaseCube(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IFM', ''}};
        end
        function data = fitsReadData(obj, file)
            % for historical reason anc compatibility with sparta 
            % the data is stored with the last dimension beeing 
            % the actuator number
            data = matlab.io.fits.readImg(file);
            data = permute(data, [3,1,2]);
        end
        function fitsWriteData(obj, fileName)
            fitswrite(permute(obj.data, [2,3,1]),fileName);
            %matlab.io.fits.writeImg(.file, obj.getData());
        end
        function [xS,yS] = computeScale(obj)
            naomi.compute.IFMScale(obj.data);            
        end        
        function IFMatrixSpartaData = toSparta(obj)
            IFMatrixSpartaData = naomi.data.IFMatrixSpartaData(obj.data, obj.header, obj.context);
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
        function [maxVector,hwhmVector] = computeMaximums(obj, signVector)
            IFM = obj.data;
            [nAct,nSubAperture,~] = size(IFM);
            IFMa = abs(IFM);
            if nargin<2
                signVector = ones(nAct,1);
            end
            % Get maximum
            [maxVector,~] = max(reshape(IFMa,nAct,nSubAperture*nSubAperture),[],2);
            maxVector = maxVector .* signVector;

            hwhmVector = zeros(nAct,1);
            for a=1:nAct
                num = naomi.compute.nansum(reshape(IFMa(a,:,:),nSubAperture*nSubAperture,1) > maxVector(a) * 0.5);
                hwhmVector(a) = sqrt(num/3.14159);
            end 
        end
        function plotScreenPhase(obj, actNumber, axes)
            if nargin<3; axes = gca; end
            data =  obj.data;
            [~,nSubAperture,~] = size(data);
            cla(axes); imagesc(axes, squeeze(data(actNumber,:,:)));
            colorbar(axes);
            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);
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

            [xVector, yVector, signVector] = obj.computeActuatorPosition();
            [maxVector, hwhmVector] = obj.computeMaximums(signVector);

            % Accept threshold around median
            flag = (abs(maxVector - median(maxVector))/median(maxVector) < threshold);
            flag = flag .* (abs(hwhmVector - median(hwhmVector))/median(hwhmVector) < threshold);
            nNotOk = nAct - sum(flag);

           
            ax = axesList{1};
            
            plot(ax, maxVector,'o-');
            if emphasizedActuatorNumber; 
                hold(ax, 'on');
                plot(ax,emphasizedActuatorNumber, maxVector(emphasizedActuatorNumber),'rx'); 
                hold(ax, 'off');
            end;
            ylim(ax, [0,1.2*max(maxVector)]);
            grid(ax);  set(ax,'xminorgrid','on','yminorgrid','on');
            xlabel(ax, 'Actuator');
            ylabel(ax, 'amp (um/1)');
            title(ax, 'Influence Functions of all actuators');
            
            
            ax = axesList{2};
            plot(ax, signVector,'o-');
            if emphasizedActuatorNumber; 
                hold(ax, 'on');
                plot(ax, emphasizedActuatorNumber, signVector(emphasizedActuatorNumber),'rx');
                hold(ax, 'off');
            end;            
            ylim(ax, [-1.2,1.2]);
            grid(ax);  set(ax,'xminorgrid','on','yminorgrid','on');
            xlabel(ax, 'Actuator');
            ylabel(ax, 'sign');

            
            ax = axesList{3};
            plot(ax, hwhmVector,'o-');
            if emphasizedActuatorNumber;
                hold(ax, 'on');
                plot(ax,emphasizedActuatorNumber,  hwhmVector(emphasizedActuatorNumber),'rx'); 
                hold(ax, 'off');
            end;
            ylim(ax, [0,1.2*max(hwhmVector)]);
            grid(ax, 'on'); set(ax,'xminorgrid','on','yminorgrid','on');
            xlabel(ax, 'Actuator');
            ylabel(ax, 'fwhm (pix)');

            
            ax = axesList{4};
            scatter(ax, xVector(:),yVector(:));
            if emphasizedActuatorNumber;
                hold(ax, 'on');
                plot(ax, xVector(emphasizedActuatorNumber), yVector(emphasizedActuatorNumber) ,'rx'); 
                hold(ax, 'off');
            end;
            xlim(ax, [0,nSubAperture]);
            ylim(ax, [0,nSubAperture]);
            set(ax,'ydir','reverse');
            grid(ax);  set(ax,'xminorgrid','on','yminorgrid','on');
            xlabel(ax, 'Y   => +');
            ylabel(ax, '+ <=   X');
        end            
    end
end