function copyHeaderKeys(dataFrom, dataTo, keyList)
  if isa(dataTo, 'naomi.data.BaseData')
    for iKey=1:length(keyList)
      key = keyList{iKey};
      try
        [value,comment] = dataFrom.getKey(key)
      catch err
        % do nothing
        continue; 
      end
      
      % copy the key only if does not exist 
      try
        dataTo.getKey(key);
      catch err
        dataTo.setKey(key, value, comment)
      end
    end
  else
    for iKey=1:length(keyList)
      key = keyList{iKey};
      try
        [value,comment] = dataFrom.getKey(key)
      catch err
        % do nothing
        continue; 
      end
      naomi.addToHeader(dataTo, key, value, comment)
    end
  end
end