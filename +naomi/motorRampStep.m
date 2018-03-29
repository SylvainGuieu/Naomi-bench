function [rx,ry,alpha,beta,dalpha,dbeta] = motorRampStep(config, direction)
    global gimbal
    global autocol
    
    startX = config.gimbalRxZero; 
    startY = config.gimbalRyZero; 
    step = config.gimbalRampStep;
    dt = 1;

    

    N = config.gimbalRampPoints;
    alpha = [];
    beta = [];
    dalpha = [];
    dbeta = []; 
    rx = []; 
    ry = [];
    
   
    % empty buffer 
     for j=1:10
            [a,b] = autocol.getAllXY();
            figure(1); plot(a,'ro-'); title(sprintf('%d', j));
            figure(2); plot(b,'ro-'); title(sprintf('%d', j));
            pause(0.1);
     end
     
    gimbal.rX.moveTo(startX); 
    gimbal.rY.moveTo(startY); 
    pause(dt); 
    for i=1:N
        % read 2 data to avoid transitory position 
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
        
        figure(3); plot(rx, alpha, 'o'); 
        figure(4); plot(ry, beta, 'o');
        if length(rx)>1
            px = polyfit(rx,alpha,1);
            py = polyfit(ry,beta,1);
            
            switch direction 
            case {'rX','rx','RX', 'rXY', 'rxy'}      
                figure(3); hold on; 
                xpx = [min(rx), max(rx)];
                plot( xpx, xpx*px(1)+px(2));
                title(sprintf('%.3f', px(1)));         
                hold off;
            case {'rY','ry','RY', 'rXY', 'rxy'}
                figure(4); hold on; 
                xpy = [min(ry), max(ry)];
                plot( xpy, xpy*py(1)+py(2));
                title(sprintf('%.3f', py(1))); 
                hold off;
            end
        end
        switch direction
            case {'rX','rx','RX'}  
                gimbal.rX.moveBy(step);
            case {'rY','ry','RY',}  
                gimbal.rY.moveBy(step);
            case {'rXY', 'rxy'}
                gimbal.rX.moveBy(step);
                gimbal.rY.moveBy(step);
        end
        pause(dt);
    end
end
