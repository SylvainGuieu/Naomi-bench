function fitResult = fittedIFMprofile(ifm,  fitType, sigmaGuess, amplitudeGuess)
    if nargin<2
        fitType = 'gauss';
    end
    
    if nargin<3
        sigmaGuess = 100; %typical for naomi
    end
    if nargin<4
        amplitudeGuess = 7; %typical for naomi
    end
    
    [nAct, ~, ~] = size(ifm);
    amplitudeVector = zeros(nAct,1);
    xCenterVector = zeros(nAct,1);
    yCenterVector = zeros(nAct,1);
    xHwhmVector = zeros(nAct,1);
    yHwhmVector = zeros(nAct,1);
    hwhmVector = zeros(nAct,1);
    
    
    
    for iAct=1:nAct
        
        fit = naomi.compute.fittedIFprofile(squeeze(ifm(iAct,:,:)),fitType, sigmaGuess, amplitudeGuess);
        if iAct==1
            results = struct(fit);
        else
            results(iAct) = fit;
        end
        
        amplitudeVector(iAct) = fit.amplitude;
        xCenterVector(iAct) = fit.xCenter;
        yCenterVector(iAct) = fit.yCenter;
        xHwhmVector(iAct) = fit.xHwhm;
        yHwhmVector(iAct) = fit.yHwhm;
        hwhmVector(iAct) = fit.hwhm;
    end
            
    fitResult =[];
    fitResult.type = fitType;
    fitResult.results = results;
    fitResult.amplitude = amplitudeVector;
    fitResult.xCenter = xCenterVector;
    fitResult.yCenter = yCenterVector;
    fitResult.xHwhm = xHwhmVector;
    fitResult.yHwhm = yHwhmVector;
    fitResult.hwhm = hwhmVector;
end
    
    
    
    