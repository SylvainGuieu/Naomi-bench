function [xScale,yScale, phaseCubeData] = pixelScale(bench,  nPushPull, amplitude)
    % getScale   Measure the scale of the WFS
    %
    %    [xS,yS] = getScale(bench,  nPushPull, amplitude)
    %
    if nargin<2; nPushPull = bench.config.scaleNpushPull; end
    if nargin<3; amplitude = bench.config.scaleAmplitude; end

    
    

    % Parameters
    [i,j,~] = naomi.compute.actuatorPosition();
    N = 2048*4;

    % Push-pull with X-waffle
    nSubAperture = bench.nSubAperture
    phase = zeros(nSubAperture,nSubAperture);
    phaseCube = [];

    for p = 1:nPushPull;
        naomi.action.resetDm(bench);

        naomi.action.cmdZonal(bench,  ~mod(i,2),  amplitude);
        naomi.action.cmdZonal(bench, ~~mod(i,2), -amplitude);        
        p = naomi.measure.phase(bench);

        phase = phase + p / nPushPull;
        phaseCube = [phaseCube; p];
        naomi.action.cmdZonal(bench,  ~mod(i,2), -amplitude);
        naomi.action.cmdZonal(bench, ~~mod(i,2),  amplitude);   
                 
        p = naomi.measure.phase(bench);
        phase = phase - p / nPushPull;
        phaseCube = [phaseCube; p];        
    end;
    naomi.action.resetDm(bench);
    X = squeeze(naomi.compute.nansum(phase,2));
    Xf = abs(fft(X(~isnan(X)),N));
    [~,xf] = max(Xf(1:N/2));
    xS = 5. / (N./xf);

    bench.config.log(sprintf('Measure xscale = %.4fmm/pix\n',xS));

    % Push-pull with Y-waffle
    phase = zeros(nSubAperture,nSubAperture);
    for p = 1:nPushPull;
        naomi.action.resetDm(bench);

        naomi.action.cmdZonal(bench,  ~mod(j,2),  amplitude);
        naomi.action.cmdZonal(bench, ~~mod(j,2), -amplitude); 
        
        p = naomi.measure.phase(bench);
        phase = phase + p / nPushPull;
        phaseCube = [phaseCube; p];

        naomi.action.cmdZonal(bench,  ~mod(j,2), -amplitude);
        naomi.action.cmdZonal(bench, ~~mod(j,2),  amplitude); 

        p = naomi.measure.phase(bench);
        phase = phase - p / nPushPull;
        phaseCube = [phaseCube; p];
        naomi.action.resetDm(bench);
    end;
    naomi.action.resetDm(bench);

    Y = squeeze(naomi.compute.nansum(phase,1));
    Yf = abs(fft(Y(~isnan(Y)),N));
    [~,yf] = max(Yf(1:N/2));
    yS = 5. / (N./yf);

    bench.config.log(sprintf('Measure yscale = %.4fmm/pix\n',yS), 1);    
    naomi.action.resetDm(bench);
    phaseCubeData = naomi.data.PhaseCube(phaseCube, {}, {bench});
    
    xScale = xS*1e-3;% stored in m/pix 
    yScale = yS*1e-3;
end
