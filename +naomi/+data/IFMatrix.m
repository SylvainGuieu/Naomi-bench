classdef IFMatrix < naomi.data.PhaseCube
	properties
		
	end	
	methods
        function obj = IFMatrix(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IFM', ''}};
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
                num = naomi.nansum(reshape(IFMa(a,:,:),nSubAperture*nSubAperture,1) > maxVector(a) * 0.5);
                hwhmVector(a) = sqrt(Num/3.14159);
            end 
        end

        function plotQc(obj, emphasizedActuatorNumber)
            % plot the QC plot for the ifm
            IFM = obj.data;
            [nAct,nSubAperture,~] = size(IFM);


            if nargin<2
                emphasizedActuatorNumber = 0;
            end
            threshold = 0.2;

            [xVector, yVector, signVector] = obj.computeActuatorPosition();
            [maxVector, hwhmVector] = obj.computeMaximums(signVector);

            % Accept threshold around median
            flag = (abs(maxVector - median(maxVector))/median(maxVector) < threshold);
            flag = flag .* (abs(hwhmVector - median(hwhmVector))/median(hwhmVector) < threshold);
            nNotOk = nAct - sum(flag);

            subplot(6,1,1);
            plot(maxVector,'o-');
            if emphasizedActuatorNumber; plot(maxVector(emphasizedActuatorNumber),'rx'); end;
            ylim([0,1.2*max(maxVector)]);
            grid; grid minor;
            xlabel('Actuator');
            ylabel('amp (um/1)');
            title('Influence Functions of all actuators');

            subplot(6,1,2);
            plot(signVector,'o-');
            if emphasizedActuatorNumber; plot(signVector(emphasizedActuatorNumber),'rx'); end;            
            ylim([-1.2,1.2]);
            grid; grid minor;
            xlabel('Actuator');
            ylabel('sign');

            subplot(6,1,3);
            plot(hwhmVector,'o-');
            if emphasizedActuatorNumber; plot(hwhmVector(emphasizedActuatorNumber),'rx'); end;
            ylim([0,1.2*max(hwhmVector)]);
            grid; grid minor;
            xlabel('Actuator');
            ylabel('fwhm (pix)');

            subplot(2,1,2);
            scatter(xVector(:),yVector(:));
            xlim([0,nSubAperture]);
            ylim([0,nSubAperture]);
            set(gca,'ydir','reverse');
            grid; grid minor;
            xlabel('Y   => +');
            ylabel('+ <=   X');
        end            
    end
end