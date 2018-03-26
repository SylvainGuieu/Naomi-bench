classdef Autocol < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        client;
        COMPUTER = 2^6;
        EDIT = 2^5;
        MEASURE = 2^4;
        ALIGN = 2^3;
        PRINT = 2^2;
        LAST = 2; 
        NEXT = 1; 
    end
    
    methods (Access = public)
        function obj = Autocol(port)
            fprintf('Init connection to Autocol ELCOMAT 2000\n');
            obj.client = serial(port);
            set(obj.client,'BaudRate',2400);
            set(obj.client,'Parity','none');
            set(obj.client,'StopBits',1);
            set(obj.client,'DataBits',8);
            %set(obj.client,'StartBits',1);
            %set(obj.client,'Terminator','CR');
            
            fprintf('Open connection to Autocol ELCOMAT 2000\n');
            fopen(obj.client);
           
        end
        function data = getAllData(obj)
            raw = fread(obj.client);
            ln = length(raw);
            started = false;
            
            data = [];
            % search for begining
            for s=1:ln
                val = raw(s);
                if val == 2
                    break
                end
            end
            if s>=ln
                data = [];
                return 
            end
            for i=s:8:ln
                if (i+7)<ln
                    data = [data;[raw(i), raw(i+1), raw(i+2), raw(i+3), raw(i+4), raw(i+5), raw(i+6), raw(i+7)]];
                end;
            end
        end
        function data = getLastData(obj)
            raw = fread(obj.client);
            
            l = length(raw);
            s = max(1,l-14);
            for i=1:l
                val = raw(i);
                if val ~= 2; continue; end;
                if raw(i+7) ~= 3
                    data = [];
                else
                    data = [raw(i), raw(i+1), raw(i+2), raw(i+3), raw(i+4), raw(i+5), raw(i+6), raw(i+7)];
                end;
                break;
            end;
        end
        function val = raw2value(obj, data, axis)
            switch axis
                case 'x'
                    i = 4;
                case 'y'
                    i = 7;
                otherwise
                    error('axis must be x or y')
            end
            val = (data(i)*256*256 + data(i-1)*256 + data(i-2))/100.0;
            if val>10000.0; val = val-167772.16; end;
        end
        function [x,y] = getAllXY(obj)
            data = obj.getAllData();
            ln = length(data);
            x = [];
            y = []; 
            for i=1:ln
                d = data(i,:);
                x = [x; obj.raw2value(d,'x')];
                y = [y; obj.raw2value(d,'y')];
            end
        end
        function [x,y] = getXY(obj)
            data = obj.getLastData();
            if isempty(data)
                x = nan;
                y = nan;
            else
                x = obj.raw2value(data, 'x');
                y = obj.raw2value(data, 'y');
            end
        end
        function setCom(obj, com)
            fwrite(obj.client, sprintf("%x\n%x\n%x\n", 2, com, 3));
        end
        function delete(obj)
            fprintf('Close connection to Autocol ELCOMAT 2000\n');
            fclose(obj.client);
        end
        function populateHeader(obj, f)
        end
    end
end
