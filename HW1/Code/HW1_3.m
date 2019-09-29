%% Homework 1-3 (20130124 Younghoon Kim)
clear; clc;

%% Initialization
E_rest = -65; tau = 20; dt = 0.1; R= 10; E_th = -55; E_spk = 45;
Spike_Rate_zero = zeros(1,20); Spike_Rate_one = zeros(1,20);
N=20; I_rand = 1+0.01*randn(N,100000);
t = zeros(1,100000); s = zeros(N,10000); V_m = zeros(N,100000)-65;

%% Case 1) I_inj = 0
I_inj = zeros(20,100000);
for i=2:10000/dt
    t(i)=t(i-1)+dt;
    V_m(:,i) = V_m(:,i-1)+dt/tau*(E_rest-V_m(:,i-1)+R*(I_inj(:,i)+I_rand(:,i)));    % For each trial, update the volatge value
    s(:,i) = 0;                                                                     % Initialize the spike boolean array
    for j=1:N                                                                       % For each trial
        if V_m(j,i) > E_th                                                          % If the voltage is higher than the threshold,
            V_m(j,i-1) = E_spk;                                                     % voltage exceeds to the action potential
            s(j,i) = 1;                                                             % Also, the spike boolean array is filled with '1'
            V_m(j,i) = E_rest;                                                      % The voltage is dropped back to resting potential
        end
    end
end
[neuron_idx,time_idx] = find(s == 1);                                               % Attain the neuron index and time index for spike times.

ISI = [];
% Calculate the spike rate
for neuron=1:20
    Spike_time = time_idx(find(neuron_idx == neuron)); % Obtain the time index for spike moments
    for time_iterative=1:length(Spike_time)-1
        ISI = [ISI; Spike_time(time_iterative+1)-Spike_time(time_iterative)]; % Find the ISI
    end
end
Spike_rate = 10000./ISI;        % '1' in time index is same as 0.1 ms. 
mean_zero = mean(Spike_rate);   % Thus, to obtain spike rate in 1/s, 10000 should be multiplied,
var_zero = var(Spike_rate);     % and we should multiply the inverse of ISI.

%% Case 2) I_inj = 1
I_inj = zeros(20,100000)+1;
t = zeros(1,100000); s = zeros(N,10000); V_m = zeros(N,100000)-65;

for i=2:10000/dt
    t(i)=t(i-1)+dt;
    V_m(:,i) = V_m(:,i-1)+dt/tau*(E_rest-V_m(:,i-1)+R*(I_inj(:,i)+I_rand(:,i)));    % For each trial, update the volatge value
    s(:,i) = 0;                                                                     % Initialize the spike boolean array
    for j=1:N                                                                       % For each trial
        if V_m(j,i) > E_th                                                          % If the voltage is higher than the threshold,
            V_m(j,i-1) = E_spk;                                                     % voltage exceeds to the action potential
            s(j,i) = 1;                                                             % Also, the spike boolean array is filled with '1'
            V_m(j,i) = E_rest;                                                      % The voltage is dropped back to resting potential
        end
    end
end
[neuron_idx,time_idx] = find(s == 1);                                               % Attain the neuron index and time index for spike times.

ISI = [];
% Calculate the spike rate
for neuron=1:20
    Spike_time = time_idx(find(neuron_idx == neuron)); % Obtain the time index for spike moments
    for time_iterative=1:length(Spike_time)-1
        ISI = [ISI; Spike_time(time_iterative+1)-Spike_time(time_iterative)]; % Find the ISI
    end
end
Spike_rate = 10000./ISI;        % '1' in time index is same as 0.1 ms. 
mean_one = mean(Spike_rate);    % Thus, to obtain spike rate in 1/s, 10000 should be multiplied,
var_one = var(Spike_rate);      % and we should multiply the inverse of ISI.

disp('mean zero: '); disp(mean_zero);
disp('mean one: '); disp(mean_one);
disp('variance zero: '); disp(var_zero);
disp('variance one: '); disp(var_one);