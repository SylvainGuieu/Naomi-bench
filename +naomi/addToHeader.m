function addToHeader(h, key, value, comment)
    % add key / value / comment to haeder 
    % first argument must be a cell array a container Map or a opened fits file
    %    
    if iscell(h)
        h{length(h)+1} = {key, value, comment};
    elseif isa(h,'containers.Map')
    	%if force || ~isKey(h, key)
	    	h(key) = {value, comment};
	    %end
    else
        fits.writeKey(h, key, value, comment);
    end
end