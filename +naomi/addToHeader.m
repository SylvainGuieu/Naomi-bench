function addToHeader(h, key, value, comment)
    % add key / value / comment to haeder 
    % first argument must be a cell array or a opened fits file
    if iscell(h)
        h{length(h)+1} = {key, value, comment};
    elseif isa(h,'containers.Map')
    	h(key) = {value, comment};
    else
        fits.writeKey(h, key, value, comment);
    end