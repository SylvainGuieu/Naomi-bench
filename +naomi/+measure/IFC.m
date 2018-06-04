function [IFCArray,IFCData] = IFC(bench, varargin)
%   IFC  measure the Influence Function of the central actuator 
% 
%   IFC = measure.IFC(bench, act, nPushPull, amplitude)
%
%   The requested actuator is push-pulled and the difference
%   is returned as its influence function.
% 
%   
%   
%   bench: naomi bench structure including wfs and dm object  
%   nPushPull: number of push-pull default in bench.config.ifnPushPull
%   amplitude: amplitude of the push-pull default in bench.config.ifamplitudelitude 
%   
%   IFCData is a data.IF the influence function of the central actuator
%   xCenter  computed x/y center in pixel 
%   yCenter
%   
	config = bench.config;
	
    
    if nargout<2
        IFCArray= naomi.measure.IF(bench, bench.config.dmCentralActuator, varargin{:});
    else
        [IFCArray,IFCData] = naomi.measure.IF(bench, bench.config.dmCentralActuator, varargin{:});
    end
end
