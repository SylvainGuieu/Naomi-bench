function dmCommand(bench,  axes)
    % plot the DM command map 
    % the command Vector can be given otherwhise 
    % the one in bench.cmdVector + bench.biasVector is taken

    if nargin<2; axes = gca; end;
	
    if ~bench.isDm
        cla(axes);
        text(axes, 0.5, 0.5, sprintf('DM is Off: %s',bench.dmId), 'Color','red','FontSize',16,...
                             'HorizontalAlignment', 'center' );
        return
    end
    
    cmdVector = bench.cmdVector + bench.biasVector;
    
	[xi,yi, mask] = naomi.compute.actuatorPosition(bench.config.dmOrientation);
    
    [yM, xM] = size(mask);
	values = mask*1.0;
    
	values(mask) = mask(mask).*cmdVector;
    values(~mask) = nan;
    maxi = max(cmdVector);
    mini = min(cmdVector);
    maxa = max(abs(cmdVector));
    
	cla(axes); 
    scatter(axes, xi,yi,40,cmdVector, 'filled');
    hold(axes, 'on')
    text(axes, xi(1), yi(1), '1');
	text(axes, xi(7), yi(7), '7');
	text(axes, xi(8), yi(8), '8');
    hold(axes, 'off')
    
    %imagesc(axes, values);
    
	colorbar(axes); 	
	title(axes,sprintf('min=%.2f max=%.2f', mini, maxi));
	set(axes,'ydir','reverse');
%     xlim(axes, [1,xM]);
%     ylim(axes, [1,yM]);
    xlim(axes, [min(xi)-1,max(xi)+1]);
    ylim(axes, [min(yi)-1,max(yi)+1]);
    daspect(axes, [1,1,1]);
end