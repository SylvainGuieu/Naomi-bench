function [xS,yS] = getScale(dm, wfs, Npp, Amp)
    % getScale   Measure the scale of the WFS
    %
    %    [xS,yS] = getScale(dm, wfs, Amp)
    %

    % Parameters
    [i,j,~] = naomi.ComputeActPos();
    N = 2048*4;

    % Push-pull with X-waffle
    phase = zeros(wfs.Nsub,wfs.Nsub);
    for p = 1:Npp;
        dm.Reset;
        dm.cmdVector(~mod(i,2))  = Amp;
        dm.cmdVector(~~mod(i,2)) = -Amp;
        dm.DrawMonitoring();

        phase = phase + wfs.GetPhase() / Npp;

        dm.cmdVector( ~mod(i,2)) = -Amp;
        dm.cmdVector(~~mod(i,2)) =  Amp;
        dm.DrawMonitoring();
        phase = phase - wfs.GetPhase() / Npp;
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
        phase = phase + wfs.GetPhase() / Npp;

        dm.cmdVector(~mod(j,2))  = -Amp;
        dm.cmdVector(~~mod(j,2)) = Amp;
        dm.DrawMonitoring();
        phase = phase - wfs.GetPhase() / Npp;
        dm.Reset;
    end;

    Y = squeeze(naomi.compute.nansum(phase,1));
    Yf = abs(fft(Y(~isnan(Y)),N));
    [~,yf] = max(Yf(1:N/2));
    yS = 5. / (N./yf);

    fprintf('Measure yscale = %.4fmm/pix\n',yS);

    dm.Reset;

end

