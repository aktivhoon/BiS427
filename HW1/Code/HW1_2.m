%% Homework 1-2 (20130124 Younghoon Kim)
clear; clc;

%% Initialization
E_rest = -65; tau = 20; dt = 0.1; R= 10; E_th = -55; E_spk = 45; N=20; 
I_rand = 1+0.01*randn(N,100000); 
I_inj = zeros(20,100000);
t = zeros(1,100000); 
s = zeros(N,10000); 
V_m = E_rest*ones(N,100000);

%% Simulation

for i=2:10000/dt
    t(i)=t(i-1)+dt;                                                                 % Iterative time
    if(t(i) > 5000 && t(i) <10000); I_inj(:,i)=1; end                               % Current=1.5mA for [5,10]s
    V_m(:,i) = V_m(:,i-1)+dt/tau*(E_rest-V_m(:,i-1)+R*(I_inj(:,i)+I_rand(:,i)));    % Voltage updated
    s(:,i) = 0;                                                                     % Initialize the 'spike or non spike array'
    for j=1:N                                                                       % For N trials
        if V_m(j,i) > E_th                                                          % If the voltage is over the threshold
            V_m(j,i-1) = E_spk;                                                     % True value returned to the 'spike or non spike array'
            s(j,i) = 1;                                                             % Membrane voltage exceeds to the action potential
            V_m(j,i) = E_rest;                                                      % The membrane voltage goes to the resting potential right away
        end
    end
end

[I,J] = find(s == 1);                                                               % I would be the 'neuron index', and J would be the 'time index'

%% Plot Result
figure(2);
hold on;
scatter(J,I,[],I,'.');                                                              % Scatter plot all spike times. The y axis is the trial number
colormap lines;                                                                     % Colormap selected.
ylim([0.5 20.5]);
ylabel('Trial');
xlabel('Time [ms]');