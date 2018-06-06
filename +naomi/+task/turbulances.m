function turbulances(bench)
    global naomiGlobalBench
    if nargin<1; bench = naomiGlobalBench; end
    % put the DM pupill mask 
    naomi.config.pupillMask(bench, 'DM_PUPILL'); 
    [~, turbuData] = naomi.measure.turbulances(bench);
    naomi.saveData(bench, turbuData);
end