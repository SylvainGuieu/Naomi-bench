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
        % bench phase reference 
        ref;
                
        filterTilt;
        % light source
        src;
        % connect to hardware
        host;
        port;
        
        % Property defined by the subclass 
        % nSubAperture, model, pause, host, port
    end
    
    methods
       function obj = Wfs()
           %obj.connect(host, port);
           obj.mask = ones(obj.nSubAperture,obj.nSubAperture);
           obj.ref   = zeros(obj.nSubAperture,obj.nSubAperture);           
           obj.filterTilt = 0;
       end
       function delete(obj)
            obj.Off;
       end  
                                        
        function Online(obj)
           
        end
        
        function Reset(obj)
           
        end
        
        function populateHeader(obj,h)
          K = naomi.KEYS;
          naomi.addToHeader(h, K.WFSNSUB, obj.nSubAperture, K.WFSNSUBc);
          naomi.addToHeader(h, K.WFSNAME, obj.model, K.WFSNAMEc);
        end
    end    
end