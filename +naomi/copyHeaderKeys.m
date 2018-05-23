function copyHeaderKeys(dataFrom, hTo, keyList)
  
  for iKey=1:length(keyList)
    key = keyList{iKey};
    try
      [value,comment] = dataFrom.getKey(key)
    catch err
      % do nothing
      continue; 
    end
    naomi.addToHeader(hTo, key, value, comment);
end