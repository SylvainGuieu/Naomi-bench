classdef ZtP < naomi.data.PhaseCube
	properties
	
    maxZernike = 21; %maxNumber of zernike to plot
    
	end	
	methods
        function obj = ZtP(varargin)
            obj = obj@naomi.data.PhaseCube(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'ZTP_MATRIX', naomi.KEYS.DPRTYPEc}};
        end
        function ZtPSpartaData = toSparta(obj)
            ZtPSpartaData = naomi.data.ZtPSpartaData(obj.data, obj.header);
						if dprVer; 
							dprVer = strcat(dprVer, '_SPARTA');
						else
							dprVer = 'SPARTA';
						end
            ZtPSpartaData.setKey(naomi.KEYS.DPRVER, dprVer, naomi.KEYS.DPRVERc);
        end
        
        function idx = zernike2index(obj, zernike)
            % convert the given zernike number to the table index
            idx = zernike;
        end
        function zernike = firstZernike(obj)
            % the first zernike number of the data 
            zernike = 1;
        end
        function zernike = lastZernike(obj)
            [zernike,~, ~] = size(obj.data);
        end
        
        
        function phaseZernikeData = phaseDataOfZernike(obj, zernike)
            K = naomi.KEYS;
            phaseArray = squeeze(obj.phaseArray(obj.zernike2index(zernike)));
            phaseZernikeData = naomi.data.PhaseZernike(phaseArray, {{naomi.KEYS.ZERN, zernike, naomi.KEYS.ZERNc}});           
            naomi.copyHeaderKeys( obj, phaseZernikeData, naomi.ztcKeyList);
            naomi.copyHeaderKeys( obj, phaseZernikeData, naomi.benchKeyList);
            naomi.copyHeaderKeys( obj, phaseZernikeData, naomi.ifmKeyList);
            naomi.copyHeaderKeys( obj, phaseZernikeData, {K.XOFFSET, K.YOFFSET, K.DMANGLEOFFSET, K.PIXSCALEFACTOR});
            
        end
        
        function zernikeData = zernike(obj, zernike)
            zernikeData = naomi.data.Zernike(zernike);
        end
        
        function axesList = makeAxesList(obj, nZernike)
            axesList = {};
            clf;
            figNum = get(gcf, 'Number');
            
            n = 7; m =6; % :TOTO adapt n and m in function to maxZernike
            i = 0;
            for iZernike=1:nZernike
                
                i = i+1;
                
                axesList{length(axesList)+1} = subplot(n,m,i*2-1); % screen phase
                axesList{length(axesList)+1} = subplot(n,m,i*2); % residuals
                if ~mod(iZernike, n*m/2) && iZernike<nZernike
                    i = 0;
                    figNum = figNum+1;
                    figure(figNum);
                    clf;
                end
            end
        end
        
        
        function plotQc(obj, axesList)
            if nargin<2
                clf;
                axesList = {subplot(4,1,1),  subplot(4,1,2), subplot(2,1,2)};
            end
            
            
            
            
            ZtPArray = obj.data;
            [nZer,nSubAperture,~] = size(ZtPArray);
            maxZernike = min(nZer, obj.maxZernike);
            K = naomi.KEYS;
            
           ZtPRefArray = naomi.getFromData.theoriticalZtP(obj, maxZernike);
            
           [residualVector, gainVector] = naomi.compute.ztpDifference(ZtPArray, ZtPRefArray(obj.firstZernike:end,:,:), maxZernike);
           
           axes = axesList{1};
           plot(axes, residualVector, 'bo-');
           ylabel(axes, 'Res. RMS (um)');
           title(axes, 'Measured naomi modes');
           grid(axes);  set(axes,'xminorgrid','on','yminorgrid','on');
           xlim(axes, [0,maxZernike+1]);
           
           axes = axesList{2};
           plot(axes, gainVector, 'bo-');
           ylabel(axes, 'gain');
           xlabel(axes, 'Naomi mode');
           grid(axes);  set(axes,'xminorgrid','on','yminorgrid','on');
           xlim(axes, [0,maxZernike+1]);
           ylim(axes, [0.8, 1.2]);
           
           axes = axesList{3};
           
           cla(axes);
           hold(axes, 'on');
           ym = 0.0;
           for z=1:5
               A = ZtPArray(z,:,nSubAperture/2);
               
               plot(axes, squeeze(A));
               ym = max(ym, max(abs(A(:))));
           end
           plot(axes, [nSubAperture/2., nSubAperture/2.], [-ym, +ym], 'r:');
           hold(axes, 'off');
           xlabel(axes, 'Sub-aperture');
           ylabel(axes, 'phase (um)');
           title(axes, 'Obs. of some Naomi modes (piston arbitrary)');
           grid(axes);  set(axes,'xminorgrid','on','yminorgrid','on');
           xlim(axes, [0, nSubAperture+1]);
          
        end
            
    	function plotModes(obj,  axesList)
            
            ZtPArray = obj.data;
            [nZernike,~,~] = size(ZtPArray);
            nZernike = min(nZernike,obj.maxZernike);	
            if nargin<2; clf; axesList = obj.makeAxesList(nZernike); end;
    		
    		
            ZtPRefArray = naomi.getFromData.theoriticalZtP(obj, nZernike);
			[residualVector, ~, residualArray] = naomi.compute.ztpDifference(ZtPArray, ZtPRefArray(obj.firstZernike:end,:,:), nZernike);
			
    		for iZernike=1:nZernike
                
			    ax = axesList{iZernike*2-1};
			    imagesc(ax, squeeze(ZtPArray(iZernike,:,:)));
			    set(ax,'XTickLabel','','YTickLabel','');
			    title(ax, sprintf('Mode %i',iZernike));
                daspect(ax, [1 1 1]);
			    ax = axesList{iZernike*2};
			    imagesc(ax, squeeze(residualArray(iZernike,:,:)));
			    set(ax,'XTickLabel','','YTickLabel','');
			    title(ax, sprintf('%.3fum',residualVector(iZernike)));
                daspect(ax, [1 1 1]);
			end	
        end
        function gui(obj)
            naomi.gui.ztpExplorerGui(obj)
        end
 	end
end