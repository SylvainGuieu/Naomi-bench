function dmCommand(bench,  axes)
    % plot the DM command map 
    % the command Vector can be given otherwhise 
    % the one in bench.cmdVector + bench.biasVector is taken

    if nargin<2; axes = gca; end;
	
    if strcmp(bench.config.dmId, bench.config.DUMMY)
        
	
        cla(axes);
        text(axes, 0.5, 0.5, 'Dummy Mirror', 'Color','red','FontSize',16,...
                             'HorizontalAlignment', 'center' );
        return
    end
    
    cmdVector = bench.cmdVector + bench.biasVector;
    
	[xi,yi,mask] = naomi.compute.actuatorPosition();
    [yM, xM] = size(mask);
	values = mask*1.0;
    
	values(mask) = mask(mask).*cmdVector;
    values(~mask) = nan;
    maxi = max(cmdVector);
    mini = min(cmdVector);
    maxa = max(abs(cmdVector));
	cla(axes); imagesc(axes, values);
    
	colorbar(axes); 	
	title(axes,sprintf('min=%.2f max=%.2f', mini, maxi));
	text(axes, xi(1), yi(1), '1');
	text(axes, xi(7), yi(7), '7');
	text(axes, xi(8), yi(8), '8');
    xlim(axes, [1,xM]);
    ylim(axes, [1,yM]);
    daspect(axes, [1,1,1]);
end