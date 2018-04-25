function resetDm(bench)
	bench.dm.Reset
	if bench.config.plotVerbose
		naomi.plot.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end
end