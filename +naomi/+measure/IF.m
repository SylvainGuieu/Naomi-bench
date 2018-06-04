function [IFArray,IFData] = IF(bench,  act, varargin)
%   IF  measure the Influence Function of one actuator 
% 
%   IFArray = measure.IF(bench act, nPushPull, amplitude)
%   [IFArray,IFData] = measure.IF(bench act, nPushPull, amplitude)
%   The requested actuator is push-pulled and the difference
%   is returned as its influence function.
% 
%   
%   bench: naomi bench structure including wfs and dm object
%   act: the requested actuator
%   nPushPull: number of push-pull default in bench.config.ifnPushPull
%   amplitude: amplitude of the push-pull default in bench.config.ifamplitude 
% 
%   IF is a data.IF   the influence function of this actuator
	config = bench.config;
    P = naomi.parseParameters(varargin, {'nPushPull', 'amplitude', 'dateOb', 'tplName'}, 'measure.IF');
    nPushPull = naomi.getParameter(bench, P, 'nPushPull', 'ifNpushPull');
	amplitude = naomi.getParameter(bench, P, 'amplitude', 'ifAmplitude');
    
	
    %naomi.action.resetDm(bench);
    %naomi.action.resetWfs(bench);
    
    nSubAperture = bench.nSubAperture;
    tppush = zeros(nSubAperture,nSubAperture);
    tppull = zeros(nSubAperture,nSubAperture);
    
    % Loop on N push-pull
    ref = bench.dm.cmdVector(act);
    if nPushPull
        for pp=1:nPushPull
            naomi.action.cmdZonal(bench, act, ref + amplitude);
            tppush = tppush + naomi.measure.phase(bench,1);    

            naomi.action.cmdZonal(bench, act, ref - amplitude);      
            tppull = tppull + naomi.measure.phase(bench,1);
        end

        naomi.action.cmdZonal(bench, act, ref);
        IFArray = (tppush - tppull) / (2*amplitude*nPushPull);
    else
        naomi.action.cmdZonal(bench, act, ref + amplitude);
        IFArray = naomi.measure.phase(bench,1);
        %naomi.action.cmdZonal(bench, act, ref);
    end
   	 
    if nargout>1
        K = naomi.KEYS;
        tplName = naomi.getParameter([], P, 'tplName', [], K.TPLNAMEd);
        dateOb  = naomi.getParameter([], P, 'dateOb',  [], now);
        
        h = {{K.MJDOBS,config.mjd, K.MJDOBSc},...
             {K.DATEOB, dateOb, K.DATEOBc},...
             {K.TPLNAME, tplName, K.TPLNAMEc},...
             {K.ACTNUM,act,  K.ACTNUMc      },...
             {K.IFAMP ,amplitude, K.IFAMPc},...
             {K.IFNPP,nPushPull,  K.IFNPPc}};
        
        IFData = naomi.data.IF(IFArray, h);
		bench.populateHeader(IFData.header); 
    end
end

