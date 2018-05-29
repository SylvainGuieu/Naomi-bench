function  openCalibrationPanel(bench)
% open the calibration pannel
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end

if isempty(naomi.findGui(naomi.KEYS.G_CALIB))
    calibGui(bench);
    movegui(naomi.findGui(naomi.KEYS.G_CALIB), 'north');
end
end