function  openCalibrationPanel(bench)
% open the calibration pannel
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end

if isempty(naomi.findGui('Calibration'))
    calibGui(bench);
end
end