classdef BaseData < handle
    % The goal of Data object is to record data (array) and a header
    % 
    % The Data object must have all the necessary function to plot the 
    % data and to compute basic operation on it as a standalone object.
    % This way Data object can be updated live when doing a measurement 
    % or it can be load from a fits or matlab file for offline analysis
    % typicaly Data object are created from a measurement. The context property 
    % is a cell array containing all the relevant object related to the 
    % data creation. They will write their information to the header. 
    % Exemple of context  {config,bench,wfs,gimbal} will populate the header
    % with configuration keyword, bench information (temperatures, etc ... ), 
    % wave front sensor information (number of sub-aperture, ...) gimbal position.
    
    properties
        dataCash;
        header;
        context;
        file;
    end
    methods
        
        function obj = BaseData(data, header, context)
            import matlab.io.*
            if nargin<1; return; end;
            if nargin<2; header = {}; end;
            if nargin<3; context = {}; end;
            
            if ischar(data) || isstring(data)
                obj.file = matlab.io.fits.openFile(data);
            else
               obj.dataCash = data;
            end
            obj.header = containers.Map();
            % fill the header with the staticHeader for 
            % this object 
            
            sh = obj.staticHeader;
            for iKey=1:length(sh)
                    card = sh{iKey};
                    if length(card)<3
                        obj.header(card{1}) = {card{2}, ''};
                    else
                        obj.header(card{1}) = {card{2}, card{3}};
                    end
            end
            
            obj.addHeader(header);
            
            obj.context = context;
            obj.update();
        end
        function sh = staticHeader(obj)
            sh = {};
        end
        function addHeader(obj, header)
            if isa(header,'containers.Map')
                ks = keys(header);
                for iKey=1:length(ks)
                    obj.header(ks{iKey}) = header{iKey};
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
            % update the header of the object with the context objects
            % if data is given it will replace the curent data
            if nargin>1
                obj.data = data;
            end
            for i=1:length(obj.context)
                    obj.context{i}.populateHeader(obj.header);
            end
            
        end
        
        function [val,comment] = getKey(obj, key, default)
            comment = '';
            if nargin<3
                if isKey(obj.header,key)
                    card = obj.header(key);
                    val = card{1};
                    comment = card{2};
                elseif ~isempty(obj.file)
                     [val, comment] = matlab.io.fits.readKey(obj.file, key);
                else
                    error(strcat('Unknown key ', key));
                end
            else
                val = default;
           
                if isKey(obj.header,key)
                    card = obj.header(key);
                    val = card{1};
                    comment = card{2};
                elseif ~isempty(obj.file)
                    try
                        [val, comment] = matlab.io.fits.readKey(obj.file, key);
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
            if nargin>1
                data = data(varargin{:});
            end
        end
                
        function data = fitsReadData(obj, file)
            data = matlab.io.fits.readImg(file);
        end
        function fitsWriteData(obj, fileName)
            fitswrite(obj.data,fileName);
            %matlab.io.fits.writeImg(.file, obj.getData());
        end
        function saveFits(obj, fileName)
           obj.fitsWriteData(fileName);
           fpr = matlab.io.fits.openFile(fileName, 'READWRITE');
           %obj.fitsWriteData(obj.file);
           
           ks = keys(obj.header);
           for iKey=1:length(ks)
               card = obj.header(ks{iKey});
               matlab.io.fits.writeKey(fpr,ks{iKey}, card{1}, card{2});
           end
           matlab.io.fits.closeFile(fpr);
        end
        function delete(obj)
            if ~isempty(obj.file)
                matlab.io.fits.closeFile(obj.file);
            end
        end
    end
end

