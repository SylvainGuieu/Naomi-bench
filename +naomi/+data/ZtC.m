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
        
        function ZtCSpartaData = toSparta(obj)
            % SPARTA does not contains the piston and is limited to 20
            % thernikes
            ZtCSpartaData = naomi.data.ZtCSparta(obj.data(2:21,':'), obj.header);
						dprVer = obj.getKey(naomi.KEYS.DPRVER, '');
						if dprVer; 
							dprVer = strcat(dprVer, '_SPARTA');
						else
							dprVer = 'SPARTA';
						end
            ZtCSpartaData.setKey(naomi.KEYS.DPRVER, dprVer, naomi.KEYS.DPRVERc);
        end
        
        function gui(obj)
            ztcExplorerGui(obj);
        end
 	end
end