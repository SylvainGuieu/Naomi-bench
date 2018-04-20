classdef ZtC < naomi.data.BaseData
	properties
        % a Bias attached to this ZtC if any
        BiasData; 

	end	
	methods
        function obj = ZtC(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ZTC_MATRIX', ''}};
        end   
        function data = fitsReadData(obj, file)
            % for historical reason anc compatibility with sparta 
            % the data is stored with the last dimension beeing 
            % the zernike number
            data = matlab.io.fits.readImg(file);
            data = double(data)';
        end
        function fitsWriteData(obj, fileName)
                fitswrite(single(obj.data'),fileName);
                %matlab.io.fits.writeImg(.file, obj.getData());
        end   
        function dmVectorData = dmVector(obj, zernike, amplitude);
            if nargin<3
                amplitude = 1.0;
            end
            cmd = squeeze(obj.data(zernike,':'));
            cmd = cmd';
            cmd = cmd.*amplitude;
            
            if ~isempty(obj.BiasData)
                cmd = cmd + app.BiasData.data;
            end
            dmVectorData = naomi.data.dmVector(cmd);
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
            ZtCSpartaData = naomi.data.ZtCSpartaData(obj.data, obj.header, obj.context);
        end
        function gui(obj)
            ztcExplorerGui(obj);
        end
 	end
end