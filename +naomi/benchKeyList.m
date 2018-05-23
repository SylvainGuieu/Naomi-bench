function keyList = benchKeyList()
  % return a list of potentialy created KEYWORD by the bench.populateHeader
  %   This is usefull when copying a header from one to an other 
  % e.g.  naomi.copyHeaderKeys(IFMData, ZtC.header, naomi.benchKeyList)
  K = naomi.KEYS;
  keyList = {K.XCENTER, K.YCENTER, K.XPSCALE,... % bench 
             K.XPCENTER,  K.YPSCALE, K.YPCENTER, K.ORIENT, ...
             K.DMID, ... 
             K.WFSNSUB, K.WFSNAME, ... % wfs
             
             K.TEMPMIRROR,  K.TEMPQSM, ..., % environment  
             K.TEMPIN, K.TEMPOUT,...
             K.TEMPEMBIANT, K.TEMPREGUL, K.HUMIDITY, ...
             
             K.GBID, ... % gimbal 
             K.RXZERO, K.RXGAIN, K.RXPOS, ...
             K.RYZERO, K.RYGAIN, K.RYPOS, ...
             };