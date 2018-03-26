function startReference(wfs, config)
    global reference;
    global wfs;
    if isempty(wfs)
        naomi.startWfs(config);
    reference = naomi.objects.Reference(wfs);
    %reference.saveReference(config);