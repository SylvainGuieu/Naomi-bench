function [xCenter,yCenter,IFC] = IFC(bench, Npp, Amp)
%   IFC  measure the Influence Function of the central actuator 
% 
%   IFC = measure.IFC(bench, act, Npp, Amp)
%
%   The requested actuator is push-pulled and the difference
%   is returned as its influence function.
% 
%   
%   
%   bench: naomi bench structure including wfs and dm object  
%   Npp: number of push-pull default in bench.config.ifNpp
%   Amp: amplitude of the push-pull default in bench.config.ifAmplitude 
%   
%   xCenter  computed x/y center in pixel 
%   yCenter
%   IF is a data.IF   the influence function of the central actuator
	config = bench.config;
	if nargin<2; Npp = config.ifNpp; end
	if nargin<3; Amp = config.ifAMplitude; end

	IFC = naomi.measure.IF(bench, bench.config.dmCentralActuator);
	[xCenter,yCenter] = naomi.compute.IFCenter(IFC.data);
	if config.autoConfig;
		bench.xCenter = xCenter;
		bench.yCenter = yCenter;
		bench.IFC = IFC;
	end

end
