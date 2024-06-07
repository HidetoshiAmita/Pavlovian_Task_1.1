function [C,timingfile,userdefined_trialholder] = RPE_userloop(MLConfig,TrialRecord)
%%
% Reward Prediction Error (RPE) task
% Big reward -> Omission
% Initial fixation at a start cue is required
%%
    C = [];
    timingfile = 'RPE.m';
    userdefined_trialholder = '';
    persistent timing_filenames_retrieved
    if isempty(timing_filenames_retrieved)
        timing_filenames_retrieved = true;
        return
    end
%%
    % Shuffle order of conditions
    if mod(TrialRecord.CurrentTrialNumber,5) == 0%mod(TrialRecord.CurrentTrialNumber,5) == 0
        p = randperm(5,5);%p = randperm(5,5);
        save ShuffleOrder.mat p
    else        
    end
    load 'ShuffleOrder.mat' p
    condition = p(1, mod(TrialRecord.CurrentTrialNumber,5)+1);%p(1, mod(TrialRecord.CurrentTrialNumber,5)+1);

%%
    switch condition %% 40% Big, 40% Small, 20& Free  
        case 1, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(A, 0, 0, 300, 300)'}; Info.samp = 'B'; % Big A
        case 2, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(A, 0, 0, 300, 300)'}; Info.samp = 'B'; % Big A
        case 3, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(B, 0, 0, 300, 300)'}; Info.samp = 'S'; % Small B
        case 4, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(B, 0, 0, 300, 300)'}; Info.samp = 'S'; % Small B
        case 5, C = {'sqr(0.3, [1 1 1], 1, 0, 0)','pic(C, 0, 0, 0, 0)'}; Info.samp = 'F'; % Free C

    end%size: 180
    TrialRecord.setCurrentConditionInfo(Info);
    timingfile = 'RPE.m';
    %TrialRecord.NextBlock = 1;
    TrialRecord.NextCondition = condition;
end