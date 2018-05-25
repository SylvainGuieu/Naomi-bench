function dmBias(bench)
%MEASUREDMBIAS measure a bias using a loop on a flat wavefront
%   The bias is then saved and configured in the bench
%   The relevant parameter in the config file are
% - biasGain  : loop gain 
% - biasNstep : number of step in the loop
% - biasZtc   : the ztc mode name normaly 'dm-pup' to compute the bias on 
%               all the pupill
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end
    [~, dmBiasData] = naomi.measure.dmBias(bench);
    naomi.config.bias(bench, dmBiasData);
    if ~isempty(bench.IFMData) % should be otherwise measure.dmBias would fail
        % put the sqme DATEOB 
        dmBiasData.setKey(naomi.KEYS.DATEOB, bench.IFMData.getKey(naomi.KEYS.DATEOB, now), naomi.KEYS.DATEOBc);
    end
    naomi.saveData(dmBiasData, bench);
    naomi.plot.figure('DM Bias');dmBiasData.plotQc;
    naomi.saveFigure(dmBiasData, 'QC', bench);
end

