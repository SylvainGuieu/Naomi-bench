function  turnRawAlignmentOff(bench)
%ALIGN Summary of this function goes here
%   Detailed explanation goes here
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end
    bench.wfs.haso.StopAlignmentRtd;
end