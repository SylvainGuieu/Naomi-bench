function simulator = newSimulator(config)
%STARTSIMULATOR Summary of this function goes here
%   Detailed explanation goes here
   IFM =[];
   ZtC = [];
   biasVector = [];
   turbuArray = [];
   
   IFM = naomi.data.IFMatrix(config.simulatorIFM).data;
   if ~isempty(config.simulatorZtC) && strlength(config.simulatorZtC)
       ZtC = naomi.data.ZtC(config.simulatorZtC).data;
   end
   if ~isempty(config.simulatorBias) && strlength(config.simulatorBias)
       ZtC = naomi.data.DmBias(config.simulatorBias).data;
   end
   
   if ~isempty(config.simulatorTurbu) && strlength(config.simulatorTurbu)
       turbuArray = naomi.data.TurbuCube(config.simulatorTurbu).data;
   end
   simulator = naomi.objects.Simulator(IFM, biasVector, turbuArray, ZtC);
end

