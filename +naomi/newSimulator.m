function simulator = newSimulator(config)
%STARTSIMULATOR Summary of this function goes here
%   Detailed explanation goes here
   IFM =[];
   ZtC = [];
   biasVector = [];
   turbuArray = [];
   
   IFM = naomi.data.IFM(config.simulatorIFM).data;
   if ~isempty(config.simulatorZtC) && strlength(config.simulatorZtC)
       
       ZtC = naomi.data.ZtC(config.simulatorZtC).data;
   else
       % need ACE to compute the ZtC
       naomi.startACE(config);
   end
   if ~isempty(config.simulatorBias) && strlength(config.simulatorBias)
       biasVector = naomi.data.DmBias(config.simulatorBias).data;
   end
   
   if ~isempty(config.simulatorTurbu) && strlength(config.simulatorTurbu)
       turbuArray = naomi.data.TurbuCube(config.simulatorTurbu).data;
   end
   simulator = naomi.objects.Simulator(IFM, biasVector, turbuArray, ZtC);
end

