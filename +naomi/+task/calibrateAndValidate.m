function  calibrateAndValidate(bench, force)
%CALIB run the full calibration then its validation 
% see naomi.task.calibrate
%   and naomi.task.validate 
global naomiGlobalBench
if nargin<1 || isempty(bench); bench = naomiGlobalBench; end
if nargin<2; force=0; end
naomi.task.calibrate(bench, force);
naomi.task.validate(bench, force);
end

