function [dmBiasVector,dmBiasData,phaseFlatData] = dmBias(bench, varargin)
 % DmBias - measure he best dm bias to flatten the wavefront
 %  The flatest wavefront is obtained by closing a modal loop. 
 %  Note that is a dmBias vector is already configured inside the bench it will 
 %  be discarded during the measurement. 
 %
 %
 % Syntax:  dmBiasVector = dmBias(bench)
 %           [~,dmBiasData, phaseFlatData] = dmBias(bench)
 %          ~ = dmBias(bench, 'nStep', 5, 'gain', 0.8);
 %
 % Inputs
 % ------
 %    bench:  naomi.objects.Bench 
 %    
 %
 % Optional args and Relevant Config Parameters
 % --------------------------------------------
 %    ztcMode /  dmBiasZtcMode: (char) the name of the Ztc mode used to compute the Phase 
 %                    to command Matrix for the modal close loop. This should be
 %                    'DM_PUPILL' (the full DM PUPILL)
 %    gain  / dmBiasGain: (float) The gain used during the close loop 
 %    nStep / dmBiasNstep: (int)  number of iterations to close the loop 
 %
 % Outputs
 % -------
 %    dmBiasVector: actuator command vector obtained for the best flat
 %    dmBias: dmBiasVector encapsuled in a naomi.data.DmBias object 
 %    phaseFlatData : the phase array obtained at the en of the loop encapsuled
 %                     in a naomi.data.PhaseFlat object 
 %
 % Pre Measurement required
 % ------------------------
 %   - IFM should be done in order to compute the Phase to Command matrix
 % 
 % Example 
 % -------
 %    % close the bias on the naomi-pupill 
 %    >>> naomi.measure.dmBias(bench,  'ztcMode', 'NAOMI_PUPILL', 'gain', 10);
 %    
 %   or by creating an ob 
 %     >>> ob = []; 
 %     >>> ob.ifAmplitude = 0.2;
 %     >>> ob.ifMode = 'quick';
 %     >>> ob.dmBiasNstep = 5;
 %     >>> ob.dmBiasGain = 0.1;
 %     >>> [~, IFMCleanData] = naomi.measure.IFM(bench, ob);
 %     >>> naomi.config.IFM(bench, IFMCleanData);
 %     >>> [~, dmBiasData] = naomi.measure.bias(bench, ob);
 %     >>> naomi.saveData(bench, dmBiasData);
 %
 %
 % Note measure.* functions do not save anything or config anything 
 %      use the conresponding config.* function configure the measurement inside
 %      the bench. 
 %     
 % Author: Sylvain Guieu
 % Last revision: 30 May 2018
    
    P = naomi.parseParameters(varargin, {'ztcMode', 'nStep', 'gain', 'dateOb', 'tplName'}, 'measure.dmBias');
    
    % save the biasVector of the DM 
    savedBiasVector  = bench.dm.biasVector;
    % put all bias to zero
    bench.dm.biasVector = 0;
    
    ztcMode = naomi.getParameter(bench, P, 'ztcMode', 'dmBiasZtcMode');
    mask  =  bench.config.ztcParameters(ztcMode);
    
    gain  = naomi.getParameter(bench, P, 'gain', 'dmBiasGain');
    nStep = naomi.getParameter(bench, P, 'nStep', 'dmBiasNstep');
    
    % compute the matrix with the full dm 
    [PtCArray, ZtCArray, ZtPArray] = naomi.make.commandMatrix(bench, bench.IFMData, ztcMode);
    
    % configure the pupill mask 
    naomi.config.pupillMask(bench, mask);
    
    naomi.action.resetDm(bench);
    try
       phaseArray =  naomi.action.closeZonal(bench, PtCArray, gain, nStep);
    catch ME
        bench.dm.biasVector = savedBiasVector;
        naomi.action.resetDm(bench);
        rethrow(ME);
    end
    
    dmBiasVector = bench.dm.cmdVector; 
    % put back the saved bias (user mus use naomi.config.dmBias to use it)
    bench.dm.biasVector = savedBiasVector;
    
    if nargout>1
        K = naomi.KEYS;
        
        dateOb = naomi.getParameter([], P,  'dateOb',  [], now);
        tplName = naomi.getParameter([], P, 'tplName', [], K.TPLNAMEd);
        h = {{K.DATEOB, dateOb, K.DATEOBc}, ...
             {K.TPLNAME, tplName, K.TPLNAMEc}};
        dmBiasData = naomi.data.DmBias(dmBiasVector, h);
        bench.populateHeader(dmBiasData);
       
       if nargout>2
           
        
        
        h = {{K.DATEOB, dateOb, K.DATEOBc}, ...
             {K.TPLNAME, tplName, K.TPLNAMEc}, ...
             {K.LOOPMODE, K.ZONAL,  K.LOOPMODEc}, ...
             {K.LOOP,      K.CLOSED,  K.LOOPc}, ...
             {K.NPHASE,    nStep,    K.NPHASEc  }, ...
             {K.LOOPGAIN,  gain,     K.LOOPGAINc}, ...
             {K.LOOPSTEP,  nStep,    K.LOOPSTEPc}, ...
             {K.DPRVER, K.ZONAL, K.DPRVERc}};
        
        phaseFlatData  = naomi.data.PhaseFlat(phaseArray, h);
      bench.populateHeader(phaseFlatData.header);
   end
  end 
end

