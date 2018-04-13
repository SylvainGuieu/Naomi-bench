classdef WfsPhaseCam4020 < naomi.objects.Wfs
    properties
        model = 'PhaseCam4020';
        nSubAperture = 992/4;
        pause = 0.01;
        tcp;
    end
    methods
        function obj = connect(host,port)
               fprintf('Instantiate PhaseCam4020\n');
               obj.host = host;
               obj.port = port;
        end
        
        function phase = getRawPhase(obj)
            % Clean buffer and request phase screen
            while obj.tcp.BytesAvailable
               warning('TCP connection is not clean!');
               obj.tcp.read(obj.tcp.BytesAvailable);
            end
            obj.tcp.write(uint8('P'));
            % Get phase screen
            phase = obj.tcp.read(obj.nSubAperture.^2,'single');
            if obj.tcp.BytesAvailable ~= 0;
                warning('TCP connection is not clean!');
            end;
            % Rotate, deal with NaN
            phase = -rot90(reshape(phase,obj.nSubAperture,obj.nSubAperture));
            phase(phase==99) = NaN;
            % From meca-wave to [um]-optical
            phase = double(2.0 * phase * 0.6328);
        end
         
         function Off(obj)
             if ~isempty(obj.tcp)
                    fprintf('Close connection\n');
                    obj.tcp.write(uint8('C'));
                    obj.tcp = [];
             else
                    fprintf('Already dis-connected\n');
             end
         end
         function Online(obj)

            % Connect PhaseCam
            if isempty(obj.tcp)
                obj.tcp = tcpclient(obj.host, obj.port);
                msg = char(obj.tcp.read(2));
                if ~strcmp(msg,'OK')
                    error('Cannot connect to PhaseCam serveur');
                else
                    fprintf('Successfully connected to PhaseCam\n');
                end    
            else
                fprintf('Already connected\n');
            end
            Online@naomi.objects.Wfs(obj);
         end
         
         function checkFlux(obj)
             fprintf('WARNING: Cannot check flux of PhaseCam.\n');
         end
         
         function populateHeader(obj, f)
                % populate fits header
                populate@naomi.Wfs(obj);
                
          end
    end
    
end