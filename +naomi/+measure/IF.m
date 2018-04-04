function IF = IF(bench,  act, Npp, Amp)
%   IF  measure the Influence Function of one actuator 
% 
%   IF = measure.IF(bench act, Npp, Amp)
%
%   The requested actuator is push-pulled and the difference
%   is returned as its influence function.
% 
%   
%   
%   bench: naomi bench structure including wfs and dm object
%   act: the requested actuator
%   Npp: number of push-pull default in bench.config.ifNpp
%   Amp: amplitude of the push-pull default in bench.config.ifAmplitude 
% 
%   IF is a data.IF   the influence function of this actuator
	config = bench.config;
	if nargin<3; Npp = config.ifNpp; end
	if nargin<4; Amp = config.ifAMplitude; end

	dm = bench.dm;
	wfs = bench.wfs;

    Nsub = wfs.Nsub;
    tppush = ones(Nsub,Nsub) * 0.0;
    tppull = ones(Nsub,Nsub) * 0.0;
    
    % Loop on N push-pull
    ref = dm.cmdVector(act);
    for pp=1:Npp
        dm.cmdVector(act) = ref + Amp;
        naomi.measure.phase(bench,1); % get phase first without storing it  
        tppush = tppush + naomi.measure.phase(bench,1).data;
        dm.cmdVector(act) = ref - Amp;
        naomi.measure.phase(bench,1); % get phase first 
        tppull = tppull + naomi.measure.phase(bench,1).data;
    end
    
    dm.cmdVector(act) = ref;  
    IF = (tppush - tppull) / (2*Amp*Npp);
   	 
    % Compute value of maximum
    Max = max(abs(IF(~isnan(IF))));
    
    
    h = {{'MJD-OBS',config.mjd, 'modified julian when script started'},
         {'ACTNUM',act, 'IF actuator number'}, 
	     {'IF_AMP',Amp,'[Cmax] amplitude of push-pull'},
         {'IF_NPP',Npp,'number of push-pull'}};

    IF = naomi.data.IF(IF, h, {bench});
    if bench.config.plotVerbose 
    	naomi.getFigure('Influence Function');  
    	IF.plot();    	
    end
end

