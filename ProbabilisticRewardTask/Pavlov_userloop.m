function [C,timingfile,userdefined_trialholder] = Pavlov_userloop(MLConfig,TrialRecord)
%%
% Pavlovian conditioning with fractal CS (reward probability)
% 100%-50%-0% reward CS
%%
    C = [];
    timingfile = 'Pavlov.m';
    userdefined_trialholder = '';
    persistent timing_filenames_retrieved
    if isempty(timing_filenames_retrieved)
        timing_filenames_retrieved = true;
        return
    end
%%
    % Shuffle order of conditions
    if mod(TrialRecord.CurrentTrialNumber,6) == 0
        p = randperm(6,6);
        save ShuffleOrder.mat p
    else        
    end
    load 'ShuffleOrder.mat' p
    condition = p(1, mod(TrialRecord.CurrentTrialNumber,6)+1);

%%
    switch condition
        case 1, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(imageA, 0, 0, 300, 300)'}; Info.samp = 'H'; % high
        case 2, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(imageB, 0, 0, 300, 300)'}; Info.samp = 'M'; % middle
        case 3, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(imageC, 0, 0, 300, 300)'}; Info.samp = 'L'; % low
        case 4, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(imageD, 0, 0, 300, 300)'}; Info.samp = 'H'; % high
        case 5, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(imageE, 0, 0, 300, 300)'}; Info.samp = 'M'; % middle
        case 6, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(imageF, 0, 0, 300, 300)'}; Info.samp = 'L'; % low
    end%size: 180
    TrialRecord.setCurrentConditionInfo(Info);
    timingfile = 'Pavlov.m';
    TrialRecord.NextBlock = 1;
    TrialRecord.NextCondition = condition;


end