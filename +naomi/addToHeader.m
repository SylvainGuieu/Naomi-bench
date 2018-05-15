function h = addToHeader(h, key, value, comment)
    % add key / value / comment to haeder 
    % first argument must be a cell array a container Map or a opened fits file
    %    
    if iscell(h)
        if nargin<3 % this is a Nx3 cell array 
            for iKey=1:length(key)
                h{length(h)+1} = key{iKey};
            end            
        else
            h{length(h)+1} = {key, value, comment};
        end
    elseif isa(h,'containers.Map')
    	
        if nargin<3 % this is a Nx3 cell array 
            for iKey=1:length(key)
                c = key{iKey};
                h(c{1}) = {c{2}, c{3}};
               
            end            
        else
	    	h(key) = {value, comment};
        end
    else
        if nargin<3 % this is a Nx3 cell array 
            for iKey=1:length(key)
                c = key{iKey};
                fits.writeKey(h, c{1}, c{2}, c{3});
            end
        else
            fits.writeKey(h, key, value, comment);
        end
    end
end