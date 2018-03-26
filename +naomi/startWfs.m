function startWfs(config)
   % start wave front capability for naomi
   % if HASO128 is used startACE must have been executed before
   global wfs;
   
   switch config.location
       case config.IPAG, config.BENCH
           naomiStartACE(config);
           cFile = 'C:\Program Files (x86)\Imagine Optic\Configuration Files\HASO3_128_GE2_4651 Ebus.dat';
           wfs = naomi.objects.WfsHASO128();
           wfs.connect(cFile,'M660FA');
           wfs.Online();
           
       case config.ESOHQ
           wfs = naomi.objects.WfsPhaseCam4020('PhaseCam4020','134.171.36.241',15555);
           waitfor(msgbox('Make sure the serveur is started on PhaseCam'));
   end
   wfs.Online();