function resetDm(bench)
	bench.dm.Reset
	if bench.config.plotVerbose
		bench.config.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end
end