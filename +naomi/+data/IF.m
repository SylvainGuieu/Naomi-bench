classdef IF < naomi.data.Phase
	properties
       profileResult; % store the result of a fitted profile
       fitType = 'naomi' % the type of fitting
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
            [X,Y] = meshgrid(1:nSubAperture);
            fit = obj.profileFit;
            model = naomi.compute.ifmProfileModel(fit, X, Y);
            alpha = linspace(0, 2*pi, 50);
            cla(axes); imagesc(axes, model);
            colorbar(axes);
            daspect(axes, [1 1 1]);
            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);
            hold(axes, 'on'); 
                plot(axes,  fit.yHwhm*cos(alpha+fit.angle)+fit.xCenter, fit.xHwhm*sin(alpha+fit.angle)+fit.yCenter, 'k-'); 
            hold(axes, 'off');
        end
        
        function plotProfileResidual(obj, axes)
            if nargin<2; axes = gca; end
            data =  obj.data;
            [nSubAperture,~] = size(data);
            [X,Y] = meshgrid(1:nSubAperture);
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
                plot(axes,  fit.yHwhm*cos(alpha+fit.angle)+fit.xCenter, fit.xHwhm*sin(alpha+fit.angle)+fit.yCenter, 'k-'); 
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

                plot(axes,  fit.yHwhm*cos(alpha+fit.angle)+fit.xCenter, fit.xHwhm*sin(alpha+fit.angle)+fit.yCenter, 'k-'); 
            hold(axes, 'off');

            title(axes, sprintf('#%d Amp=%.3f hwhm=%.3f x,y =%.1f, %.1f', obj.getKey('ACTNUM', -99), ...
                                                        fit.amplitude, fit.hwhm, ...
                                                        fit.xCenter, fit.yCenter));
            daspect(axes, [1,1,1]);
        end
    
        function plotAll(obj, axesList)
           if nargin<2
               clf;
               axesList = {subplot(2,1,1), subplot(4,2,5),  subplot(4,2,6),... 
                           subplot(4,2,7), subplot(4,2,8)};
           end
           
           obj.plotScreenPhase(axesList{1});
           obj.plotProfile(axesList{2});
           obj.plotProfileResidual( axesList{3}); 
           obj.plotProfiles( axesList(4:5));
           
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
        
        xProfile = squeeze(data(y0, :));
        yProfile = squeeze(data(:, x0));
    end

    function plotProfiles(obj, axesList)
        
            [nSubAperture,~] = size(obj.data);
            
            if nargin<2
                gcf; 
                axesList = {subplot(2,1,1), subplot(2,1,2)};
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
            
                plot(ax, r, profile);
                hold(ax, 'on'); plot(ax, rModel, profileModel, 'r:');hold(ax, 'off');
                %xlim(ax, [xCenter-halfWidth,  xCenter+halfWidth]);
                xlim(ax, [1, nSubAperture]);
                xlabel(ax, 'x profile');
                
            ax = axesList{2};
            %r = linspace( max(yCenter-halfWidth, 1), min(yCenter+halfWidth, nSubAperture), nY);
            r = linspace( 1, nSubAperture, nSubAperture);
            profile = yProfile;
            profileModel = naomi.compute.ifmProfileModel(fit, fit.xCenter, rModel);
            
            
                plot(ax, r, profile);
                hold(ax, 'on'); plot(ax, rModel, profileModel, 'r:');hold(ax, 'off');       
                %xlim(ax, [yCenter-halfWidth,  yCenter+halfWidth]);
                xlim(ax, [1, nSubAperture]);
                xlabel(ax, 'Y profile');
           

        end
    end
end





