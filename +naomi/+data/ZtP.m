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
            ZtPSpartaData.setKey(naomi.KEYS.DPRVER, sprVer, naomi.KEYS.DPRVERc);
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
             
            phaseArray = squeeze(obj.phaseArray(obj.zernike2index(zernike)));
            
            phaseZernikeData = naomi.data.PhaseZernike(phaseArray, obj.header);             
            phaseZernikeData.setKey(naomi.KEYS.ZERN, zernike, naomi.KEYS.ZERNc);
            phaseZernikeData.setKey(naomi.KEYS.GAIN, median(obj.gainVector), naomi.KEYS.GAINc);
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
            ZtPRefArray = naomi.compute.theoriticalZtP(...
    						 nSubAperture, ...
                             obj.xCenter, ...
                             obj.yCenter, ...
                             obj.pupillDiameterPix, ...
							 0.0,... 
                             maxZernike, ...
                             obj.getKey(K.ORIENT, K.ORIENTd)); 
            
            
           [residualVector, gainVector] = naomi.compute.ztpDifference(ZtPArray, ZtPRefArray, maxZernike);
           
           axes = axesList{1};
           plot(axes, residualVector);
           ylabel(axes, 'Res. RMS (um)');
           title(axes, 'Measured naomi modes');
           grid(axes);  set(axes,'xminorgrid','on','yminorgrid','on');
           xlim(axes, [0,maxZernike+1]);
           
           axes = axesList{2};
           plot(axes, gainVector);
           ylabel(axes, 'gain');
           xlabel(axes, 'Naomi mode');
           grid(axes);  set(axes,'xminorgrid','on','yminorgrid','on');
           xlim(axes, [0,maxZernike+1]);
           
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
            [nZernike,nSubAperture,~] = size(ZtPArray);
            nZernike = min(nZernike,obj.maxZernike);	
            if nargin<2; clf; axesList = obj.makeAxesList(nZernike); end;
    		
    		
            K = naomi.KEYS;
            
    		ZtPRefArray = naomi.compute.theoriticalZtP(...
    						 nSubAperture, ...
                             obj.xCenter, ...
                             obj.yCenter, ...
                             obj.pupillDiameterPix, ...
														 0.0, ...
                             nZernike, ...
                             obj.getKey(K.ORIENT, K.ORIENTd)); 
    		
					
			
			
			[residualVector, ~] = naomi.compute.ztpDifference(ZtPArray, ZtPRefArray, nZernike);
			
    		for iZernike=1:nZernike
                idx = obj.zernike2index(iZernike);
			    ax = axesList{iZernike*2-1};
			    imagesc(ax, squeeze(ZtPArray(idx,:,:)));
			    set(ax,'XTickLabel','','YTickLabel','');
			    title(ax, sprintf('Mode %i',iZernike));
                daspect(ax, [1 1 1]);
			    ax = axesList{iZernike*2};
			    imagesc(ax, squeeze(ZtPArray(idx,:,:) - ZtPRefArray(iZernike,:,:)));
			    set(ax,'XTickLabel','','YTickLabel','');
			    title(ax, sprintf('%.3fum',residualVector(iZernike)));
                daspect(ax, [1 1 1]);
			end	
        end
        function gui(obj)
            ztpExplorerGui(obj)
        end
 	end
end