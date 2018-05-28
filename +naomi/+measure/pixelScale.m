function [xScale,yScale] = pixelScale(bench,  nPushPull, amplitude)
    % getScale   Measure the scale of the WFS
    %
    %    [xS,yS] = getScale(bench,  nPushPull, amplitude)
    %
    if nargin<2; nPushPull = bench.config.scaleNpushPull; end
    if nargin<3; amplitude = bench.config.scaleAmplitude; end

    actuatorSeparation = bench.config.dmActuatorSeparation;
    

    % Parameters
    [i,j,~] = naomi.compute.actuatorPosition(bench.config.phaseOrientation);
    N = 2048*4;

    % Push-pull with X-waffle
    nSubAperture = bench.nSubAperture;
    phase = zeros(nSubAperture,nSubAperture);

    for p = 1:nPushPull
        naomi.action.resetDm(bench);

        naomi.action.cmdZonal(bench,  ~mod(i,2),  amplitude);
        naomi.action.cmdZonal(bench, ~~mod(i,2), -amplitude);        
        newPhase = naomi.measure.phase(bench);
        pause(0.5);
        
        phase = phase + newPhase / nPushPull;
        naomi.action.cmdZonal(bench,  ~mod(i,2), -amplitude);
        naomi.action.cmdZonal(bench, ~~mod(i,2),  amplitude);   
                 
        newPhase = naomi.measure.phase(bench);
        pause(0.5);
        phase = phase - newPhase / nPushPull;
    end
    naomi.action.resetDm(bench);
    X = squeeze(naomi.compute.nansum(phase,2));
    Xf = abs(fft(X(~isnan(X)),N));
    [~,xf] = max(Xf(1:N/2));
    xS = actuatorSeparation*2 / (N./xf);

    bench.log(sprintf('NOTICE: Measured  X pixel scale = %.4fmm/pix',xS*1000), 2);

    % Push-pull with Y-waffle
    phase = zeros(nSubAperture,nSubAperture);
    for p = 1:nPushPull
        naomi.action.resetDm(bench);

        naomi.action.cmdZonal(bench,  ~mod(j,2),  amplitude);
        naomi.action.cmdZonal(bench, ~~mod(j,2), -amplitude); 
        
        newPhase = naomi.measure.phase(bench);
        pause(0.5);
        phase = phase + newPhase / nPushPull;

        naomi.action.cmdZonal(bench,  ~mod(j,2), -amplitude);
        naomi.action.cmdZonal(bench, ~~mod(j,2),  amplitude); 

        newPhase = naomi.measure.phase(bench);
        pause(0.5);
        phase = phase - newPhase / nPushPull;
        naomi.action.resetDm(bench);
    end
    naomi.action.resetDm(bench);

    Y = squeeze(naomi.compute.nansum(phase,1));
    Yf = abs(fft(Y(~isnan(Y)),N));
    [~,yf] = max(Yf(1:N/2));
    yS = actuatorSeparation*2 / (N./yf);

    bench.log(sprintf('NOTICE: Measured Y pixel scale = %.4fmm/pix',yS*1000), 2);    
    naomi.action.resetDm(bench);
    
    xScale = xS;% stored in m/pix 
    yScale = yS;
end
