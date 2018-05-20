function wfs = newWfs(config)
   % start wave front capability for naomi
   % if HASO128 is used startACE() must have been executed before
   global naomiGlobalWfs;
   
   config.log('Starting the wfs. ', 1);
   if ~exist('naomiGlobalWfs','var') ||  isempty(naomiGlobalWfs)
       switch config.wfsModel

           case 'haso128'
               config.log('This is an HASO128 ...',1);
               
               naomiGlobalWfs = naomi.objects.WfsHASO128();
               naomiGlobalWfs.connect(config.haso128cFile,config.haso128Serial);

           case 'phasecam'
               config.log('This is a PhaseCam ...', 1);
               naomiGlobalWfs = naomi.objects.WfsPhaseCam4020('PhaseCam4020','134.171.36.241',15555);
               waitfor(msgbox('Make sure the serveur is started on PhaseCam'));
           otherwise
              error(strcat('wfs model ', config.wfsModel, ' not understood use haso128 or phasecam'));
       end
   end
   naomiGlobalWfs.Online();
   wfs = naomiGlobalWfs; 
   config.log('OK\n', 1);
end
