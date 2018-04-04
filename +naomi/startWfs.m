function wfs = startWfs(config)
   % start wave front capability for naomi
   % if HASO128 is used startACE() must have been executed before
   global wfs_;
   
   config.log('Starting the wfs. ', 1);
   switch config.location
       
       case config.IPAG, config.BENCH
           config.log('This is an HASO128 ...',1);
           cFile = 'C:\Program Files (x86)\Imagine Optic\Configuration Files\HASO3_128_GE2_4651 Ebus.dat';
           wfs_ = naomi.objects.WfsHASO128();
           wfs_.connect(cFile,'M660FA');
           
       case config.ESOHQ
           config.log('This is a PhaseCam ...', 1);
           wfs_ = naomi.objects.WfsPhaseCam4020('PhaseCam4020','134.171.36.241',15555);
           waitfor(msgbox('Make sure the serveur is started on PhaseCam'));
       otherwise
          error(strcat('Location ', config.location, ' not understood use ', config.IPAG, ', ', config.BENCH, 'or', config.ESOHQ));
   end
   wfs_.Online();
   wfs = wfs_; 
   config.log('OK\n', 1);
end
