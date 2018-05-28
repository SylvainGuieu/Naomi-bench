function keyList = ifmKeyList()
  % return a list of potentialy created KEYWORD to a IFM 
  %   This is usefull when copying a header from one to an other 
  % e.g.  naomi.copyHeaderKeys(IFMData, ZtCData, naomi.imfKeyList)
  K = naomi.KEYS;
  keyList = {K.IFMLOOP, K.IFMPAUSE, K.IFAMP, K.IFNPP, K.IFNEXC, K.IFPERC};
end