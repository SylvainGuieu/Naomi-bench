clear all;
% this is necessary to create a global and unique object for the wfs 
% toherwise it does not work 
global naomiGlobalWfs;
global naomiGlobalDm;
global naomiGlobalConfig;
global naomiGlobalBench;
% to avoid un wanted warning message  (matlab bug) 
% https://fr.mathworks.com/matlabcentral/answers/336493-warning-a-value-of-class-appdesigner-internal-service-appmanagementservice-was-indexed-with-no-su
warning('off', 'MATLAB:subscripting:noSubscriptsSpecified');

% create a new config file (it will be updated by naomiLocalConfig if exists)
naomiGlobalConfig = naomi.newConfig();
naomiGlobalBench = naomi.objects.Bench(naomiGlobalConfig);
% create a copy with the name bench
bench = naomiGlobalBench;

if isempty(naomi.findGui('Naomi Startup'))
    startupGui(bench);
end

