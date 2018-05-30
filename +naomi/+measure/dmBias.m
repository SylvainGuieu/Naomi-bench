function [dmBiasVector,dmBiasData,phaseFlatData] = dmBias(bench)
 % DmBias - measure he best dm bias to flatten the wavefront
 %  The flatest wavefront is obtained by closing a modal loop. 
 %  Note that is a dmBias vector is already configured inside the bench it will 
 %  be discarded during the measurement. 
 %
 %
 % Syntax:  dmBiasVector = dmBias(bench)
 %           [~,dmBiasData, phaseFlatData] = dmBias(bench)
 %
 % Inputs
 % ------
 %    bench:  naomi.objects.Bench 
 %    
 %    
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
 %
 % Example 
 % -------
 %    Line 1 of example
 %    Line 2 of example
 %    Line 3 of example
 %
 % 
 % Note measure.* function does not save anything or config anything 
 %      use the conresponding config.* function configure the measurement inside
 %      the bench. 
 %     
 % Author: Sylvain Guieu
 % Last revision: 30 May 2018
    
    savedBiasVector  = bench.dm.biasVector;
    bench.dm.biasVector = 0;
    
    ztcMode = bench.config.dmBiasZtcMode;
    mask  = bench.config.ztcParameters(ztcMode);
    gain  = bench.config.dmBiasGain;
    nStep = bench.config.dmBiasNstep;
    % compute the matrix with the full dm 
    [PtCArray, ZtCArray, ZtPArray] = naomi.make.commandMatrix(bench, bench.IFMData, ztcMode);
    
    % configure the pupill mask 
    naomi.config.pupillMask(bench, mask);
    naomi.action.resetDm(bench);
    try
       phaseArray =  naomi.action.closeZonal(bench, PtCArray, gain, nStep);
    catch ME
        bench.dm.biasVector = savedBiasVector;
        rethrow(ME);
    end
    
    dmBiasVector = bench.dm.cmdVector; 
    bench.dm.biasVector = savedBiasVector;
    if nargout>1
        
       dmBiasData = naomi.data.DmBias(dmBiasVector);
       bench.populateHeader(dmBiasData);
       if nargout>2
           
        K = naomi.KEYS;
        
        h = {{K.LOOPMODE, K.ZONAL,  K.LOOPMODEc}, ...
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

