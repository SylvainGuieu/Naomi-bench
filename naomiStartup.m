clear all;
global bench;
bench = naomi.objects.Bench();
bench.startWfs();
bench.startDm();
if bench.config.useGimbal
	bench.startGimbal();
end


