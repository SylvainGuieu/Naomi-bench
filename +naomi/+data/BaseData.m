classdef BaseData < handle
    % The goal of Data object is to record data (array) and a header
    % 
    % The Data object must have all the necessary function to plot the 
    % data and to compute basic operation.
    % This way Data object can be created live when doing a measurement 
    % or it can be loaded from a fits or matlab file for offline analysis.
    % typicaly Data object are created from a measurement.
    properties
        dataCash;
        header;
        file;
        filePointer;
    end
    methods
        
        function obj = BaseData(data, header)
            import matlab.io.*
            if nargin<1; return; end
            if nargin<2; header = {}; end
            
            if ischar(data) || isstring(data)
                obj.file = data;%matlab.io.fits.openFile(data);
                
            else
               obj.setData(data);
            end
            obj.header = containers.Map();
            % fill the header with the staticHeader for 
            % this object only if it is not a file
            if isempty(obj.file)
                sh = obj.staticHeader;
                for iKey=1:length(sh)
                        card = sh{iKey};
                        if length(card)<3
                            obj.header(card{1}) = {card{2}, ''};
                        else
                            obj.header(card{1}) = {card{2}, card{3}};
                        end
                end
            end
            obj.addHeader(header);
            
            
            % load the data
            if ~isempty(obj.file)
                obj.data;
            end
        end
        function sh = staticHeader(obj)
            sh = {};
        end
        
        function info = shortInfo(obj)
           K = naomi.KEYS;
            
           info =  obj.getKey(K.DATE, 'Unknown');
           %tpl = obj.getKey(K.TPLNAME, '');
           %if tpl; info = strcat(info, '/ ', tpl);end
           dpr = obj.getKey(K.DPRTYPE, '');
           if dpr; info = strcat(info, '/ ', dpr); end
           dm = obj.getKey(K.DMID, '');
           if dm; info = strcat(info, '/ ', dm); end
        end
        
        function dmId = dmId(obj)
            dmId = obj.getKey(naomi.KEYS.DMID, '');
        end
        
        function addHeader(obj, header)
            if isa(header,'containers.Map')
                ks = keys(header);
                for iKey=1:length(ks)
                    obj.header(ks{iKey}) = header(ks{iKey});
                end
            elseif iscell(header)
                for iKey=1:length(header)
                    card = header{iKey};
                    if length(card)<3
                        obj.header(card{1}) = {card{2}, ''};
                    else
                        obj.header(card{1}) = {card{2}, card{3}};
                    end
                end
            else
                % ToDo include the case of a fits header
                error('header object must be a cell or a Map');
            end
        end

        function update(obj, data)
            % update the data
            obj.dataCash = data;            
        end
        
        function [val,comment] = getKey(obj, key, default)
            comment = '';
            if nargin<3
                if isKey(obj.header,key)
                    card = obj.header(key);
                    val = card{1};
                    comment = card{2};
                elseif ~isempty(obj.file)
                    % open the fits file and keep it open for further
                    % reference
                     if isempty(obj.filePointer)
                         obj.filePointer = matlab.io.fits.openFile(obj.file);
                     end
                     [val, comment] = matlab.io.fits.readKey(obj.filePointer, key);
                     num = str2double(val);
                     if ~isnan(num); val = num;end
                else
                    error(sprintf('Unknown key: %s', key));
                end
            else
                val = default;
           
                if isKey(obj.header,key)
                    card = obj.header(key);
                    val = card{1};
                    comment = card{2};
                elseif ~isempty(obj.file)
                    % open the fits file and keep it open for further
                    % reference
                     if isempty(obj.filePointer)
                         obj.filePointer = matlab.io.fits.openFile(obj.file);
                     end
                    try
                        [val, comment] = matlab.io.fits.readKey(obj.filePointer, key);
                        num = str2double(val);
                        if ~isnan(num); val = num; end
                    catch
                    end
                end
            end
        end
        function setKey(obj, key, val, comment)
            if nargin<4; comment = ''; end
            obj.header(key) = {val, comment};
        end
        function data = getData(obj)
            data = [];
            if isempty(obj.dataCash)
                if ~isempty(obj.file)
                    data = obj.fitsReadData(obj.file);
                    obj.dataCash = data;
                end
            else
                data = obj.dataCash;
            end
        end
        function setData(obj, data)
            obj.dataCash = data;
        end
        function data = data(obj, varargin)
            data = obj.getData();
            if ~isempty(varargin)
                data = data(varargin{:});
            end
        end
                
        function data = fitsReadData(obj, fileName)
            data = fitsread(fileName);
        end

        function fitsWriteData(obj, fileName)
            fitswrite(obj.data,fileName);
            %matlab.io.fits.writeImg(.file, obj.getData());
        end
        function saveFromDate(obj, directory, dte)
            baseFileName = strcat(obj.getKey('DPR_TYPE', 'UNKNOWN'), '_', datestr(dte, 'yyyy-mm-ddThh:MM:SS'));
            
            if exist(fullfile(directory, strcat(baseFileName, '.fits')), 'file')
                counter = 1
                while exist(fullfile(directory, strcat(baseFileName,sprintf('_%03d',counter), '.fits')), 'file')
                    counter = counter + 1;
                end
                fileName = fullfile(directory, strcat(baseFileName,sprintf('_%03d',counter), '.fits'));                
            else
                fileName = fullfile(directory, strcat(baseFileName, '.fits'));
            end
            obj.saveFits(fileName);
        end

        function saveFits(obj, fileName)
           obj.fitsWriteData(fileName);
           fpr = matlab.io.fits.openFile(fileName, 'READWRITE');
           %obj.fitsWriteData(obj.file);
           
           ks = keys(obj.header);
           for iKey=1:length(ks)
               card = obj.header(ks{iKey});
               if card{2} % to avoid empty comment card 
                   c = card{2};
               else
                   c = card{1};
               end
               value = card{1};
               if isempty(value)% avoid empty, empty is ''
                   value = '???';
               end
                
               
               matlab.io.fits.writeKey(fpr,ks{iKey}, value, c);
           end
           matlab.io.fits.closeFile(fpr);
        end
        function delete(obj)
            if ~isempty(obj.filePointer)
                matlab.io.fits.closeFile(obj.filePointer);
            end
        end
    end
end

