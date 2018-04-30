function resetDm(bench)
	bench.dm.Reset;
    bench.dmCounter = bench.dmCounter + 1;
	if bench.config.plotVerbose
		naomi.plot.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end
end