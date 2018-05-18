classdef EnvironmentBuffer < handle
    properties 
        
        buffer;
        
        TIME = 1;
        CURRENT = 2;
        FANIN = 3;
        FANOUT = 4;
        TREGUL = 5;
        TIN = 6;
        TOUT = 7;
        TMIRROR = 8;
        TQSM = 9;
        TEMBIANT = 10;
        
        NCOL = 10;
        
        index = 0;
        size;
        stepSize;
        dynamic = 0;
    end
    methods 
        function obj = EnvironmentBuffer(bufferSize, stepSize, dynamic)
            
            obj.buffer = zeros(bufferSize, obj.NCOL);
            
            obj.index = 0;
            obj.size = bufferSize;
            obj.stepSize = stepSize;
            obj.dynamic = dynamic;
        end
        function value = get(obj, key)
            i = obj.index;
           switch key
               case 'tempIn'
                   value = obj.buffer(1:i,obj.TIN);
               case 'tempOut'
                   value = obj.buffer(1:i,obj.TOUT);
               case 'tempRegul'
                   value = obj.buffer(1:i,obj.TREGUL);
               case 'tempMirror'
                   value = obj.buffer(1:i,obj.TMIRROR);
               case 'tempQSM'
                   value = obj.buffer(1:i,obj.TQSM);
               case 'tempEmbiant'
                   value = obj.buffer(1:i,obj.TEMBIANT);
               case 'time'
                   value = obj.buffer(1:i,obj.TIME);
               
                   
               case 'current'
                   value = obj.buffer(1:i,obj.CURRENT);
               
               case 'fanIn'
                   value = obj.buffer(1:i,obj.FANIN);
               case 'fanOut'
                   value = obj.buffer(1:i,obj.FANOUT);  
                   
               otherwise
                   error('unknown field "%s"', key);
           end
           
        end
        function data = data(obj, varargin)
            data = obj.buffer(1:obj.index, :);
            data = data(varargin{:}); 
        end
        function environmentData = toEnvironmentData(obj)
            h = {{'TIME', obj.TIME, '[s] time table column number '}, ...
                 {'CURRENT', obj.CURRENT, '[A] peltier current table column number'}, ...
                 {'FANIN', obj.FANIN, '[v] inner fan  table column number '},...
                 {'FANOUT', obj.FANOUT, '[v] outer fan  table column number '},...
                 {'TREGUL', obj.TREGUL, '[C] regul set point  table column number '},...
                 {'TIN', obj.TIN, '[C] inner temp. table column number '},...
                 {'TOUT', obj.TOUT, '[C] outer temp. table column number '},...
                 {'TMIRROR', obj.TMIRROR, '[C] mirror temp. table column number '},...
                 {'TQSM', obj.TQSM, '[C] base qsm temp. table column number '},...
                 {'TEMBIANT', obj.TEMBIANT, '[C] embiant temp. table column number '},...
            };
            environmentData = naomi.data.Environment(obj.data, h);
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
            hold(axesList{2}, 'on');
            plot(axesList{2}, time, obj.get('fanOut'));
            hold(axesList{2}, 'off');
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
               if obj.dynamic
                   
                   old = obj.buffer;
                   new = zeros(obj.index+obj.stepSize, obj.NCOL);
                   new(1:obj.index, :) = old(1:obj.index, :);
                   obj.buffer = new;
                    
                      
               else
                   obj.buffer(1:end-obj.stepSize,:) = obj.buffer(obj.stepSize+1:end,:);
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
            % if e is not connected, e.i `~e.isConnected`, this does
            % nothing and 
            %
            % if environmnet object is note connected do nothing silently
            if ~e.isConnected
                return 
            end
            obj.prepareForNext;
            i = obj.index;
            
            obj.buffer(i, obj.TIME) = now;
            
            obj.buffer(i, obj.TREGUL) = e.tempRegul;
            
            obj.buffer(i, obj.TIN) = e.tempIn;
            obj.buffer(i, obj.TOUT) = e.tempOut;
            obj.buffer(i, obj.TMIRROR) = e.tempMirror;
            obj.buffer(i, obj.TQSM) = e.tempQSM;
            obj.buffer(i, obj.TEMBIANT) = e.tempEmbiant;
            obj.buffer(i, obj.FANIN) = e.fanIn;
            obj.buffer(i, obj.FANOUT) = e.fanOut;
            obj.buffer(i, obj.CURRENT) = e.current;                  
        end
    end
end