function cmdRelativeZonal(bench, actNum, amplitudeOffset)

	if bench.config.simulated
		if nargin<3
			bench.simulated.cmdVector = bench.simulated.cmdVector + actNum;
		else
			bench.simulated.cmdVector(actNum) = bench.simulated.cmdVector(actNum) + amplitudeOffset;
		end
	else
		if nargin<3
			bench.dm.cmdVector = bench.dm.cmdVector + actNum;
		else		
			bench.dm.cmdVector(actNum) = bench.dm.cmdVector(actNum) + amplitudeOffset;
		end
    end
    bench.dmCounter = bench.dmCounter + 1;
	if bench.config.plotVerbose
		naomi.plot.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end		
end