classdef Bench < naomi.objects.BaseObject
    properties
        benchTemp = -9.9
        propDef = {
            {'benchTemperature', 'BENCHTEMP', 'Bench temperature in degree celcius'}
        };
    end
    methods
        function obj = Bench()
        end
        
        function populateHeader(obj, h)
            % populate a generic fits header for all files a maximum of
            % information is populated here
            
            for i=1:length(obj.propDef)
                def = obj.propDef(i);
                naomi.addToHeader(h, def{2}, obj.(def{1}), def{3});
            end
        end
    end
end