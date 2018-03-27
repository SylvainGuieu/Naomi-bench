classdef BaseData
    %BASEDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data;
        header;
    end
    
    methods
        function obj = BaseData(data, header, context)
            if nargin<2; header = {}; end;
            if nargin>=3
                for i=1:length(context)
                    context{i}.populateHeader(header);
                end
            end
            obj.data = data;
            obj.header = header;
        end
        function key = getKey(obj, key, default)
            if nargin<3; 
                key = []; 
            else
                key = default;
            end;

            for iKey=1:length(obj.header)
                if strcomp(obj.header{iKey}{1}, key)
                    key = obj.header{iKey}{2};
                    break;
                end
            end
        end
        
    end
end

