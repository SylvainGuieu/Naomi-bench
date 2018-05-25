function cmdRelativeZonal(bench, actNum, amplitudeOffset)
   
    if nargin<3
        bench.dm.cmdVector = bench.dm.cmdVector + actNum;
    else		
        bench.dm.cmdVector(actNum) = bench.dm.cmdVector(actNum) + amplitudeOffset;
    end
    
    bench.dmCounter = bench.dmCounter + 1;
	if bench.config.plotVerbose
		naomi.plot.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end		
end