function cmdZonal(bench, actNum, amplitude)

	if bench.config.simulated
		if nargin<3
			bench.simulator.cmdVector(':') = actNum;
		else
			bench.simulator.cmdVector(actNum) = amplitude;
		end
	else
		if nargin<3
			bench.dm.cmdVector = actNum;
		else		
			bench.dm.cmdVector(actNum) = amplitude;
		end
    end

    bench.dmCounter = bench.dmCounter + 1;
	if bench.config.plotVerbose
		naomi.plot.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end		
end