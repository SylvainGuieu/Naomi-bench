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
        data;
        header;
        context;
    end
    
    methods
        function obj = BaseData(data, header, context)
            if nargin<1; return; end;
            if nargin<2; header = {}; end;
            if nargin<3; container = {}; end;
 
            obj.data = data;
            obj.header = container.Map();
            obj.addHeader(header);

            obj.contect = context;
            obj.update();
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

        function update(obj)
            % update the header of the object with the context objects
            for i=1:length(obj.context)
                    obj.context{i}.populateHeader(obj.header);
            end
        
        function [val,comment] = getKey(obj, key, default)
            comment = '';
            if nargin<3; 
                val = []; 
            else
                val = default;
            end;
            if isKey(obj.header,key)
                card = obj.header(key)
                val = card{1};
                comment = card{2};
        end
        function setKey(obj, key, val, comment)
            if nargs<4; comment = ''; end
            obj.header(key) = val;
        end


        
    end
end

