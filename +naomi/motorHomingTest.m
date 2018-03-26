function [time,rx,ry,alpha,beta,dalpha,dbeta] = motorHomingTest(config, direction)
    global gimbal
    global autocol
    
    startX = config.gimbalRxZero; 
    startY = config.gimbalRyZero; 
   
    dt = 1;

    

    N = config.gimbalHomingPoints;
    alpha = [];
    beta = [];
    dalpha = [];
    dbeta = []; 
    rx = []; 
    ry = [];
    time = [];
    
    
    % empty buffer 
     for j=1:10
            [a,b] = autocol.getAllXY();
            figure(1); plot(a,'ro-'); title(sprintf('%d', j));
            figure(2); plot(b,'ro-'); title(sprintf('%d', j));
            pause(0.1);
            
    end
    gimbal.rX.init;
    gimbal.rY.init;
    gimbal.rX.moveTo(startX); 
    gimbal.rY.moveTo(startY); 
    pause(dt);
    stime = now;
    
    for i=1:N
        % read 2 data to avoid transitory position
        %fclose(autocol.client);
        %naomi.startAutocol(config);
        for j=1:3
            [a,b] = autocol.getAllXY();
            figure(1); plot(a,'ro-'); title(sprintf('%d', j));
            figure(2); plot(b,'ro-'); title(sprintf('%d', j));
            pause(0.1);
        end

        [a,b] = autocol.getAllXY();
        pos = sprintf('rX= %.5f  rY=%.5f ', gimbal.rX.getPos(), gimbal.rY.getPos());
        figure(1); plot(a, 'bo-'); title(pos);
        figure(2); plot(b, 'bo-'); title(pos);
        ln = length(a);
        alpha = [alpha; mean(a)];
        beta =  [beta;  mean(b)]; 
        dalpha = [dalpha; std(a)];
        dbeta =  [dbeta;  std(b)]; 
        rx = [rx; gimbal.rX.getPos()];
        ry = [ry; gimbal.rY.getPos()];
        time = [time; (now- stime)*24*3600];
        
        figure(3); plot(time,alpha, 'o'); 
        figure(4); plot(time,beta, 'o');
       
        switch direction
            case {'rX','rx','RX'}  
                gimbal.rX.init;
                gimbal.rX.moveTo(startX);
            case {'rY','ry','RY',}  
                gimbal.rY.init;
                gimbal.rY.moveTo(startY);
            case {'rXY', 'rxy'}
                gimbal.rX.init;
                gimbal.rX.moveTo(startX);
                gimbal.rY.init;
                gimbal.rY.moveTo(startY);
        end
        pause(dt);
    end
end
