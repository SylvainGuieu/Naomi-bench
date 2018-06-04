function fig = figure(name, bringFront)
    %FIGURE Summary of this function goes here
    %   Detailed explanation goes here
    
    % grid define the position of area where the plot will be ploted
    %              |- horizontal screen size in pixel (-1 for auto)
    %              |     |- vertical screen size in pixel (-1 for auto)
    %              |     |    |- horizontal offset in pixel
    %              |     |    |  |- vertical offset in pixel
    %              |     |    |  |  |- h grid resolution
    %              |     |    |  |  |    |- v grid resolution
    screenGrid = [-1,   -1, 0, 0, 100, 100];
    if nargin<2
        bringFront = 1;
    end
    fig = findobj('type','figure','name',name);

    if isempty(fig)
            fig = figure('name',name);
            switch name         
                %% figure related to configuration 
                case 'Phase Reference'
                    set(fig, 'Position',  grid2screen(screenGrid, [1,-10,23,20])); 
                case 'Phase Mask'
                    set(fig, 'Position',  grid2screen(screenGrid, [13,-10,13,10]));                                 
                case 'Zernique to Command' 
                    set(fig, 'Position',  grid2screen(screenGrid, [1,-20,26,10]));
                case 'DM Command'    
                    set(fig, 'Position', [1525 231 392 336]);
                case 'Last Phase'
                     set(fig, 'Position', [1521 652 396 344]);
                 case 'IF'
                     set(fig, 'Position', [1128 654 392 342]); 
                case 'ZtP QC'
                     set(fig, 'Position', [1164 131 560 854]);
                case 'ZtP QC Mode'
                     set(fig, 'Position', [1164 131 560 854]);
                case 'IFM QC'
                    set(fig, 'Position',  [1106 142 605 848]);
                case 'DM Bias'
                    set(fig, 'Position',[1217 417 697 577]);
                case 'TIP QC'
                     set(fig, 'Position',[680 337 560 641]);
                case 'TILT QC'
                     set(fig, 'Position',[1243 340 560 638]);
                case 'ZtP Modes'
                     set(fig, 'Position',[1228 121 560 843]);
                case 'Alignment RTD' % alpao RtD
                    set(fig, 'Position',[1228 121 560 843]);
                case 'ZtC Modes' 
                    set(fig, 'Position',[881 45 560 760]);
                case 'ZtC QC' 
                    set(fig, 'Position',  [799 97 517 701]);
                    %grid2screen(screenGrid, [-1, -10, 25,90]));
%                     case 'Influence Function'
%                     %% figure related to measurement 
%                     case 'Last Phase'
%                         set(fig, 'Position', [sX*sH+dH-300*sH, sY*sV+dV-300*sV, 300*sH, 300*sV]);                     
%                     case 'Best Flat' 
%                         set(fig, 'Position', [sX*sH+dH-300*sH, sY*sV+dV-900*sV, 300*sH, 300*sV]);
%                     case 'IF Central Actuator'
%                         set(fig, 'Position', [1000*sH+dH, 1400*sV+dV, 300*sH, 300*sV]);
%                     case 'Modal Stroke'
%                         set(fig, 'Position', [2000*sH+dH, 2000*sV+dV, 300*sH, 600*sV]);
%                     case 'Mode'
%                     %% figures related to actions 
%                     case 'Alignment'
            end
    else
        if bringFront
            figure(fig);
        else
            set(0, 'CurrentFigure', fig); 
        end
    end
end


function posVector = grid2screen(G,P)
    if G(1)<0 || G(2)<0
        % size inferior to zero,  change it to the screen size
        
        set(0,'units','pixels');
        screenSizes = get(0,'screensize');
        if G(1)<0; G(1) = screenSizes(3); end
        if G(2)<0; G(2) = screenSizes(4); end
    end
    if P(1)<=0.0; P(1) = G(5)+P(1); end
    if P(2)<=0.0; P(2) = G(6)+P(2); end
    posVector = [ G(3) + G(1)*(P(1)/G(5)), ...
                  G(4) + G(2)*(P(2)/G(6)), ...
                  G(1)*(P(3)/G(5)), ...
                  G(2)*(P(4)/G(6)) ];

    end

    
    
 
