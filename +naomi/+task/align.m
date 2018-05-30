function  align(bench)
%ALIGN Summary of this function goes here
%   Detailed explanation goes here
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end
if ~bench.has('wfs')
    msgbox({'The Wave front is offline', 'Start it first'});
    return            
else
if isempty(naomi.findGui('Alignment'))
    naomi.gui.alignmentGui(bench, {@naomi.task.afterAligment});
end
end

