classdef Zernike < naomi.data.BaseData
    % handle some plots from a Zernike number only 
	properties
        nSubAperture = 512; % for the phase plot 
        
	end	
	methods
        function obj = Zernike(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ZNUM', ''}};
        end
        
        function plotInfo(obj, axes)
            if nargin<2; axes = gca; end
            zernike = obj.data;
            
            [~, longName, equationStr] = naomi.compute.zernikeInfo(zernike);
            cla(axes);
            box(axes,'off');
            box(axes,'off');
            set(axes,'xtick',[]);
            set(axes,'xticklabel',[]);
            set(axes,'ytick',[]);
            set(axes,'yticklabel',[]);
            set(axes,'Visible','off');
            
            text(axes, ...
                 0.5, 0.5, {longName, '', strcat('$',equationStr,'$')}, ...
                 'Interpreter', 'latex',...
                 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle',...
                 'FontSize',18);
        end
            
        
        function plotPhase(obj, axes)
            if nargin<2; axes = gca; end
            zernike = obj.data;
            n = obj.nSubAperture;
            orientation = obj.getKey(naomi.KEYS.ORIENT,naomi.KEYS.ORIENTd);
            
            theoriticalPhase = naomi.compute.theoriticalPhase(n, n/2, n/2, n, zernike, orientation);
            cla(axes);
            imagesc(axes, theoriticalPhase);
            xlim(axes, [0,512]);
            ylim(axes, [0,512]);
            box(axes,'off');
            box(axes,'off');
            set(axes,'xtick',[]);
            set(axes,'xticklabel',[]);
            set(axes,'ytick',[]);
            set(axes,'yticklabel',[]);
            daspect(axes, [1 1 1]);
        end
    end
end