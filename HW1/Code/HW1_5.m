%% Homework 1-5 (20130124 Younghoon Kim)
clear; clc;

%% Initialization
E_rest = -65; tau = 20; dt = 0.1; R= 10; E_th = -55; E_spk = 45;
Spike_Rate_zero = zeros(1,20); Spike_Rate_one = zeros(1,20);
N=20; I_rand = 1+0.01*randn(N,100000);
t = zeros(1,100000); s = zeros(N,10000); V_m = zeros(N,100000)-65;
rand_th = 2*randn(N,1);                                                             % Generate a random noise for each trial's threshold value.
                                                                                    % (the standard deviation is 2mV)

%% Case 1) I_inj = 0
I_inj = zeros(20,100000);
for i=2:10000/dt
    t(i)=t(i-1)+dt;
    V_m(:,i) = V_m(:,i-1)+dt/tau*(E_rest-V_m(:,i-1)+R*(I_inj(:,i)+I_rand(:,i)));    % Update the voltage value for each trials
    s(:,i) = 0;                                                                     % Initialize the spike boolean array
    for j=1:N                                                                       % For each trial
        if V_m(j,i) > E_th + rand_th(j)                                             % if the voltage is over the threshold
            V_m(j,i-1) = E_spk;                                                     % voltage exceeds to generate an action potential
            s(j,i) = 1;                                                             % and the spike boolean is updated to '1'
            V_m(j,i) = E_rest;                                                      % Then, the voltage drops back to the resting potential
        end
    end
end
[neuron_idx,time_idx] = find(s == 1);                                               % Obtain the time index and neuron index of the spike moments.

SR_trial = zeros(1,N);
% Calculate the spike rate
for neuron=1:N
    ISI = [];
    Spike_time = time_idx(find(neuron_idx == neuron));                              % Obtain the time index for spike moments
    for time_iterative=1:length(Spike_time)-1
        ISI = [ISI; Spike_time(time_iterative+1)-Spike_time(time_iterative)];       % Find the ISI
    end
    Spike_rate = 0;
    if ~isempty(ISI)                                                                % If the neuron has any response
        Spike_rate = mean(10000./ISI);                                              % '1' in time index is same as 0.1 ms.
    end
    SR_trial(neuron) = Spike_rate;                                                  % Thus, to obtain spike rate in 1/s, 10000 should be multiplied,
end                                                                                 % and we should multiply the inverse of ISI.         
mean_zero = mean(SR_trial);   
var_zero = var(SR_trial);     

%% Case 2) I_inj = 1
I_inj = zeros(20,100000)+1;
t = zeros(1,100000); s = zeros(N,10000); V_m = zeros(N,100000)-65;

for i=2:10000/dt
    t(i)=t(i-1)+dt;                                                                 % Basically same as above:
    if(t(i) > 5000 && t(i) <10000); I_inj(:,i)=1; end                               % the only difference is the injected current.
    V_m(:,i) = V_m(:,i-1)+dt/tau*(E_rest-V_m(:,i-1)+R*(I_inj(:,i)+I_rand(:,i)));
    s(:,i) = 0;
    for j=1:N
        if V_m(j,i) > E_th + rand_th(j)
            V_m(j,i-1) = E_spk;
            s(j,i) = 1;
            V_m(j,i) = E_rest;
        end
    end
end
[neuron_idx,time_idx] = find(s == 1);

SR_trial = zeros(1,N);
% Calculate the spike rate
for neuron=1:N
    ISI = [];
    Spike_time = time_idx(find(neuron_idx == neuron));                              % Obtain the time index for spike moments
    for time_iterative=1:length(Spike_time)-1
        ISI = [ISI; Spike_time(time_iterative+1)-Spike_time(time_iterative)];       % Find the ISI
    end
    Spike_rate = 0;
    if ~isempty(ISI)                                                                % If the neuron has any response
        Spike_rate = mean(10000./ISI);                                              % '1' in time index is same as 0.1 ms.
    end
    SR_trial(neuron) = Spike_rate;                                                  % Thus, to obtain spike rate in 1/s, 10000 should be multiplied,
end                                                                                 % and we should multiply the inverse of ISI.         
mean_one = mean(SR_trial);   
var_one = var(SR_trial);     

disp('mean zero: '); disp(mean_zero);
disp('mean one: '); disp(mean_one);
disp('variance zero: '); disp(var_zero);
disp('variance one: '); disp(var_one);