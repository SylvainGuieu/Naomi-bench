classdef AutocolSequence< naomi.data.BaseData
	properties
	alphaPlotAxes;
	betaPlotAxes;
    
    TIME_INDEX = 1;
    RX_INDEX = 2;
    RY_INDEX = 3;
    ALPHA_INDEX = 4;
    BETA_INDEX  = 5;
    ALPHAERR_INDEX = 6;
    BETAERR_INDEX  = 7;
    end	
    
	methods
        function obj = AutocolSequence(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
            sh = {{'DPR_TYPE', 'GBL_SEQ',''}}; 
        end
        function append(obj, time, rx, ry, alpha, beta, alpha_err, beta_err)
        	obj.setData([obj.getData(); [time, rx, ry, alpha, beta, alpha_err, beta_err]]);
        end
        
        function rx = rx(obj)
            rx = obj.data(':',obj.RX_INDEX);
        end
        function ry = ry(obj)
            ry = obj.data(':',obj.RY_INDEX);
        end
        function alpha = alpha(obj)
            alpha = obj.data(':',obj.ALPHA_INDEX);
        end
        function beta = beta(obj)
            beta = obj.data(':',obj.BETA_INDEX);
        end
        function alphaErr = alphaErr(obj)
            alphaErr = obj.data(':',obj.ALPHAERR_INDEX);
        end
        function betaErr = betaErr(obj)
            betaErr = obj.data(':',obj.BETAERR_INDEX);
        end
        function time = time(obj)
            time = obj.data(':',obj.TIME_INDEX);
        end
        
        function plotMonitoring(obj, angle, timeScale, axes)
            if nargin<3; timeScale = 's';end
            if nargin<4; axes = gca; end;
            t = obj.time;
            switch timeScale
                case 's'; t = t .* 24*3600;
                case 'm'; t = t .* 24*60 ;
                case 'h'; t = t .* 24;
                case 'd'; t = t;
                otherwise
                    error('scale must be "s", "m", "h" or "d"')
            end
            errorbar(axes, t-t(1), obj.(angle), obj.(strcat(angle,'Err')));
            %plot(t-t(1), obj.(angle), 'b-');
            xlabel(axes, strcat('time [', timeScale, ']'));
            ylabel(axes, strcat(angle, ' [arcsec]'));
            title(axes, sprintf('%.3f +- %.4f', mean(obj.(angle)), std(obj.(angle))));
        end
        function plotDependency(obj, axis, angle, axes)
            if nargin<4; axes = gca;end;
            ax = obj.(axis);
            an = obj.(angle);
            
            errorbar(axes, an, ax, obj.(strcat(angle,'Err')));
            xlabel(axes, strcat(axis,' [mm]'));
            ylabel(axes, strcat(angle, ' [arcsec]'));
           
            ttl = sprintf('Gimbal #%d', obj.getKey('GSNUM', -99));
            
            if length(ax)>1
                hold(axes, 'on');
                pol = obj.fit(axis, angle);
                x = [min(ax), max(ax)];
                plot(axes, x, x.*pol(1) + pol(2), 'k-');
                
                title(axes, strcat(ttl,sprintf(' gain = %.3f ', pol(1))));
                hold(axes, 'off');
            end
        end 
        
        function pol = fit(obj, axis, angle)
            ws = warning('off','all');
            pol = polyfit(obj.(axis),obj.(angle),1);
            warning(ws);
        end
       
	end
end


