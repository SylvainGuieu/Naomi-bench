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
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

