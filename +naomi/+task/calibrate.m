function  calibrate(bench, force)
%CALIB run the full calibration
%  naomi.task.calibrate; % take the default bench 
%  naomi.task.calibrate(bench); % provide the bench object 
%  naomi.task.calibrate(bench, 1); % provide the bench object and remove
%                  the check dialog box asking for confirmation (if any)
%  naomi.task.calibrate([], 1);
%
%  - IFM measurement 
%  - Zernike to Command matrix computation 
%  - Bias measurement 
%  Data and figure are saved in the session directory
%  
global naomiGlobalBench
if nargin<1 || isempty(bench); bench = naomiGlobalBench; end
if nargin<2; force=0; end
naomi.task.IFM(bench, force);
naomi.task.ztcAndDmBias(bench);
end

