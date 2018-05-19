clear all;
global wfs_;
global naomiBench;
% to avoid un wanted warning message  (matlab bug) 
% https://fr.mathworks.com/matlabcentral/answers/336493-warning-a-value-of-class-appdesigner-internal-service-appmanagementservice-was-indexed-with-no-su
warning('off', 'MATLAB:subscripting:noSubscriptsSpecified');

bench = naomi.objects.Bench();
%%%
% local config for test purpose
bench.config.simulated = 0;
bench.config.useGimbal = false;
%

%bench.startACE();
bench.startWfs();
bench.startDm();

if bench.config.useGimbal
	bench.startGimbal();
end

% set it to the global variable. 
naomiBench = bench;


