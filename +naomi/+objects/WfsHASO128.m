classdef WfsHASO128 < naomi.objects.Wfs
    properties
        model = 'HASO128';
        nSubAperture = 128;
        pause = 0.5;
        haso;
    end
    methods
        
        function connect(obj,host,port)
               fprintf('Instantiate HASO128\n');
               obj.haso = acehwfs4HSH();
               obj.haso.sConfigFile = host;
               obj.src = port;             
        end
        function phase = getRawPhase(obj)
            % Read the phase screen from HASO
            obj.haso.SetMask(ones(obj.nSubAperture,obj.nSubAperture));
            pause(obj.pause);
            phase = obj.haso.GetPhase();
            phase = double(flip(phase,1));
        end
        
        
        function Off(obj)
            % Disable HASO
            obj.haso.Off;
        end
        
        function Online(obj)
            % Online HASO
            obj.haso.Online;
            obj.haso.sReconstructor.type = 'zonal';
            obj.haso.sReconstructor.validModes(:) = 1;
            Online@naomi.objects.Wfs(obj);
        end
        
        function Reset(obj)
           obj.haso.Reset;
        end
        
        function checkFlux(obj)
            
            % Restart camera RTD to have it on top
            obj.haso.StopRtd();
            obj.haso.StartRtd();
            pause(1);

            % Measure flux
            flux = max(max(obj.haso.GetImage));
            fprintf('Flux is at %.3f for DIT = %.0fus\n',flux,obj.haso.dit);

            % If out of limit, start a window
            if (flux < Fmin || flux > Fmax)
                wbar = waitbar(flux,sprintf('Flux level = %.3f',flux));
                while (ishandle(wbar))
                   flux = max(max(obj.haso.GetImage));
                   waitbar(flux,wbar,...
                   {sprintf('Flux level %.2f  -  Adjust to %.2f - %.2f',flux,Fmin,Fmax)
                   'Close this box when ready'});
                   pause(0.2);
                end;
                fprintf('done.\n');
            else
                fprintf('Flux level is OK.\n');
            end
                
            obj.haso.StopRtd();
        end
        function populateHeader(obj, f)
                % populate fits header
                populateHeader@naomi.Wfs(obj, f);
          end
    end
    
end