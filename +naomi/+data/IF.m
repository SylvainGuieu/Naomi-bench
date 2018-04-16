classdef IF < naomi.data.Phase
	properties
	

	end	
	methods
        function obj = IF(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IF', ''}};
        end

    function plot(obj, axes)
        if nargin<2; axes = gca; end;
        
            IF = obj.data;
            cla(axes); imagesc(axes, IF);

            ttl = 'Influence Function';
            Max = max(abs(IF(~isnan(IF))));
            title(axes, {ttl,...
            	   sprintf('IF %i   max = %.2fum',obj.getKey('ACTNUM', -99),Max)}

            	);            
            xlabel(axes, 'Y   =>+');
            ylabel(axes, '+<=   X');
            colorbar(axes);
     end
 	end
end