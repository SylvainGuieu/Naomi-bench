classdef EnvironmentBuffer < naomi.objects.Buffer
    properties 
        
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
        HUMIDITY = 11;
        
        environment; 
        timer; 
    end
    methods 
        function obj = EnvironmentBuffer(bufferSize, stepSize, dynamic)
            obj = obj@naomi.objects.Buffer(11, bufferSize, stepSize, dynamic);
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
              case 'humidity'
                   value = obj.buffer(1:i,obj.HUMIDITY);  
                   
               otherwise
                   error('unknown field "%s"', key);
           end
           
        end
        
        function environmentData = toEnvironmentData(obj)
            K = naomi.KEYS; 
            h = {{K.TIME,        obj.TIME, 'time table column number '}, ...
                 {K.PCURRENT,    obj.CURRENT, 'peltier current table column number'}, ...
                 {K.PFANIN,      obj.FANIN, 'inner fan  table column number '},...
                 {K.PFANOUT,     obj.FANOUT, 'outer fan  table column number '},...
                 {K.TEMPREGUL,   obj.TREGUL, 'regul set point  table column number '},...
                 {K.TEMPIN,      obj.TIN, 'inner temp. table column number '},...
                 {K.TEMPOUT,     obj.TOUT, 'outer temp. table column number '},...
                 {K.TEMPMIRROR,  obj.TMIRROR, 'mirror temp. table column number '},...
                 {K.TEMPQSM,     obj.TQSM, 'base qsm temp. table column number '},...
                 {K.TEMPEMBIANT, obj.TEMBIANT, 'embiant temp. table column number '},...
                 {K.HUMIDITY,    obj.HUMIDITY, 'humidity table column number '},...
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
            
        
        function i = update(obj, e)
            % b.update(e)
            %
            % update the buffer with an naomi.objects.Environment object
            % `e`
            % if e is not connected, e.i `~e.isConnected`, this does
            % nothing and 
            %
            % if environment object is note connected do nothing silently
            
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
            obj.buffer(i, obj.HUMIDITY) = e.humidity;    
            
            obj.updateCounter = obj.updateCounter + 1;
        end
        function updateForTimer(obj, varargin)
            
            if isempty(obj.environment)
                error('cannot update buffer missing environment object');
            end
            obj.update(obj.environment);
        end
        function stopTimer(obj)
            if isempty(obj.timer); return ; end
            if isvalid(obj.timer)
                if strcmp(get(obj.timer, 'Running'), 'on')
                    stop(obj.timer);
                end
            end
            delete(obj.timer);
            obj.timer = []; 
        end
        function startTimer(obj, environment, dTime)
            if nargin<3; dTime=5; end
            
            obj.stopTimer; 
            obj.environment = environment; 
            obj.timer = timer('Period',dTime,...
                'ExecutionMode', 'fixedSpacing', ...
                'TasksToExecute', Inf);
            obj.timer.TimerFcn = @obj.updateForTimer;
            start(obj.timer);
            
        end
        function delete(obj)
            obj.stopTimer;
        end
    end
end