function IFM(bench, force)
%MEASUREIFM Measure a IFM, clean it and load it to the bench and save it
%  IFM qc plot are also saved
global naomiGlobalBench
if nargin<1 || isempty(bench); bench = naomiGlobalBench; end;
if nargin<2; force=0; end
if (~bench.has('wfs'))
    msgbox({'The wave front sensor is not started'},  'Error','error');
end
if (~bench.has('dm'))
    msgbox({'The dm is not started'},  'Error','error');
end

if ~force
    if (bench.has('environment'))
        [test, explanation] = bench.environment.isReadyToCalib;
        if ~test
            answer = questdlg({explanation, 'Do you want to continue ?'}, ...
                               'Temperature Check', ...
                               'Cancel','Continue', 'Cancel');
            switch answer
            case 'Continue'
              bench.log('NOTICE: continue calibration without optnimal conditions');
            otherwise
              error('IFM interupted by user. Calibration condition not met');
            end
        end 
    else
         answer = questdlg( {'Environment not started', 'Cannot check temperature', 'Do you want to continue ?'}, ...
                               'Temperature Check', ...
                               'Cancel','Continue', 'Cancel');
            switch answer
            case 'Continue'
                  bench.log('NOTICE: continue calibration without optnimal conditions');
            otherwise
                  error('IFM interupted by user. Calibration condition not met');
            end
    end
end

% remove any mask 
naomi.config.mask(bench, []);
startDate = now;
IFMData = naomi.measure.IFM(bench);
% save the start date as the DATEOB this allows to make sure that 
% all the derived product will have the same file name time stamp (same 'ob') 
IFMData.setKey(naomi.KEYS.DATEOB, startDate, naomi.KEYS.DATEOBc);

naomi.task.afterIFM(bench, IFMData);
end



