function dmCommand(bench)
	% plot the DM monitoring 	
	cmdVector = bench.dm.cmdVector + bench.dm.biasVector;
	

	[xi,yi,mask] = naomi.compute.actuatorPosistion();
	values = mask*1.0;
	values(mask) = mask(mask)*cmdVector;
    values(~mask) = nan;
	clf; imagesc(values);
	colorbar; 	
	title(sprintf('min=%.2f max=%.2f', min(cmdVector), max(cmdVector)));
	text(xi(1), yi(1), '1');
	text(xi(7), yi(7), '7');
	text(xi(8), yi(8), '8');
end