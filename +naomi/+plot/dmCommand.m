function dmCommand(bench, axes)
    % plot the DM monitoring 
    if nargin<2; axes = gca; end;
	
    if strcmp(bench.config.dmID, bench.config.DUMMY)
        
	
        cla(axes);
        text(axes, 0.5, 0.5, 'Dummy Mirror', 'Color','red','FontSize',16,...
                             'HorizontalAlignment', 'center' );
        return
    end
    cmdVector = bench.cmdVector + bench.biasVector;
	[xi,yi,mask] = naomi.compute.actuatorPosistion();
	values = mask*1.0;
	values(mask) = mask(mask)*cmdVector;
    values(~mask) = nan;
	cla(axes); imagesc(axes,values);
	colorbar(axes); 	
	title(axes,sprintf('min=%.2f max=%.2f', min(cmdVector), max(cmdVector)));
	text(axes, xi(1), yi(1), '1');
	text(axes, xi(7), yi(7), '7');
	text(axes, xi(8), yi(8), '8');
end