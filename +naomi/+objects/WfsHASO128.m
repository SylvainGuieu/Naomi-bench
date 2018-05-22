classdef WfsHASO128 < naomi.objects.Wfs
    properties
        model = 'HASO128';
        nSubAperture = 128;
        % empty the buffer before measuring the phase
        % by this number 
        nGetImageBeforePhase = 3;
        % pause before measuring the phase (after emptying the buffer)
        pause = 0.1;
        % if true the phase is rotated by 90 degree
        rotatePhase = 1;
        % array off liped axis 
        % e.g. : [1 2] or  [1] or [] etc ...
        % !! the flip occure After rotation if any 
        flippedAxes;
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
            for i=1:obj.nGetImageBeforePhase
              obj.haso.GetImage;
            end
            pause(obj.pause);
            phase = obj.haso.GetPhase();
            if obj.rotatePhase
              phase = rot90(phase);
            end
            for iAxes=1:length(obj.flippedAxes)
              phase = double(flip(phase,obj.flippedAxes(iAxes)));
            end
            
        end
        
        function image = getRawImage(obj)
          image = obj.haso.GetImage;
          if obj.rotatePhase
            image = rot90(image);
          end
          for iAxes=1:length(obj.flippedAxes)
            image = double(flip(image,obj.flippedAxes(iAxes)));
          end
        end
        
        function setDit(obj, dit)
          % set the haso dit 
          obj.haso.dit = dit;
        end
        
        function dit = getDit(obj)
          % get the haso dit 
          dit = obj.haso.dit;
        end
        
        function populateHeader(obj,h)
          populateHeader@naomi.objects.Wfs(obj, h);
          % add more stuff ?? 
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
    
    end
    
end