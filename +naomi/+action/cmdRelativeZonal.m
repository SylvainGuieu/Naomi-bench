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
	if bench.config.plotVerbose
		bench.config.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end		
end