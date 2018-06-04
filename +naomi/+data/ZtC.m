classdef ZtC < naomi.data.BaseData
	properties
        % a Bias attached to this ZtC if any
        DmBiasData;
	end	
	methods
        function obj = ZtC(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'ZTC', naomi.KEYS.DPRTYPEc}};
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
            [zernike,~] = size(obj.data);
        end
        function data = fitsReadData(obj, file)
            % for historical reason anc compatibility with sparta 
            % the data is stored with the last dimension beeing 
            % the zernike number
            data = fitsread(file);
            data = double(data)';
        end
        
        function fitsWriteData(obj, fileName)
                fitswrite(single(obj.data'),fileName);
                %matlab.io.fits.writeImg(.file, obj.getData());
        end
        
        function dmCommandData = dmCommandData(obj, zernike, amplitude)
            if nargin<3
                amplitude = 1.0;
            end
            idx = obj.zernike2index(zernike);
            
            cmd = squeeze(obj.data(idx,':'));
            cmd = cmd';
            cmd = cmd.*amplitude;
                        
            if ~isempty(obj.DmBiasData)
                cmd = cmd + obj.DmBiasData.data';                
            end       
            dmCommandData = naomi.data.DmCommand(cmd);
        end
        function zernikeData = zernike(obj,zernike)
            K = naomi.KEYS;
						
			keys = {K.ZTCXCENTER, K.ZTCYCENTER, ...
			        K.ZTCXSCALE, K.ZTCYSCALE, K.ZTCDIAM, K.FPUPDIAM, K.ORIENT}; 
										
            zernikeData = naomi.data.Zernike(zernike, {{K.ZERN, zernike, K.ZERNc}});
		    naomi.copyHeaderKeys(obj, zernikeData, keys);
        end
    	function plot(obj, axes)
            if nargin <2; axes = gca; end;
            ZtCArray = obj.data;
            [nZernike,nAct] = size(ZtCArray);

            cla(axes); imagesc(axes, ZtCArray);
            
            ttl = 'Zernique to command';
            title(axes, ttl);                    
            ylabel(axes, 'Zerniques');
            xlabel(axes, 'commands');
            colorbar(axes);    
            xlim(axes,[1,nAct]);
            ylim(axes,[1,nZernike]);


        end
        function [ZtP_naomi, ZtP_theoritical, ZtP_dm] = computedZtP(obj, IFMData)
            IFMArray = IFMData.data;
            ZtCArray = obj.data;
            
            IFMArray = IFMData.data;
            [nZernike,nActuator] = size(ZtCArray);
            [~,nSubAperture,~] = size(IFMArray);
            
            
            
            % Compute NAOMI mode over measured IFM
            ZtP_dm = reshape(ZtCArray * reshape(IFMArray,nActuator,nSubAperture*nSubAperture),nZernike,nSubAperture,nSubAperture);
            ZtP_theoritical = naomi.getFromData.theoriticalZtP(obj, nZernike);
            
            
            mask = ZtP_theoritical(1,:,:);
            mask(~isnan(mask)) = 1.0;
            ZtP_naomi =bsxfun(@times,ZtP_dm, mask);
        end
        
        
        
        function plotQc(obj, IFMData, dmBiasData, axesList)
            if nargin<4; axesList = {subplot(4,1,1), subplot(4,1,2), subplot(2,1,2)}; end;
            
            ZtCArray = obj.data;
            IFMArray = IFMData.data;
            [nZernike,nActuator] = size(ZtCArray);
            [~,nSubAperture,~] = size(IFMArray);
            
            % the number of zernike in plots
            maxZernike = min(nZernike, 21);
            
            if nargin<3 || isempty(dmBiasData)
                dmBiasVector = zeros(nActuator, 1);
            else
                dmBiasVector = dmBiasData.data;
            end
            
            [ZtP_naomi, ZtP_theoritical, ZtP_dm] = obj.computedZtP(IFMData);
            ZtP_residual = ZtP_naomi - ZtP_theoritical;
            
            % max command
            maxCommandVector = max(ZtCArray, [], 2);
            rmsZernikeVector = naomi.compute.nanstd(reshape(ZtP_residual,nZernike,nSubAperture*nSubAperture),2);
            
            % Compute true stroke including dmBias
            % TODO pretty sure we can avoid loops here
            stroke = ZtCArray * 0.0;
            for a=1:nActuator
                for z=1:nZernike
                    s1 = (1.-dmBiasVector(a)) / ZtCArray(z,a);
                    s2 = (1.+dmBiasVector(a)) / ZtCArray(z,a);      
                    stroke(z,a) = min( abs(s1),abs(s2)); 
                end
            end
            strokeVector = min(stroke');
            
            
            ax= axesList{1};
            plot(ax, rmsZernikeVector(1:maxZernike),'o-');
            ylabel(ax, 'Res. RMS (um)');
            title(ax, 'Naomi to Command');
            xlabel(ax, 'Naomi Zernike');
            grid(ax); grid(ax,'minor');
            
            ax =axesList{2};
            plot(ax,strokeVector(1:maxZernike),'o-');
            ylabel(ax, 'Max Stroke (um-rms)');
            xlabel(ax, 'Naomi Zernike');
            grid(ax); grid(ax,'minor');
            
            ax =axesList{3};
            
            cla(ax);
            hold(ax,'on');
            for z=1:5
                plot(ax,squeeze(ZtP_dm(z,:,nSubAperture/2)));
            end
            xlabel(ax, 'Sub-aperture');
            ylabel(ax, 'phase (um-rms)');
            title(ax, 'Shape of first Naomi modes');
            grid(ax); grid(ax,'minor');
            hold(ax, 'off');
            
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
        
        function plotModes(obj, IFMData,  axesList)
            
            [nZernike,~] = size(obj.data);
            maxZernike = min(nZernike, 21);

            if nargin<3; clf; axesList = obj.makeAxesList(maxZernike); end;
            
            
            [~,nSubAperture, ~] = size(IFMData.data);
            [ZtP_naomi, ZtP_theoritical, ZtP_dm] = obj.computedZtP(IFMData);
    		ZtP_residual = ZtP_naomi - ZtP_theoritical;
            
            
            rmsZernikeVector = naomi.compute.nanstd(reshape(ZtP_residual,nZernike,nSubAperture*nSubAperture),2);

           
            for iZernike=1:maxZernike 
			    ax = axesList{iZernike*2-1};
			    imagesc(ax, squeeze(ZtP_dm(iZernike,:,:)));
			    set(ax,'XTickLabel','','YTickLabel','');
			    title(ax, sprintf('Zern %i',iZernike));
                daspect(ax, [1 1 1]);
			    ax = axesList{iZernike*2};
			    imagesc(ax, squeeze(ZtP_residual(iZernike,:,:)));
			    set(ax,'XTickLabel','','YTickLabel','');
			    title(ax, sprintf('%.3fum',rmsZernikeVector(iZernike)));
                daspect(ax, [1 1 1]);
            end	
        end
        
        
        function ZtCSpartaData = toSparta(obj)
            % SPARTA does not contains the piston and is limited to 20
            % thernikes
            ZtCSpartaData = naomi.data.ZtCSparta(obj.data(2:21,':'), obj.header);
% 						dprVer = obj.getKey(naomi.KEYS.DPRVER, '');
% 						if dprVer; 
% 							dprVer = strcat(dprVer, '_SPARTA');
% 						else
% 							dprVer = 'SPARTA';
% 						end
            ZtCSpartaData.setKey(naomi.KEYS.DPRVER,'SPARTA', naomi.KEYS.DPRVERc);
            ZtCSpartaData.setKey(naomi.KEYS.DPRTYPE, 'M2DM', naomi.KEYS.DPRTYPEc);

        end
        
        function gui(obj)
            naomi.gui.ztcExplorerGui(obj);
        end
 	end
end