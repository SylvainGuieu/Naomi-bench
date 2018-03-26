function filePath = saveDMReference(wfs, dm, config,Np)
   % reset the DM take a reference Phase and save it inside the daily 
   % directory as a fits file and matlab file 
   %
   % Input arguments
   % wfs wave front sensor structure 
   % dm  Deformable Miror structure 
   % config  naomi configuration structure 
   % Np  number of frame averaged 
   
   if nargin<2
       Np = 1;
   end
       
   dm.Reset();
   Dataref = wfs.getAvgPhase(Np);
    % Write data FITS
   name = datestr(now,'yyyy-mm-ddTHH-MM-SS');
   filename = fullfile(config.todayDirectory, '\REF_DM_',name,'.fits');
   naomi.writeData(filename, Dataref, 'PHASE_REF', 'STARTUP', dm, wfs);
   
   % Write data MAT
   filename = strcat(config.todayDirectory,'\REF_DM_',name,'.mat');
   naomi.writeDataMatlab(filename, dm, wfs);
   save(filename,'Dataref','-append');
end