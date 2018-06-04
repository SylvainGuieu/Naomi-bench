function keyList = alignmentKeyList()
  % return a list of potentialy created KEYWORD by the bench.populateHeader
  %   This is usefull when copying a header from one to an other 
  % e.g.  naomi.copyHeaderKeys(IFMData, ZtC, naomi.benchKeyList)
  K = naomi.KEYS;
  keyList = {K.XCENTER, K.YCENTER, K.XPSCALE,  K.YPSCALE, ... % bench 
             K.XPCENTER, K.YPCENTER, K.ORIENT, K.DMANGLE};
end