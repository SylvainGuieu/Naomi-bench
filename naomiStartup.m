if exist('naomiGlobalBench', 'var')
    naomiShutdown;
end
% this is necessary to create a global and unique object for the wfs 
% toherwise it does not work 
global naomiGlobalWfs;
global naomiGlobalDm;
global naomiGlobalConfig;
global naomiGlobalBench;
global naomiGlobalEnvironmentBuffer;
% to avoid un wanted warning message  (matlab bug) 
% https://fr.mathworks.com/matlabcentral/answers/336493-warning-a-value-of-class-appdesigner-internal-service-appmanagementservice-was-indexed-with-no-su
warning('off', 'MATLAB:subscripting:noSubscriptsSpecified');

%
% Some shortcut 
K = naomi.KEYS;

% create a new config file (it will be updated by naomiLocalConfig if exists)
naomiGlobalConfig = naomi.newConfig();
naomiGlobalBench = naomi.newBench(naomiGlobalConfig);
% create a buffer for monitoring the temperature when the environment
% pannel is opened. Dynamic buffer with initialy  15000 row and will
% increase by 5000 if needed
naomiGlobalEnvironmentBuffer = naomi.newEnvironmentBuffer;

% create a copy with the name bench
bench = naomiGlobalBench;
% make a new session after each startup ?
% bench.newSession
naomi.task.openStartupPanel;
naomi.task.openCalibrationPanel;
