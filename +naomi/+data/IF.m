classdef IF < naomi.data.Phase
	properties
       profileResult; % store the result of a fitted profile
       fitType = 'gauss' % the type of fitting
	end	
	methods
        function obj = IF(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IF', ''}};
        end
        
        function plotProfile(obj, axes)
            if nargin<2; axes = gca; end
            data =  obj.data;
            [nSubAperture,~] = size(data);
            [Y,X] = meshgrid(1:nSubAperture);
            fit = obj.profileFit;
            model = naomi.compute.ifmProfileModel(fit, X, Y);
            alpha = linspace(0, 2*pi, 50);
            cla(axes); imagesc(axes, model);
            colorbar(axes);
            daspect(axes, [1 1 1]);
            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);
            hold(axes, 'on'); 
                plot(axes,  fit.yHwhm*cos(alpha+fit.angle)+fit.yCenter, fit.xHwhm*sin(alpha+fit.angle)+fit.xCenter, 'k-'); 
            hold(axes, 'off');
        end
        
        function plotProfileResidual(obj, axes)
            if nargin<2; axes = gca; end
            data =  obj.data;
            [nSubAperture,~] = size(data);
            [Y,X] = meshgrid(1:nSubAperture);
            fit = obj.profileFit;
            model = naomi.compute.ifmProfileModel(fit, X, Y);
            alpha = linspace(0, 2*pi, 50);
            residual =  data-model;
            cla(axes); imagesc(axes,residual);
            colorbar(axes);
            daspect(axes, [1 1 1]);
            title(axes, sprintf('rms=%.3e', naomi.compute.nanstd(residual(:))));
            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);
            hold(axes, 'on'); 
                plot(axes,  fit.yHwhm*cos(alpha+fit.angle)+fit.yCenter, fit.xHwhm*sin(alpha+fit.angle)+fit.xCenter, 'k-'); 
            hold(axes, 'off');
        end

            
        function plotScreenPhase(obj, axes)
        
            if nargin<2; axes = gca; end
            data =  obj.data;
            [nSubAperture,~] = size(data);
            cla(axes); imagesc(axes, squeeze(data(:,:)));
            colorbar(axes);
            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);

            fit = obj.profileFit;

            alpha = linspace(0, 2*pi, 50);


            hold(axes, 'on'); 

                plot(axes,  fit.yHwhm*cos(alpha+fit.angle)+fit.yCenter, fit.xHwhm*sin(alpha+fit.angle)+fit.xCenter, 'k-'); 
            hold(axes, 'off');

            title(axes, sprintf('#%d Amp=%.3f hwhm=%.3f x,y =%.1f, %.1f', obj.getKey('ACTNUM', -99), ...
                                                        fit.amplitude, fit.hwhm, ...
                                                        fit.xCenter, fit.yCenter));
    end
    function fit = profileFit(obj)
        if isempty(obj.profileResult) || ~strcmp(obj.profileResult.type, obj.fitType)
                obj.profileResult = naomi.compute.fittedIFprofile(obj.data, obj.fitType);
             end        
         fit = obj.profileResult;
    end
    function [xProfile,yProfile] = getXYProfiles(obj, xCenter,yCenter)
        
        if nargin<2
            fit = obj.profileFit;
            xCenter = fit.xCenter;
            yCenter = fit.yCenter;
        end
        x0 = int32(xCenter);
        y0 = int32(yCenter);
        data = obj.data;
        [nSubAperture,~] = size(data); 
        
        xProfile = squeeze(data(:,y0));
        yProfile = squeeze(data(x0,:));
    end

    function plotProfiles(obj, axesList, directions)
        
            [nSubAperture,~] = size(obj.data);
            
            if nargin<2
                gcf; 
                axesList = {subplot(2,1,1), subplot(2,1,2)};
            end
            if nargin<3
                directions = {0,0};
            end
            
            widthPixel = nSubAperture;
            halfWidth = (widthPixel/2);
   
            fit = obj.profileFit;
            
            xCenter = fit.xCenter;
            yCenter = fit.yCenter;
            
            [xProfile, yProfile] = obj.getXYProfiles(xCenter, yCenter);
            
            
            [nX,~] = size(xProfile);
            [~,nY] = size(yProfile);
                
            ax = axesList{1};
            r = linspace( 1, nSubAperture, nSubAperture);
            profile = xProfile;
            rModel = linspace(1, nSubAperture, nSubAperture*4);
            profileModel = naomi.compute.ifmProfileModel(fit, rModel, fit.yCenter); 
            
            if directions{1}
                plot(ax, profile, r);
                hold(ax, 'on'); plot(ax, profileModel, rModel);hold(ax, 'off');
                %ylim(ax, [xCenter-halfWidth,  xCenter+halfWidth]);
                ylim(ax, [1, nSubAperture]);
            else
                plot(ax, r, profile);
                hold(ax, 'on'); plot(ax, rModel, profileModel);hold(ax, 'off');
                %xlim(ax, [xCenter-halfWidth,  xCenter+halfWidth]);
                xlim(ax, [1, nSubAperture]);
            end

            ax = axesList{2};
            r = linspace( max(yCenter-halfWidth, 1), min(yCenter+halfWidth, nSubAperture), nY);
            profile = yProfile;
            profileModel = naomi.compute.ifmProfileModel(fit, fit.xCenter, rModel);
            
            if directions{2}
                plot(ax, profile, r);
                hold(ax, 'on'); plot(ax, profileModel, rModel);hold(ax, 'off');
                %ylim(ax, [yCenter-halfWidth,  yCenter+halfWidth]);
                ylim(ax, [1, nSubAperture]);
            else
                plot(ax, r, profile);
                hold(ax, 'on'); plot(ax, rModel, profileModel);hold(ax, 'off');       
                %xlim(ax, [yCenter-halfWidth,  yCenter+halfWidth]);
                xlim(ax, [1, nSubAperture]);
            end

        end
    end
end





