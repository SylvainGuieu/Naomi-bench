function writeDataMatlab(filename, wfs, dm)
  if nargin<3
      dm_data = {}
  else
      dm_data = {dm.zernike2Command, dm.sSerialName, dm.sMask, dm.cmdVector, ...
                 dm.biasVector, dm.cmdVector, dm.biasMap, dm.maxValue,...
                 dm.nAct, dm.zernikeVector};
  end
  wfs_data = {wfs.pause,wfs.ref,wfs.mask,wfs.src,wfs.model, ...
              wfs.Nsub,wfs.filterTilt};
  
  save(filename,'dm_data','wfs_data');
  
end