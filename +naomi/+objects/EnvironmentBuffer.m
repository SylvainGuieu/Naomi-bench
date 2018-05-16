classdef EnvironmentBuffer < handle
    properties 
        % temperature array Nx6 
        tempArray;
        % regulation temperature Nx1
        regulTempVector;
        % current vector N 
        currentVector;
        % fan Array Nx2
        fanArray;
        % time Vector 
        timeVector;
        
        % field name and their outer dimension
        fields = { {'tempArray',6},...
                   {'currentVector',1}, ...
                   {'fanArray',2},...
                   {'timeVector',1}, ...
                   {'regulTempVector',1}
                   };
        
        index = 0;
        size;
        stepSize;
        dynamic = 0;
    end
    methods 
        function obj = EnvironmentBuffer(bufferSize, stepSize, dynamic)
            
            for iField=1:length(obj.fields)
                fieldName = obj.fields{iField}{1};
                fieldLen = obj.fields{iField}{2};
                obj.(fieldName) = zeros(bufferSize, fieldLen);
            end

            obj.index = 0;
            obj.size = bufferSize;
            obj.stepSize = stepSize;
            obj.dynamic = dynamic;
        end
        function value = get(obj, key)
            i = obj.index;
           switch key
               case 'temp1'
                   value = obj.tempArray(1:i,1);
               case 'temp2'
                   value = obj.tempArray(1:i,2);
               case 'temp3'
                   value = obj.tempArray(1:i,3);
               case 'temp4'
                   value = obj.tempArray(1:i,4);
               case 'temp5'
                   value = obj.tempArray(1:i,5);
               case 'temp6'
                   value = obj.tempArray(1:i,6);
               case 'current'
                   value = obj.currentVector(1:i);
               case 'time'
                   value = obj.timeVector(1:i);
               case 'fan1'
                   value = obj.fanArray(1:i,1);
               case 'fan2'
                   value = obj.fanArray(1:i,2);
               case 'regulTemp'
                   value = obj.regulTempVector(1:i);
           end
        end
        function plot(obj, ax, xfield, yfield, varargin)
            plot(ax, obj.get(xfield), obj.get(yfield), varargin{:});
            xlabel(ax, xfield);
            ylabel(ax, yfield);
        end
        
        
        function prepareForNext(obj)
            % prepare the buffer to receive new entries
            %
            % If the buffer is dynamic (b.dynamic) and index reach the end 
            % the buffer size is increased by b.stepSize
            % Otherwhise if it is not dynamic and reach the end the last
            % b.stepSize data are copied to the begining of the buffer to
            % leave space for other comming
            if (obj.index+1) > obj.size                
                nField = length(obj.fields);
               if obj.dynamic
                   for iField=1:nField
                        
                        fieldName = obj.fields{iField}{1};
                        fieldLen = obj.fields{iField}{2};
                        old = obj.(fieldName);
                        new = zeros(obj.index+obj.stepSize, fieldLen);
                        new(1:obj.index) = old(1:obj.index);
                        obj.(fieldName) = new;
                        
                   end
                      
               else
                   for iField=1:nField                       
                       fieldName = obj.fields{iField}{1};         
                       obj.(fieldName)(1:end-obj.stepSize,:) = obj.(fieldName)(obj.stepSize+1:end,:);
                   end
                obj.index = obj.size - obj.stepSize;
               end
            end
            
            obj.index = obj.index + 1;
        end
        
        function i = update(obj, e)
            % b.update(e)
            %
            % update the buffer with an naomi.objects.Environment object
            % `e`
            
            obj.prepareForNext;
            i = obj.index;
            
            obj.timeVector(i) = now;
            
            for iTemp=1:6
                obj.tempArray(i,iTemp) = e.getTemp(iTemp);
            end
            for iFan=1:2
                obj.fanArray(i,iFan) = e.getFanVoltage(iFan);
            end  
            obj.regulTempVector(i) = e.getRegulTemp();
            obj.currentVector(i) = e.getCurrent();                        
        end
    end
end