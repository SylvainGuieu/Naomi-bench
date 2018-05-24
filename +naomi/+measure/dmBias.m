function [dmBiasVector,dmBiasData] = dmBias(bench)
%DMBIAS measure the dm bias by doing a close loop flat 
%   To do so the current dm bias is first removed, a close-loop flat 
%   is made (naomi.measure.closeFlat) the cmdVector becomes the dmBias
%   The previous bias is then restaured 
    
    savedBiasVector  = bench.dm.biasVector;
    bench.dm.biasVector = 0;
    
    ztcMode = bench.config.biasZtcMode;
    mask = bench.config.ZtCParameters(ztcMode);
    gain = bench.config.biasGain;
    nStep = bench.config.biasNstep;
    % compute the matrix with the full dm 
    [PtCArray, ZtCArray, ZtPArray] = naomi.make.commandMatrix(bench, bench.IFMData, ztcMode);
    
    % configure the pupill mask 
    naomi.config.pupillMask(bench, mask);
    naomi.action.resetDm(bench);
    try
        naomi.action.closeZonal(bench,PtCArray,gain,nStep);
    catch ME
        bench.dm.biasVector = savedBiasVector;
        rethrow(ME);
    end
    
    dmBiasVector = bench.dm.cmdVector; 
    bench.dm.biasVector = savedBiasVector;
    if nargout>1
       K = naomi.KEYS;
       dmBiasData = naomi.data.DmBias(dmBiasVector);
       bench.populateHeader(dmBiasData);
    end
end
