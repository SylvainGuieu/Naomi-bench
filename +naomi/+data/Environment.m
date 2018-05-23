classdef Environment < naomi.data.BaseData
	properties
	

	end	
	methods
        function obj = Environment(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ENVIRONMENT', ''}};
        end
        function c = TIME(obj)
            c = obj.getKey(naomi.KEYS.TIME, 1);
        end
        function c = CURRENT(obj)
            c = obj.getKey(naomi.KEYS.PCURRENT, 2);
        end
        function c = FANIN(obj)
            c = obj.getKey(naomi.KEYS.PFANIN, 3);
        end
        function c = FANOUT(obj)
            c = obj.getKey(naomi.KEYS..PFANOUT, 4);
        end
        function c = TREGUL(obj)
            c = obj.getKey(naomi.KEYS.TEMPREGUL, 5);
        end
        function c = TIN(obj)
            c = obj.getKey(naomi.KEYS.TEMPIN, 6);
        end
        function c = TOUT(obj)
            c = obj.getKey(naomi.KEYS.TEMPOUT, 7);
        end
        function c = TMIRROR(obj)
            c = obj.getKey(naomi.KEYS.TEMPMIRROR, 8);
        end
        function c = TQSM(obj)
            c = obj.getKey(naomi.KEYS.TEMPQSM, 9);
        end
        function c = TEMBIANT(obj)
            c = obj.getKey(naomi.KEYS.TEMPEMBIANT, 10);
        end
				function c = HUMIDITY(obj)
            c = obj.getKey(neomi.KEYS.HUMIDITY, 11);
        end
        
        
        function value = get(obj, key)
           
           switch key
               case 'tempIn'
                   value = obj.data(':',obj.TIN);
               case 'tempOut'
                   value = obj.data(':',obj.TOUT);
               case 'tempRegul'
                   value = obj.data(':',obj.TREGUL);
               case 'tempMirror'
                   value = obj.data(':',obj.TMIRROR);
               case 'tempQSM'
                   value = obj.data(':',obj.TQSM);
               case 'tempEmbiant'
                   value = obj.data(':',obj.TEMBIANT);
               case 'time'
                   value = obj.data(':',obj.TIME);  
               case 'current'
                   value = obj.data(':',obj.CURRENT);
               
               case 'fanIn'
                   value = obj.data(':',obj.FANIN);
               case 'fanOut'
                   value = obj.data(':',obj.FANOUT);  
							case 'humidity'
	                 value = obj.data(':',obj.HUMIDITY);  
                   
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
    end
end