classdef IF < naomi.data.Phase
	properties
	

	end	
	methods
        function obj = IF(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IF', ''}};
        end

    function plotScreenPhase(obj, axes)
        if nargin<2; axes = gca; end

        data =  obj.data;
        [nSubAperture,~] = size(data);
        cla(axes); imagesc(axes, squeeze(data(:,:)));
        colorbar(axes);
        xlim(axes, [1,nSubAperture]);
        ylim(axes, [1,nSubAperture]);
        [x,y, actSign] = obj.position;

        maxValue = obj.maximum(actSign);
        hwhmValue = obj.hwhm(maxValue, actSign);

        title(axes, sprintf('#%d maximum=%.3f hwhm=%.3f x,y =%.1f, %.1f', obj.getkey('ACTNUM', -99), ...
                                                    maxValue, hwhmValue, 
                                                    x, y
                                                ));
    end

    function [x,y, actSign] = position(obj)
        data = obj.data;
        [x,y] = naomi.compute.IFCenter(data);
        actSign = sign(data(int32(x),int32(y)));  
    end

    function maxValue= maximum(obj, actSign)
        data = obj.data;
       
        maxValue = max(data(:));
        if nargin>1; maxValue = maxValue .* actSign; end;
    end
    function hwhmValue = hwhm(obj, maxValue, actSign)
        if nargin<2
            maxValue = obj.maximum;
        end
        if nargin<3
            actSign = 1;
        end
        data = obj.data;
        [nSubAperture, ~] = size(data);
        num = naomi.compute.nansum(reshape(data,nSubAperture*nSubAperture,1) > maxValue * 0.5);
        hwhmValue = sqrt(num/3.14159);
    end
    function [xProfile,yProfile, xCenter, yCenter] = computeProfile(obj, widthPixel)
        if nargin<2
                widthPixel = 51;
        end
        halfWidth = int32(widthPixel/2);
        widthPixel = 2*halfWidth+1;

        data = obj.data;
        [nSubAperture,~] = size(data); 
        
        [xCenter,yCenter] = naomi.compute.IFCenter(data);
        x = min(max(1, int32(xCenter)), nSubAperture);
        y = min(max(1, int32(yCenter)), nSubAperture);
        
        xProfile = squeeze(data(max(1, x-halfWidth):min(nSubAperture, x+halfWidth), y ));
        yProfile = squeeze(data( x, max(1, y-halfWidth):min(nSubAperture, y+halfWidth)));
    end

    function plotProfiles(obj,  widthPixel, axesList, directions)
            if nargin<2
                widthPixel = 51;
            end
            if nargin<3
                gcf; 
                axesList = {subplot(2,1,1), subplot(2,1,2)};
            end
            if nargin<4
                directions = {0,0};
            end
            [nSubAperture,~] = size(obj.data);
            halfWidth = (widthPixel/2);

            [xProfile, yProfile, xCenter, yCenter] = obj.computeProfiles(widthPixel);
            [nX,~] = size(xProfile);
            [~,nY] = size(yProfile);

            ax = axesList{1};
            x = linspace( max(xCenter-halfWidth, 1), min(xCenter+halfWidth, nSubAperture), nX);
            y = xProfile;
            if directions{1}
                plot(ax, y, x);
                ylim(ax, [xCenter-halfWidth,  xCenter+halfWidth]);
            else
                plot(ax, x, y)
                xlim(ax, [xCenter-halfWidth,  xCenter+halfWidth]);
            end

            ax = axesList{2};
            x = linspace( max(yCenter-halfWidth, 1), min(yCenter+halfWidth, nSubAperture), nY);
            y = yProfile;
            

            if directions{2}
                plot(ax, y, x);
                ylim(ax, [yCenter-halfWidth,  yCenter+halfWidth]);
            else
                plot(ax, x, y);
                xlim(ax, [1, 128]);
                xlim(ax, [yCenter-halfWidth,  yCenter+halfWidth]);
            end

        end
end





