function model = ifmProfileModel(fitResult, X, Y)
    data = [];
    data.x = X;
    data.y = Y;
    switch fitResult.type
        case 'gaussER'
            
            model = naomi.fitFunc.gaussER(fitResult.args, data);
            
        case 'gaussE'
            
            model = naomi.fitFunc.gaussE(fitResult.args, data);
        case 'gauss'            
            model = naomi.fitFunc.gauss(fitResult.args, data);
        case 'lorentzE'
             model = naomi.fitFunc.lorentzE(fitResult.args, data);
        case 'lorentz'
            model = naomi.fitFunc.lorentz(fitResult.args, data);                      
        case 'maximum'
            % the model is just a door 
            
            mask =  ((X-fitResult.xCenter).^2 + (Y-fitResult.yCenter).^2) < (fitResult.hwhm.^2);
            model = mask*1.0;
            model(mask) = fitResult.amplitude./2.;
            
    end
    model = model+fitResult.offset;
end
