function cmdRelativeModal(bench, zernikeNum, amplitudeOffset)


	if bench.simulated 
		if nargin<3
			bench.simulator.zerniqueVector =  bench.simulator.zerniqueVector + zernikeNum;
		else
			bench.simulator.zerniqueVector(zernikeNum) = bench.simulator.zerniqueVector(zernikeNum) + amplitudeOffset;
		end
	else		
		if nargin<3
			bench.dm.zerniqueVector = bench.dm.zerniqueVector + zernikeNum;
		else		
			bench.dm.zerniqueVector(zernikeNum) = bench.dm.zerniqueVector(zernikeNum) + amplitudeOffset;
		end
	end

	if bench.config.plotVerbose
		naomi.plot.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end	
end