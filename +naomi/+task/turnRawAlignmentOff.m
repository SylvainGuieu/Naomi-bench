function  turnRawAlignmentOff(bench)
%ALIGN Summary of this function goes here
%   Detailed explanation goes here
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end
    if bench.has('wfs')
        bench.wfs.haso.StopAlignmentRtd;
    end
end