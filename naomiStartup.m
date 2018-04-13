clear all;
global wfs_;
global bench;

bench = naomi.objects.Bench();
%%%
% local config for test purpose
bench.config.useGimbal = false;
%

bench.startACE();
bench.startWfs();
%bench.startDm();

if bench.config.useGimbal
	bench.startGimbal();
end


