function [xS,yS, phaseCube] = scale(bench,  Npp, Amp)
    % getScale   Measure the scale of the WFS
    %
    %    [xS,yS] = getScale(dm, wfs, Amp)
    %
    if nargin<2; Npp = bench.config.scaleNpp; end
    if nargin<3; Amp = bench.config.scaleAmplitude; end

    wfs = bench.wfs;
    dm = wfs.dm;

    % Parameters
    [i,j,~] = naomi.compute.actPos();
    N = 2048*4;

    % Push-pull with X-waffle
    phase = zeros(wfs.Nsub,wfs.Nsub);
    phaseCube = [];
    for p = 1:Npp;
        dm.Reset;
        dm.cmdVector(~mod(i,2))  = Amp;
        dm.cmdVector(~~mod(i,2)) = -Amp;
        if dm.config.plotVerbose; dm.DrawMonitoring(); end
        p = wfs.getPhase();
        phase = phase + p / Npp;
        phaseCube = [phaseCube; p];

        dm.cmdVector( ~mod(i,2)) = -Amp;
        dm.cmdVector(~~mod(i,2)) =  Amp;
        if dm.config.plotVerbose; dm.DrawMonitoring(); end
        p = wfs.getPhase();
        phase = phase - p / Npp;
        phaseCube = [phaseCube; p];
        dm.Reset;
    end;

    X = squeeze(naomi.compute.nansum(phase,2));
    Xf = abs(fft(X(~isnan(X)),N));
    [~,xf] = max(Xf(1:N/2));
    xS = 5. / (N./xf);

    fprintf('Measure xscale = %.4fmm/pix\n',xS);

    % Push-pull with Y-waffle
    phase = zeros(wfs.Nsub,wfs.Nsub);
    

    for p = 1:Npp;
        dm.Reset;
        dm.cmdVector(~mod(j,2))  =  Amp;
        dm.cmdVector(~~mod(j,2)) = -Amp;
        dm.DrawMonitoring();
        p = wfs.GetPhase();
        phase = phase + p / Npp;
        phaseCube = [phaseCube; p];


        dm.cmdVector(~mod(j,2))  = -Amp;
        dm.cmdVector(~~mod(j,2)) = Amp;
        dm.DrawMonitoring();
        p = wfs.GetPhase();
        phase = phase - p / Npp;
        phaseCube = [phaseCube; p];
        dm.Reset;
    end;

    Y = squeeze(naomi.compute.nansum(phase,1));
    Yf = abs(fft(Y(~isnan(Y)),N));
    [~,yf] = max(Yf(1:N/2));
    yS = 5. / (N./yf);

    fprintf('Measure yscale = %.4fmm/pix\n',yS);

    dm.Reset;
    phaseCube = naomi.data.PhaseCube(phaseCube, {}, {bench});
    
end
