if exist('naomiGlobalBench', 'var') && ~isempty(naomiGlobalBench)
    naomiGlobalBench.log('WARNING: Naomi is shutting down');
    naomiGlobalBench.stop;
end
% close regular figures
close all
% search for gui and close 
hFig = findall(groot, 'Type', 'figure');
for iFig=1:length(hFig)
    close(hFig(iFig));
end

pause(0.5); 
clear all: