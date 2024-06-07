hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);'); % stop the task immediately
hotkey('r', 'goodmonkey(reward_dur, ''juiceline'', MLConfig.RewardFuncArgs.JuiceLine, ''eventmarker'', 14, ''nonblocking'', 1);');   % manual reward
bhv_code(10,'Fix Cue', 20,'Target', 30,'Fix  off', 40,'Go', 50,'Reward', 60,'NoReward');  % behavioral codes

%%
% Pavlovian conditioning using fractal CS  associated with reward probability
% 100%-50%-0% reward CS
% Initial fixation at a start cue is required
%%
target = 2;

% set the properties of the adapters
% in milliseconds
wait_for_fix = 5000;
initial_fix = 500;%1000
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


%%
% TASK:
idle(delay_time); % 1 sec before task onset
% scene 2: target
run_scene(scene1, 20);     % Run the first scene (eventmaker 10)
if ~wth1.Success          % If the WithThenHold failed,
    idle(0);              %     that means the subject didn't keep fixation on the target.
    trialerror(3);        % So this is the "break fixation (3)" error.
    sound(waveform2,Fs)   % Error sound
    return
end

idle(delay_time);  % clear screen

% Define condition for reward type
if Info.samp == 'H' % High value (100% reward)
    sound(waveform,Fs) % Correct sound
    trialerror(0); % correct code
    goodmonkey(100, 'juiceline',1, 'numreward',3, 'pausetime',500, 'eventmarker',50); % 100 ms of juice x 1
elseif Info.samp == 'M' % Middle value (50% reward)
        
    if rand(1)<0.5 % 50% reward prob
        sound(waveform,Fs) % Correct-reward sound
        trialerror(0); % correct code
        goodmonkey(100, 'juiceline',1, 'numreward',3, 'pausetime',500, 'eventmarker',50); % 100 ms of juice x 1
    else
        sound(waveform3,Fs3) % Correct-no reward sound
        trialerror(0); % correct code
        goodmonkey(100, 'juiceline',1, 'numreward',0, 'pausetime',500, 'eventmarker',60); % No reward (100 ms)
    end
elseif Info.samp == 'L' % Low value (0% reward)
    sound(waveform3,Fs3) % Correct-no reward sound
    trialerror(0); % correct code
    goodmonkey(100, 'juiceline',1, 'numreward',0, 'pausetime',500, 'eventmarker',60); % No reward (100 ms)
else
end

% ITI after task
var_time=random('Normal',0,1)*3000-1000;
idle(var_time)