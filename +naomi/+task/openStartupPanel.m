function  openStartupPanel(bench)
%openEnvironmentPanel Summary of this function goes here
%   Detailed explanation goes here
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end

if isempty(naomi.findGui(naomi.KEYS.G_STARTUP))
    startupGui(bench);
    movegui(naomi.findGui(naomi.KEYS.G_STARTUP), 'northwest');
end

end

