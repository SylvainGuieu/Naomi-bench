classdef IF < naomi.data.Phase
	properties
	

	end	
	methods
        function obj = Phase(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IF', ''}}
        end

    function plot(obj)
            IF = obj.data;
            clf; imagesc(IF);

            ttl = 'Influence Function';
            Max = max(abs(IF(~isnan(IF))));
            title({ttl,...
            	   sprintf('IF %i   max = %.2fum',obj.getKey('ACTNUM', -99),Max)}

            	);            
            xlabel('Y   =>+');
            ylabel('+<=   X');
            colorbar;    
     end
 	end
end