function cmdRelativeModal(bench, zernikeNum, amplitudeOffset)


	if bench.config.simulated 
        
		if nargin<3
            bench.simulator.setZernike(bench.simulator.zernikeVector + zernikeNum);
			%bench.simulator.zernikeVector =  bench.simulator.zernikeVector + zernikeNum;
        else
            bench.simulator.setZernike(bench.simulator.zernikeVector(zernikeNum) + amplitudeOffset);
			%bench.simulator.zernikeVector(zernikeNum) = bench.simulator.zernikeVector(zernikeNum) + amplitudeOffset;
		end
	else		
		if nargin<3
			bench.dm.zernikeVector = bench.dm.zernikeVector + zernikeNum;
		else		
			bench.dm.zernikeVector(zernikeNum) = bench.dm.zernikeVector(zernikeNum) + amplitudeOffset;
		end
    end
    bench.dmCounter = bench.dmCounter + 1;
	if bench.config.plotVerbose
		naomi.plot.figure('DM Command', 0);
		naomi.plot.dmCommand(bench);
	end	
end