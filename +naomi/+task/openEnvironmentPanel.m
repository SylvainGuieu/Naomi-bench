function  openEnvironmentPanel(bench)
%openEnvironmentPanel Summary of this function goes here
%   Detailed explanation goes here
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end
if ~bench.has('environment')
    msgbox({'Environment modul is offline', 'Start it first'});
    return            
else
if isempty(naomi.findGui('Environment'))
    naomi.gui.environmentControlGui(bench.environment);
end
end

