function ZtP(bench)
%ZTP measure the ZtP (zernike to Phase) data in order to check the Z2T
%   Detailed explanation goes here
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end
if isempty(bench.IFMData)
   msgbox({'cannot do', 'Missing a (ZtC) Zernike to Command'});
  return; 
end
ZtPData = naomi.measure.ZtP(bench);
naomi.task.afterZtP(bench, ZtPData);
end

