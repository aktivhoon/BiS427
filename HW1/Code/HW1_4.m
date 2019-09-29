%% Homework 1-4 (20130124 Younghoon Kim)
clear; clc;

%% Initialization
E_rest = -65; tau = 20; dt = 0.1; R= 10; E_th = -55; E_spk = 45; 
N=20; I_rand = 1+0.01*randn(N,100000); I_inj = zeros(20,100000);
t = zeros(1,100000); s = zeros(N,10000); V_m = zeros(N,100000)-65;
rand_th = 2*randn(N,1);                                                             % Generate a random noise for each trial's threshold value.
                                                                                    % (the standard deviation is 2mV)
%% Simulation
for i=2:10000/dt
    t(i)=t(i-1)+dt;
    if(t(i) > 5000 && t(i) <10000); I_inj(:,i)=1; end                               % Again, I(t)=1mA for t=[5,10]s
    V_m(:,i) = V_m(:,i-1)+dt/tau*(E_rest-V_m(:,i-1)+R*(I_inj(:,i)+I_rand(:,i)));    % Update the voltage value
    s(:,i) = 0;                                                                     % Initialize the spike boolean array
    for j=1:N                                                                       % For each trial
        if V_m(j,i) > E_th + rand_th(j)                                             % if the voltage is over the theshold,
            V_m(j,i-1) = E_spk;                                                     % the voltage exceeds to generate an action potential
            s(j,i) = 1;                                                             % and the spike boolean array is filled up with '1'
            V_m(j,i) = E_rest;                                                      % Then, the voltage is dropped back to resting potential.
        end
    end
end
[I,J] = find(s == 1);

%% Plot Result
figure(3);
hold on;
scatter(J,I,[],I,'.');                                                              % Scatter plot all spike times. The y axis is the trial number
colormap lines;                                                                     % Give them a color that we selected
ylim([0.5 20.5]);
ylabel('Trial');
xlabel('Time [ms]');