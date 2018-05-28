function keyList = ztcKeyList()
  % return a list of potentialy created KEYWORD in a ZtC data
  %   This is usefull when copying a header from one to an other 
  % e.g.  naomi.copyHeaderKeys(ZtCData, ZtPData, naomi.ztcKeyList)
  K = naomi.KEYS;
  keyList = {K.ZTCDIAM, K.ZTCMNAME, K.ZTCNAME, K.ZTCNEIG, K.ZTCNZERN, ...
             K.ZTCOBSDIAM, K.ZTCORIENT, K.ZTCZMEAN, K.ZTCXCENTER, ...
             K.ZTCYCENTER, K.ZTCXSCALE, K.ZTCYSCALE};
end