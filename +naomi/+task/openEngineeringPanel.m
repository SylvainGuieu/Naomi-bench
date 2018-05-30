function  openEngineeringPanel(bench)
%ALIGN Summary of this function goes here
%   Detailed explanation goes here
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end

if isempty(naomi.findGui('Engineering'))
    naom.gui.mainGui(bench);
end
end