%% Homework 1-1 (20130124 Younghoon Kim)
clear; clc;

%% Initialization
E_rest = -65; tau = 20; dt = 0.1; R= 10; E_th = -55; t(1)=0; V_m(1)=E_rest;E_spk = 45; s(1)=0; I_inj(1)=0;

%% Simulation
for i=2:10000/dt
    t(i)=t(i-1)+dt;
    I_inj(i)=0;
    if(t(i) > 5000 && t(i) <10000); I_inj(i)=1.5; end                           % Current=1.5mA for [5,10]s
    V_m(i) = V_m(i-1)+dt/tau*(E_rest-V_m(i-1)+R*I_inj(i));                      % Voltage updated
    s(i)=0;                                                                     % Initialize the 'spike or non spike array'
    if V_m(i) > E_th                                                            % If the voltage is over the threshold
        s(i)=1;                                                                 % True value returned to the 'spike or non spike array'
        V_m(i-1) = E_spk;                                                       % Membrane voltage exceeds to the action potential
        V_m(i) = E_rest;                                                        % The membrane voltage goes to the resting potential right away
    end
end

%% Plot Result
figure(1); hold on;
subplot(6,1,1);
scatter(t, s, 'filled');
ylim([0.7 1.3]);
set(gca,'YTick',[]);
set(gca,'XTick',[]);
ylabel('Spikes');
subplot(6,1,[2 4]);
plot(t, V_m);
ylabel('v [mV]');
xlabel('Time [ms]');
subplot(6,1,[5 6]);
plot(t, I_inj, 'r--');
ylabel('I [mA]');
xlabel('Time [ms]');
ylim([-0.5 2]);
