classdef EnvironmentBuffer < handle
    properties 
        
        data;
        
        TIME = 1;
        CURRENT = 2;
        FANIN = 3;
        FANOUT = 4;
        TEMPREGUL = 5;
        TEMPIN = 6;
        TEMPOUT = 7;
        TEMPMIRROR = 8;
        TEMPQSM = 9;
        TEMPEMBIANT = 10;
        
        NCOL = 10;
        
        index = 0;
        size;
        stepSize;
        dynamic = 0;
    end
    methods 
        function obj = EnvironmentBuffer(bufferSize, stepSize, dynamic)
            
            obj.data = zeros(bufferSize, obj.NCOL);
            
            obj.index = 0;
            obj.size = bufferSize;
            obj.stepSize = stepSize;
            obj.dynamic = dynamic;
        end
        function value = get(obj, key)
            i = obj.index;
           switch key
               case 'tempIn'
                   value = obj.data(1:i,obj.TEMPIN);
               case 'tempOut'
                   value = obj.data(1:i,obj.TEMPOUT);
               case 'tempRegul'
                   value = obj.data(1:i,obj.TEMPREGUL);
               case 'tempMirror'
                   value = obj.data(1:i,obj.TEMPMIRROR);
               case 'tempQSM'
                   value = obj.data(1:i,obj.TEMPQSM);
               case 'tempEmbiant'
                   value = obj.data(1:i,obj.TEMPEMBIANT);
               case 'time'
                   value = obj.data(1:i,obj.TIME);
               
                   
               case 'current'
                   value = obj.data(1:i,obj.CURRENT);
               
               case 'fanIn'
                   value = obj.data(1:i,obj.FANIN);
               case 'fanOut'
                   value = obj.data(1:i,obj.FANOUT);  
                   
               otherwise
                   error('unknown field "%s"', key);
           end
           
        end
        function plot(obj, ax, xfield, yfield, varargin)
            plot(ax, obj.get(xfield), obj.get(yfield), varargin{:});
            xlabel(ax, xfield);
            ylabel(ax, yfield);
        end
        
        function plotAll(obj, axesList)
            if nargin<2
                axesList = {subplot(4,1,1),subplot(4,1,2), subplot(2,1,2)};
            end
            
            time = obj.get('time');
            time = (time-time(1))*24*3600;
            
            plot(axesList{1}, time, obj.get('current'));
            ylabel(axesList{1}, 'current');
            
            plot(axesList{2}, time, obj.get('fanIn'));
            hold(axesList{2}, 'on')
            plot(axesList{2}, time, obj.get('fanOut'));
            ylabel(axesList{2}, 'voltage');
            
            plot(axesList{3}, time, obj.get('tempOut'), 'g-',  'DisplayName','peltier out');
            hold(axesList{3}, 'on');
            plot(axesList{3}, time, obj.get('tempIn'), 'b-', 'DisplayName','peltier in');
            plot(axesList{3}, time, obj.get('tempRegul'), 'b:', 'DisplayName','regul setpoint');
            
            plot(axesList{3}, time, obj.get('tempEmbiant'), 'k:', 'DisplayName', 'embiant');
            
            plot(axesList{3}, time, obj.get('tempMirror'), 'r-', 'DisplayName', 'mirror');
            plot(axesList{3}, time, obj.get('tempQSM'), 'r:', 'DisplayName', 'qsm');
            legend(axesList{3}, 'Location','southwest');
            legend(axesList{3}, 'boxoff');
            
            hold(axesList{3}, 'off');
            ylabel(axesList{3}, 'temp');
            xlabel(axesList{3}, 'time');
            
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
                   
                   old = obj.data;
                   new = zeros(obj.index+obj.stepSize, obj.NCOL);
                   new(1:obj.index) = old(1:obj.index);
                   obj.data = new;
                    
                      
               else
                   obj.data(1:end-obj.stepSize,:) = obj.data(obj.stepSize+1:end,:);
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
            
            obj.data(i, obj.TIME) = now;
            
            obj.data(i, obj.TEMPREGUL) = e.tempRegul;
            
            obj.data(i, obj.TEMPIN) = e.tempIn;
            obj.data(i, obj.TEMPOUT) = e.tempOut;
            obj.data(i, obj.TEMPMIRROR) = e.tempMirror;
            obj.data(i, obj.TEMPQSM) = e.tempQSM;
            obj.data(i, obj.TEMPEMBIANT) = e.tempEmbiant;
            obj.data(i, obj.FANIN) = e.fanIn;
            obj.data(i, obj.FANOUT) = e.fanOut;
            obj.data(i, obj.CURRENT) = e.current;                  
        end
    end
end