function  success = dmBias(bench, data_or_file)
 %DMBIAS- config the dmBiasData to the bench (and the bench.dm)
 %   The dmbias data is the dm actuator commands that give the best 
 %   DM flat position in the bench. 
 %   dmBiasData  is returned by naomi.measure.dmBias
 %
 % Syntax:  success = naomi.config(bench) 
 %          success = naomi.config(bench, DmBiasData)
 %          success = naomi.config(bench, 'file/path')
 %          success = naomi.config(bench, []) 
 %  
 %  If only BENCH is given as argument a GUI will ask user to look for a file 
 %  If a data object is given, it is configured in bench as is 
 %  If a file name is given as INPUT, it is red in the proper data object  
 %  If empty is given any  dmBiasData configuration will be removed 
 %  
 %     
 % Inputs
 % ------
 %    bench: The Bench object 
 %    input:  naomi.data.DmBias data object, char- filename or empty 
 %    
 %
 % Outputs
 % -------
 %    success: 1 for sucess 0 for failur 
 %
 % Exemple
 % -------
 %  [~, dmBiasData] = naomi.measure.dmBias(bench);
 %  naomi.config.dmBias(bench, dmBiasData)
 %  
 % Author: Sylvain Guieu
 % May 2018; Last revision: 30-May-2018
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a DM Bias file DM_BIAS_*', bench);
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.DmBias(fullPath);
				
	
	elseif ischar(data_or_file)
			data =  naomi.data.DmBias(data_or_file);
	
	elseif isempty(data_or_file)
		bench.dmBiasData = [];			
		sucess = false;
		bench.log('NOTICE: DM Bias removed', 2);
		
		success = true;
		return 
	else
		data = data_or_file;
    end
    
    % this will change the bench.dm.biasVector
	bench.dmBiasData = data;
	naomi.action.resetDm(bench);
	success = true;
	
	bench.log('NOTICE: DM Bias configured',2);
end