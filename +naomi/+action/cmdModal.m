function cmdModal(bench, zernikeNum, amplitude)


	if bench.config.simulated
		if nargin<3
            % todo fiz the deifference 
			bench.simulator.setZernike(zernikeNum);%zernikeNum is amplitude
        else
            bench.simulator.setZernike(zernikeNum, amplitude);
		end
	else
		if nargin<3
			bench.dm.zernikeVector = zernikeNum;%zernikeNum is amplitude
		else		
			bench.dm.zernikeVector(zernikeNum) = amplitude;
		end
    end
    bench.dmCounter = bench.dmCounter + 1;
	if bench.config.plotVerbose
		naomi.plot.figure('DM Command');
		naomi.plot.dmCommand(bench);
	end
end