function cmdModal(bench, zernikeNum, amplitude)


	if bench.config.simulated
		if nargin<3
			bench.simulator.zernikeVector = zernikeNum;
		else
			bench.simulator.zernikeVector(zernikeNum) = amplitude;
		end
	else
		if nargin<3
			bench.dm.zernikeVector = zernikeNum;
		else		
			bench.dm.zernikeVector(zernikeNum) = amplitude;
		end
	end

	if bench.config.plotVerbose
		bench.config.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end
end