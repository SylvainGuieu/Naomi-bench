classdef Wfs < naomi.objects.BaseObject
    % NaomiWfs contains the WFS of the bench
    %
    %  This class implement some basic functions
    %  such as GetPhase, SetMask, Reset... which
    %  are properly propagated either to the
    %  HASO128 in the IPAG bench to the
    %  PhaseCam serveur at ESO
    
    
    properties
        % properties of phase output
        mask;
        ref;
        
        
        filterTilt;
        % light source
        src;
        % connect to hardware
        host;
        port;
        
        % Property defined by the subclass 
        % Nsub, model, pause, host, port
    end
    
    methods
       function obj = Wfs()
           %obj.connect(host, port);
           obj.mask = ones(obj.Nsub,obj.Nsub);
           obj.ref = zeros(obj.Nsub,obj.Nsub);
           obj.filterTilt = 0;
       end
       function delete(obj)
            obj.Off;
       end  
       
       function loadReference(obj, filename, removeTipTilt)
           % Load a phase screen reference in the wfs
           fprintf('Load REF_DUMMY reference:\n');
           fprintf('%s\n',strrep(char(filename(1)),'\','\\'));
           obj.ref = fitsread(char(answer(1)));
           % Read a phase make sure it is all working
           obj.GetPhase();
           
           if removeTipTilt
               fprintf('Take mean Tip/Tilt in reference\n');
               [Y,X] = meshgrid(1:obj.Nsub,1:obj.Nsub);
               obj.filterTilt = 0;
               phi = obj.GetPhase();
               xdelta = diff(phi);
               ydelta = diff(phi');
               obj.ref = obj.ref + (X-obj.Nsub/2) * median(xdelta(~isnan(xdelta)));
               obj.ref = obj.ref + (Y-obj.Nsub/2) * median(ydelta(~isnan(ydelta)));
           end
       end
       
       function resetReference(obj)
           obj.ref = zeros(obj.Nsub,obj.Nsub);
       end
       
         
      
       function phase = getPhase(obj)
            % Read the phase screen from the WFS
            % Apply the mask (set NaN where mask is not 1)
            % Correct its orientation (hardcoded)
            % Remove reference phase
            % Filter tip/filt if required
            % Filter piston
            % Plot phase in figure 'Last Phase'
            
            phase = obj.getRawPhase();
            
            % Apply mask
            phase(obj.mask~=1) = NaN;
            
           % Check valid
           if obj.checkPhase(phase)
                   warning('Invalid sup-appertures inside the mask !!');
           end
                
            % Remove mean and reference
            phase = phase - mean(phase(~isnan(phase)));
            phase = phase - obj.ref;
            
            % Check filtering of tip/tilt
            phase = phase - mean(phase(~isnan(phase)));
            if (obj.filterTilt)
                [Y,X] = meshgrid(1:obj.Nsub,1:obj.Nsub);
                xdelta = diff(phase);
                phase = phase - (X-obj.Nsub/2) * median(xdelta(~isnan(xdelta)));
                ydelta = diff(phase');
                phase = phase - (Y-obj.Nsub/2) * median(ydelta(~isnan(ydelta)));
            end
            
            % Remove mean
            phase = phase - mean(phase(~isnan(phase)));
        end
        
        function phase = plotPhase(obj)
            % Plot
            phase = obj.getPhase();
            naomi.GetFigure('Last Phase');
            clf; imagesc(phase);
            if max(abs(obj.ref(:))) == 0; tit = 'Last received phase screen';
            else tit = 'Last received phase screen - reference'; end;
            title({tit,...
                   sprintf('rms=%.3fum ptv=%.3fum',...
                   naomi.nanstd(phase(:)),...
                   max(phase(:)) - min(phase(:)))});
            xlabel('Y   =>+');
            ylabel('+<=   X');
            colorbar;    
        end
        function phase = getAvgPhase(obj, Np)
            %    Phase = wfs.GetAvgPhase(Np)
            %
            %    Compute the average of Np measurements of the WFS
            %    The phase is returned in XY convention of DM
            %
            %    Np: number of measurements
            %
            %    Phase(Nsub,Nsub): output phase screen, xy

                Nsub  = obj.Nsub;
                phase = ones(Nsub,Nsub) * 0.0;
                % fprintf('Get Phase  (Np=%i)\n',Np);
                for pp=1:Np
                    phase = phase + obj.getPhase() / Np;
                end
        end
        
        function setMask(obj,diam,x0,y0,obs)
            % Set the mask of the phase returned by the WFS
            % Full frame:     wfs.setMask(1)
            % 2d mask:        wfs.setMask(myMask)
            % circular mask:  wfs.setMask(diam,x0,y0)
            % circular mask:  wfs.setMask(diam,x0,y0,obs)
            
            if nargin == 2 && isscalar(diam) && diam == 1
                % Mask is 1 (remove mask)
                 obj.mask(:,:) = diam;
            elseif nargin == 2
                % Mask is a 2D object
                [nx,ny] = size(diam);
                if nx ~= obj.Nsub || ny ~= obj.Nsub
                    error('Wrong mask size');
                end
                obj.mask(:,:) = diam(:,:);
            elseif nargin > 3 && isscalar(diam) && isscalar(x0) && isscalar(y0)
                % Mask is defined by diameter and position
                if nargin == 4; obs = 0; end;
                [Y,X] = meshgrid(1:obj.Nsub,1:obj.Nsub);
                Z = (X-x0).^2 + (Y-y0).^2 < (diam*diam/4);
                Z = Z .* ((X-x0).^2 + (Y-y0).^2 >= (diam*diam*obs*obs/4));
                obj.mask = ones(obj.Nsub,obj.Nsub);
                obj.mask(~Z) = NaN;
            else
                error('Wrong inputs');
            end;
        end
               
        
        function Online(obj)
           obj.filterTilt = 0;
        end
        
        function Reset(obj)
           
        end  
        function populateHeader(obj, h)
            if max(abs(obj.ref(:))) == 0;
              naomi.addToHeader(f, 'PHASEREF', 'NO', 'YES/NO subtracted reference');
            else
              naomi.addToHeader(f, 'PHASEREF', 'YES', 'YES/NO subtracted reference');
            end
            if obj.filterTilt; FT = 'YES'; else FT= 'NO'; end
            naomi.addToHeader(f, 'TTFILT', FT, 'YES/NO is TipTilt filtered');
            

            naomi.addToHeader(f, 'WFSMODEL', obj.model, 'Wave front sensor model');
            naomi.addToHeader(f, 'WFSNSUB',  obj.Nsub, 'Wave front number of sub apperture');
        end;
    end
    
end