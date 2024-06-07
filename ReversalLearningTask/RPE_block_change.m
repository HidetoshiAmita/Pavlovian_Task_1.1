function BlockChange=RPE_block_change(TrialRecord)

BlockChange = false; % default = continue current block
%r = mod(round(rand(1)*10),5); % varitation of 0-4 trials
numtrials = 50;%30; % the number of trials to block change
t = TrialRecord.CurrentTrialWithinBlock; % t is the ordinal number of the current trial within the current block

if t < numtrials
  return
else
    BlockChange = true;
end
