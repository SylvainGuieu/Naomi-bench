classdef Reference < naomi.objects.BaseObject
    %%
    % A class Reference is composed of a wfs and supose that there is 
    % a dummy mirror instead of a DM
    %
    properties
        wfs;  
        xCenter;
        yCenter;
    end
    methods
        function obj = Reference(wfs)
            obj.wfs = wfs;
        end
        function dm(obj)
            error("This is a dummy mirror, there is no DM")
        end
        function filename = saveReference(obj,config, Np)
           
           if nargin<3
               Np = config.referenceNp;
           end
           Dataref = obj.wfs.getAvgPhase(Np);
           
           
           % Write data
           name = datestr(now,'yyyy-mm-ddTHH-MM-SS');
           filename = fullfile(config.todayDirectory,'REF_DUMMY_',name,'.fits');
           naomi.writeData(filename, Dataref, 'PHASE_REF', 'STARTUP', obj.wfs);

           % Write data MAT
           filename = fullfile(config.todayDirectory,'REF_DUMMY_',name,'.mat');
           naomi.writeDataMatlab(filename, obj.wfs);
           save(filename,'Dataref','-append');
        end
        function populateHeader(obj, h)
            obj.wfs.populateHeader(h); 
        end
    end
end