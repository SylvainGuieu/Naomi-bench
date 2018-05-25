function  validate(bench, force)
%CALIB run the full test for current calibration validation 
%  naomi.task.validate; % take the default bench 
%  naomi.task.validate(bench); % provide the bench object 
%  naomi.task.validate(bench, 1); % provide the bench object and remove
%                  the check dialog box asking for confirmation (if any)
%  naomi.task.validate([], 1);
%
%  - ZtP measurement 
%  - stroke for tip and tilt 
%  - flat  
%  Data and figure are saved in the session directory
%  
global naomiGlobalBench
if nargin<1 || isempty(bench); bench = naomiGlobalBench; end
if nargin<2; force=0; end
naomi.task.ZtP(bench);
naomi.task.strokes(bench);
end
