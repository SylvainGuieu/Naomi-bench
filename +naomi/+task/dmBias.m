function dmBias(bench)
  %DMBIAS - measure and save the best dm bias to flatten the wavefront
  %  The flatest wavefront is obtained by closing a modal loop. 
  %  Note that is a dmBias vector is already configured inside the bench it will 
  %  be discarded during the measurement. 
  %    
  %
  % Syntax:  naomi.task.dmBias;   % default bench taken
  %          naomi.task.dmBias(bench)
  %
  % Relevant Config Parameters
  % --------------------------
  %    dmBiasZtcMode: (char) the name of the Ztc mode used to compute the Phase 
  %                    to command Matrix for the modal close loop. This should be
  %                    'DM_PUPILL' (the full DM PUPILL)
  %    dmBiasGain: (float) The gain used during the close loop 
  %    dmBiasNstep: (int)  number of iterations to close the loop
  %
  % Pre Measurement required
  % ------------------------
  %    IFM:  the IFM should have been measured or loaded (bench.IFMData)
  % 
  % Device Required
  % ---------------
  %   dm & wfs     
  %
  % Product saved  
  % -------------
  % Saved inside bench.config.sessionDirectory 
  %   - fits file  of DPR_TYPE  'DM_BIAS'
  %               the DM actuator command vector used to obtained the flat DM
  %   - fits file of  DPR_TYPE  'PHASE_FLAT'
  %               the phase screen image of the obtained best flat
  %                  
  % Product plotted
  % ---------------
  % 
  %
  % Author: Sylvain Guieu
  % May 2018; Last revision: 30-May-2018  
  
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end
    [~, dmBiasData, flatData] = naomi.measure.dmBias(bench);
    naomi.config.dmBias(bench, dmBiasData);
    if ~isempty(bench.IFMData) % should be otherwise measure.dmBias would fail
        % put the sqme DATEOB 
        dmBiasData.setKey(naomi.KEYS.DATEOB, bench.IFMData.getKey(naomi.KEYS.DATEOB, now), naomi.KEYS.DATEOBc);
    end
    naomi.saveData(bench, dmBiasData);
    naomi.saveData(bench, flatData);
    naomi.plot.figure('DM Bias');dmBiasData.plotQc;
    naomi.saveFigure(bench, dmBiasData, 'QC');
    naomi.plot.figure('Flat Zonal');flatData.plot;
end

