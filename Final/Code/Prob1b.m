%% Problem 1 - b)
clear; clc; clf;

dt=1;                                       % Time resolution [ms]
tau=1;                                      % Time constant
T=500;                                      % Time [ms]
V=-65*ones(length(-50:T/dt),1);             % Voltage [mV]
u=zeros(length(-50:T/dt),1);
I=zeros(length(-50:T/dt),1);                
I(51:end)=10*ones(length(I(51:end)),1);     % Current is 10mA starting from t=0ms
Spk_time=zeros(length(0:T/dt),1);           % Array for Spike timing [ms]

Bur=[0.02, 0.2, -50, 2.5];                  % Parameters for bursting

tmp=Bur; a=tmp(1); b=tmp(2); c=tmp(3); d=tmp(4);

u(1)=V(1)*b;

for it=1:T/dt+50;
    V(it+1)=(V(it)+(0.04*V(it)^2+5*V(it)+140-u(it)+I(it))*dt/tau).*(V(it)<=30)+c.*(V(it)>30);
    u(it+1)=u(it)+(a*(b*V(it+1)-u(it))*dt/tau).*(V(it)<=30)+d.*(V(it)>30);
    if it>=51                               % After first 50ms (for stabilizing the volatge)
        Spk_time(it-50)=(V(it)>30);         % Find spike timings
    end
end

V=V(51:end);                                % Only obtain V(t) where t>0
u=u(51:end);                                % Only obtain u(t) where t>0

Spk_moment=find(Spk_time==1);               % Moment where spike is generated [ms]
ISI=zeros(length(Spk_moment)-1,1);

for it=1:length(Spk_moment)-1
    ISI(it)=Spk_moment(it+1)-Spk_moment(it);
end
%% Plot Result
figure(1);                                  % Plot time vs membrane voltage
plot(0:T/dt,V);
title('Bursting (a=0.02, b=0.2, c=-50, d=2.5)','FontSize',14);
xlabel('Time[ms]','FontSize',12); ylabel('Voltage[mV]','FontSize',12);
ylim([-80 50]); set(gca, 'ytick', -50:50:50);

Firing_Rate=length(find(Spk_time==1))*2;    % Find the mean firing rate
fprintf('The Firing Rate is %f Hz\n',Firing_Rate);

figure(2);                                  % Plot the histogram for ISI
histogram(ISI); title('ISI Histogram','FontSize',14);
xlabel('Time[ms]','FontSize',12); ylabel('Number of ISI','FontSize',12);