function IFData = IF(bench,  act, nPushPull, amplitude)
%   IF  measure the Influence Function of one actuator 
% 
%   IF = measure.IF(bench act, nPushPull, amplitude)
%
%   The requested actuator is push-pulled and the difference
%   is returned as its influence function.
% 
%   
%   
%   bench: naomi bench structure including wfs and dm object
%   act: the requested actuator
%   nPushPull: number of push-pull default in bench.config.ifnPushPull
%   amplitude: amplitude of the push-pull default in bench.config.ifamplitude 
% 
%   IF is a data.IF   the influence function of this actuator
	config = bench.config;
	if nargin<3; nPushPull = config.ifNpushPull; end
	if nargin<4; amplitude = config.ifAmplitude; end

	dm = bench.dm;
	wfs = bench.wfs;

    nSubAperture = bench.nSubAperture;
    tppush = ones(nSubAperture,nSubAperture) * 0.0;
    tppull = ones(nSubAperture,nSubAperture) * 0.0;
    
    % Loop on N push-pull
    ref = dm.cmdVector(act);
    for pp=1:nPushPull
        naomi.action.cmdZonal(bench, act, ref + amp);
        naomi.measure.phase(bench,1); % get phase first without storing it  

        tppush = tppush + naomi.measure.phase(bench,1);        
        naomi.action.cmdZonal(bench, act, ref - amp);
        naomi.measure.phase(bench,1); % get phase first 
        tppull = tppull + naomi.measure.phase(bench,1);
    end
    
    naomi.action.cmdZonal(bench, act, ref);
    IFArray = (tppush - tppull) / (2*amplitude*nPushPull);
   	 
    
    K = naomi.KEYS;
    h = {{K.MJDOBS,config.mjd, K.MJDOBSc},...
         {K.ACTNUM,act,  K.ACTNUMc      },...
	     {K.IFAMP ,amplitude, K.IFAMPc},...
         {K.IFNPP,nPushPull,  K.IFNPPc}};

    IFData = naomi.data.IF(IFArray, h, {bench});    
end

