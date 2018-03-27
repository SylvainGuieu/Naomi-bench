classdef AO < naomi.objects.BaseObject
    %%
    % A class AO is composed of a wfs object and a dm object 
    % it contains function that can be computed with both (e.g. pixel
    % scale)
    
    properties
        wfs;
        dm;   
        xScale;
        yScale;
        xCenter;
        yCenter;
        % Interacttion Function for center actuator
        IFC;
    end
    
    methods
        function obj = AO(wfs, dm)
            %UNTITLED15 Construct an instance of this class
            %   Detailed explanation goes here
            obj.wfs = wfs;
            obj.dm = dm;
            
        end
        
       function [xS,yS] = measureScale(obj, config, Npp, Amp)
           % measure the pixel scale 
           % result is returned and stored inside the ao object 
           % and inside the config object
           if nargin<3
               Npp = config.scaleNpp;
           elseif nargin<4
               Amp = config.scaleAMplitude;
           end
            [xS,yS] = naomi.getScale(obj.dm, obj.wfs, Npp, Amp);
            obj.xScale = xS;
            obj.yScale = yS;
            config.xScale = xS;
            config.yScale = yS;
       end
       function IFC = measureIFC(obj, config, bench)
           fprintf('Measure IFC with center actuator %i\n',config.dmCenterAct);
           Npp = config.centerNpp;
           Amp = config.centerAmp;
           % put bias vector to 0.0 and reset the DM
           obj.dm.biasVector = 0.0;
           obj.dm.Reset();
           IFC = naomi.measureIF(obj.dm, obj.wfs, config.dmCenterAct, Npp, Amp);
           config.IFC = naomi.Data(IFC, 'IFC', bench);
       end
       function [xCenter,yCenter] = computeCenter(obj, config)
            % Get IF of center actuator the result is returned and 
            % is populated inside the ao object as well as the config
            % object. 
            % The IFC matrix is also stored 
          if isempty(config.IFC)
              error('IFC must be measured first')
          end
          [xCenter,yCenter] = naomi.computeIFCenter(config.IFC);
          obj.xCenter = xCenter;
          obj.yCenter = yCenter;
          config.xCenter = xCenter;
          config.yCenter = yCenter;
          end
       
       function Dataref = measureReference(obj,config, bench)
           % reset the DM take a reference Phase and save it inside the daily 
           % directory as a fits file and matlab file 
           %
           % Input arguments
           % wfs wave front sensor structure 
           % dm  Deformable Miror structure 
           % config  naomi configuration structure 
           % Np  number of frame averaged 

           
           Np = config.referenceNp;
           
           dm = obj.dm;
           wfs = obj.wfs;
           
           dm.Reset();
           Dataref = wfs.getAvgPhase(Np); 
           config.DM_PHASE_REF = naomi.Data(Dataref, 'PHASE_REF', bench);
           
       end
       function saveIFCenter(obj, config)
           % Typical sizes in pixels
           obj.computeCenter(config);
           
           scale = 0.5 * (obj.xScale + obj.yScale);
           size28 = 28.0/scale;
           size38 = 36.5/scale;
           size45 = 45.0/scale;

           % Write data
           filename = fullfile(config.todayDirectory,'IFC_',name,'.fits');
           naomi.WriteData(filename, IFC, 'IFC', 'STARTUP', obj.wfs, obj.dm);
           naomi.WriteHeaderKey(filename, 'IF_AMP',config.centerAmplitude,'[Cmax] amplitude of push-pull');
           naomi.WriteHeaderKey(filename, 'IF_NPP',config.centerNpp,'number of push-pull');
           naomi.WriteHeaderKey(filename, 'XCENT',obj.xCenter,'center of DM');
           naomi.WriteHeaderKey(filename, 'YCENT',obj.yCenter,'center of DM');
       end
       function populateHeader(obj, h)
           obj.wfs.populateHeader(h);
           
       end
           
    end
end

