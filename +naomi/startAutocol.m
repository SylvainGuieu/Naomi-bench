function startAutocol(config)
    global autocol
    if ~isempty(autocol)
        % make sure to close it properly
        fclose(autocol.client);
    end
    autocol = naomi.objects.Autocol(config.autocolCom);
end