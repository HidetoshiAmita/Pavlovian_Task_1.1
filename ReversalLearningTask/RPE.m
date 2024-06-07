hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);'); % stop the task immediately
hotkey('r', 'goodmonkey(reward_dur, ''juiceline'', MLConfig.RewardFuncArgs.JuiceLine, ''eventmarker'', 14, ''nonblocking'', 1);');   % manual reward
bhv_code(10,'Fix Cue', 20,'Target', 30,'Fix  off', 40,'Go', 50,'Reward', 60,'NoReward');  % behavioral codes

%%
% Reward Prediction Error (RPE) task
% Big reward -> Temporal Omission

%%
target = 2;

% set the properties of the adapters
% in milliseconds
target_duration = 500;
delay_time = 1000;
% fixation window (in degrees):
fix_radius = 20; % Fixation window 8
hold_radius = 80; % No fixation is required on target

% sound 
[waveform,Fs] = audioread('correct_sound.wav'); % Correct-Reward sound
[waveform2,Fs2] = audioread('error_sound.wav');  % Error sound
[waveform3,Fs3] = audioread('TikSnippet.wav'); % Correct-No reward sound

%%
                  
% scene 1: target
fix1 = SingleTarget(eye_);
fix1.Target = target;
fix1.Threshold = hold_radius;
wth1 = WaitThenHold(fix1);
wth1.WaitTime = 0;            % We already knows the fixation is acquired, so we don't wait.
wth1.HoldTime = target_duration;
scene1 = create_scene(wth1,target);

% scene 2: CS1
trig = TriggerTimer(null_);
trig.Delay = 0;
ttl = TTLOutput(trig);
ttl.Trigger = true;
ttl.Port = 1;
tc = TimeCounter(ttl);
tc.Duration = 10; % The TTL will last for the 2nd half of the 100-ms period
scene2= create_scene(tc);

% scene 3: CS2
trig = TriggerTimer(null_);
trig.Delay = 0;
ttl = TTLOutput(trig);
ttl.Trigger = true;
ttl.Port = 2;
tc = TimeCounter(ttl);
tc.Duration = 10; % The TTL will last for the 2nd half of the 100-ms period
scene3= create_scene(tc);

% scene 5: 0% CS
trig = TriggerTimer(null_);
trig.Delay = 0;
ttl = TTLOutput(trig);
ttl.Trigger = true;
ttl.Port = 4;
tc = TimeCounter(ttl);
tc.Duration = 10; % The TTL will last for the 2nd half of the 100-ms period
scene4= create_scene(tc);

% scene 5: 50% CS - Rew
trig = TriggerTimer(null_);
trig.Delay = 0;
ttl = TTLOutput(trig);
ttl.Trigger = true;
ttl.Port = 5;
tc = TimeCounter(ttl);
tc.Duration = 10; % The TTL will last for the 2nd half of the 100-ms period
scene5= create_scene(tc);


%%
% TASK:
idle(delay_time); % 1 sec before task onset
% scene 1: target
run_scene(scene1, 20);     % Run the second scene (eventmarker 20)
if ~wth1.Success          % If the WithThenHold failed,
    idle(0);              %     that means the subject didn't keep fixation on the target.
    trialerror(3);        % So this is the "break fixation (3)" error.
    sound(waveform2,Fs)   % Error sound
    return
end

% scene 2: TTL signal for conditions
if Info.samp == 'B' % High value (100% reward)
    run_scene(scene2,30)
elseif Info.samp == 'S' % Middle value (50% reward)
    run_scene(scene3,30)
else
end

idle(delay_time);  % clear screen

% Define condition for reward type
BlockSwitch=mod(TrialRecord.CurrentBlockCount,2);
if Info.samp == 'B' && BlockSwitch==1% Big reward block
    sound(waveform,Fs) % Correct sound
    trialerror(0); % correct code
    goodmonkey(100, 'juiceline',1, 'numreward',3, 'pausetime',500, 'eventmarker',50); % 150 ms of juice x 3
    run_scene(scene4,70)
elseif Info.samp == 'B' && BlockSwitch==0% Temporal omission block
%     idle(1500);%Temporal omission
    sound(waveform,Fs) % Correct sound
    trialerror(0); % correct code
    goodmonkey(0, 'juiceline',1, 'numreward',0, 'pausetime',500, 'eventmarker0',60); % 120 ms of juice x 3
    run_scene(scene5,70)
elseif Info.samp == 'S' && BlockSwitch==1 % Small reward
    sound(waveform,Fs) % Correct sound
    trialerror(0); % correct code
    goodmonkey(0, 'juiceline',1, 'numreward',0, 'pausetime',500, 'eventmarker',50); % 50 ms of juice x 1
    run_scene(scene5,70)
    %goodmonkey(50, 'juiceline',1, 'numreward',1, 'pausetime',500, 'eventmarker',50); % 120 ms of juice x 1
elseif Info.samp == 'S' && BlockSwitch==0 % Small to Big
    sound(waveform,Fs) % Correct sound
    trialerror(0); % correct code
    goodmonkey(100, 'juiceline',1, 'numreward',3, 'pausetime',500, 'eventmarker',50); % 150 ms of juice x 3
    run_scene(scene4,70)
elseif Info.samp == 'F' % Free reward
    sound(waveform,Fs) 
    trialerror(0); % correct code
    goodmonkey(100, 'juiceline',1, 'numreward',3, 'pausetime',500, 'eventmarker',60); % Free reward
else
end

% ITI after task
var_time=2000+random('Normal',0,1)*2000; %var_time=random('Normal',0,1)*4000-1000;
idle(var_time)