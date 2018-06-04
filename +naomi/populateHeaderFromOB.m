function n = populateHeaderFromOB(data,ob)
  %POPULATEHEADERFROMOB - populate some common parameters found in a ob structure
  %   if ob is empty nothing is done 
  %
  % Syntax:  populateHeaderFromOB(data, ob)
  %
  % Inputs
  % ------
  %    data: must be an object with the setKey method (naomi.data.* object)
  %    ob :  a structure or empty 
  %    input3:  Description
  %
  % Outputs
  % -------
  %    n : number of keys populated
  %
  % field / KEYS 
  % -------
  %    - startDate  / DATEOB
  %
  %
  % Author: Sylvain Guieu
  % May 2018; Last revision: 30-May-2018
  fields = {{'startDate', naomi.KEYS.DATEOB, naomi.KEYS.DATEOBc}, ...
            {'tplName' ,  naomi.KEYS.TPLNAME naomi.KEYS.TPLNAMEc}};
            
  n = 0;
  for iField=1:length(fields)
    def = fields{iField};
    if isfield(ob, def{1})
      data.setKey(def{2}, getfield(ob, def{1}), def{3});
      n = n + 1;
   end
end