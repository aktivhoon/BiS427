%% Problem 1 - e)
clear; clc; clf;

dt=1;                                       % Time resolution [ms]
tau=1;                                      % Time constant
T=500;                                      % Time [ms]

%% Fast Spking Input Generation
V=-65*ones(length(-50:T/dt),1);             % Voltage [mV]
u=zeros(length(-50:T/dt),1);
I=zeros(length(-50:T/dt),1);                
I(51:end)=10*ones(length(I(51:end)),1);     % Current is 10mA starting from t=0ms
FS_Spk_time=zeros(length(0:T/dt),1);        % Array for Spike timing [ms]

FS=[0.04, 0.2, -65, 2];

tmp=FS; a=tmp(1); b=tmp(2); c=tmp(3); d=tmp(4);

u(1)=V(1)*b;

for it=1:T/dt+50;
    V(it+1)=(V(it)+(0.04*V(it)^2+5*V(it)+140-u(it)+I(it))*dt/tau).*(V(it)<=30)+c.*(V(it)>30);
    u(it+1)=u(it)+(a*(b*V(it+1)-u(it))*dt/tau).*(V(it)<=30)+d.*(V(it)>30);
    if it>=51                               % After first 50ms (for stabilizing the volatge
        FS_Spk_time(it-50)=(V(it)>30);      % Find spike timings
    end
end
FS_Spk_moment=find(FS_Spk_time==1);         % Moment where spike is generated [ms]

%% Bursting Input Generation
V=-65*ones(length(-50:T/dt),1);             % Voltage [mV]
u=zeros(length(-50:T/dt),1);
I=zeros(length(-50:T/dt),1);                
I(51:end)=10*ones(length(I(51:end)),1);     % Current is 10mA starting from t=0ms
Bur_Spk_time=zeros(length(0:T/dt),1);       % Array for Spike timing [ms]

Bur=[0.02, 0.2, -50, 2.5];

tmp=Bur; a=tmp(1); b=tmp(2); c=tmp(3); d=tmp(4);

u(1)=V(1)*b;

for it=1:T/dt+50;
    V(it+1)=(V(it)+(0.04*V(it)^2+5*V(it)+140-u(it)+I(it))*dt/tau).*(V(it)<=30)+c.*(V(it)>30);
    u(it+1)=u(it)+(a*(b*V(it+1)-u(it))*dt/tau).*(V(it)<=30)+d.*(V(it)>30);
    if it>=51                               % After first 50ms (for stabilizing the volatge
        Bur_Spk_time(it-50)=(V(it)>30);     % Find spike timings
    end
end
Bur_Spk_moment=find(Bur_Spk_time==1);       % Moment where spike is generated [ms]

%% Currrent Generation
tau=8; A=21;                                % Time constant and amplitude of the current
Dec_exp = @(delta_t) A.*exp(-delta_t/tau);  % Generate an exponential current
I_FS=zeros(length(0:T/dt),1);
I_Bur=zeros(length(0:T/dt),1);
for it=1:length(FS_Spk_moment)              % Make somatic current for fast spiking input
    moment=FS_Spk_moment(it);
    I_FS(moment:end)=I_FS(moment:end)+Dec_exp(0:(length(FS_Spk_time)-moment))';
end
for it=1:length(Bur_Spk_moment)             % Make somatic current for bursting input
    moment=Bur_Spk_moment(it);
    I_Bur(moment:end)=I_Bur(moment:end)+Dec_exp(0:(length(Bur_Spk_time)-moment))';
end
                                            % Plot Current
figure(1); subplot(2,1,1); plot(0:T/dt, I_FS);
xlabel('Time[ms]','FontSize',12); ylabel('Current[mA]','FontSize',12); ylim([0 50]);
title('Somatic current for Fast Spiking input','FontSize',14);
subplot(2,1,2); plot(0:T/dt, I_Bur);
xlabel('Time[ms]','FontSize',12); ylabel('Current[mA]','FontSize',12); ylim([0 50]);
title('Somatic current for Bursting input','FontSize',14);
%% Fast Spiking Response
V=-65*ones(length(-50:T/dt),1);             % Voltage [mV]
u=zeros(length(-50:T/dt),1);
I=zeros(length(-50:T/dt),1);                
I(51:end)=I_FS;                             % Current is 10mA starting from t=0ms

Neuron=[1, 0.08, -65, 2];

tmp=Neuron; a=tmp(1); b=tmp(2); c=tmp(3); d=tmp(4);

u(1)=V(1)*b;

for it=1:T/dt+50;
    V(it+1)=(V(it)+(0.04*V(it)^2+5*V(it)+140-u(it)+I(it))*dt/tau).*(V(it)<=30)+c.*(V(it)>30);
    u(it+1)=u(it)+(a*(b*V(it+1)-u(it))*dt/tau).*(V(it)<=30)+d.*(V(it)>30);
    if it>=51                               % After first 50ms (for stabilizing the volatge
        Bur_Spk_time(it-50)=(V(it)>30);     % Find spike timings
    end
end

V_FS=V(51:end);                             % Only obtain V(t) where t>0
u_FS=u(51:end);                             % Only obtain u(t) where t>0

%% Bursting
V=-65*ones(length(-50:T/dt),1);             % Voltage [mV]
u=zeros(length(-50:T/dt),1);
I=zeros(length(-50:T/dt),1);                
I(51:end)=I_Bur;                            % Current is 10mA starting from t=0ms

u(1)=V(1)*b;

for it=1:T/dt+50;
    V(it+1)=(V(it)+(0.04*V(it)^2+5*V(it)+140-u(it)+I(it))*dt/tau).*(V(it)<=30)+c.*(V(it)>30);
    u(it+1)=u(it)+(a*(b*V(it+1)-u(it))*dt/tau).*(V(it)<=30)+d.*(V(it)>30);
    if it>=51                               % After first 50ms (for stabilizing the volatge
        Bur_Spk_time(it-50)=(V(it)>30);     % Find spike timings
    end
end

V_Bur=V(51:end);                            % Only obtain V(t) where t>0
u_Bur=u(51:end);                            % Only obtain u(t) where t>0

%% Plot Result
                                            % Plot time-voltage graph for fast spiking and bursting case
figure(2); subplot(2,1,1); plot(0:T/dt,V_FS);
title('Neuron with Input from Fast Spiking','FontSize',14);
xlabel('Time[ms]','FontSize',12); ylabel('Voltage[mV]','FontSize',12);
ylim([-80 50]); set(gca, 'ytick', -50:50:50);
subplot(2,1,2); plot(0:T/dt,V_Bur);
title('Neuron with Input from Bursting','FontSize',14);
xlabel('Time[ms]','FontSize',12); ylabel('Voltage[mV]','FontSize',12);
ylim([-80 50]); set(gca, 'ytick', -50:50:50);
                                            % Plot time-u graph for fast spiking and bursting case
figure(3); subplot(2,1,1); plot(0:T/dt,u_FS);
title('Neuron with Input from Fast Spiking','FontSize',14);
xlabel('Time[ms]','FontSize',12); ylabel('u','FontSize',12);
subplot(2,1,2); plot(0:T/dt,u_Bur);
title('Neuron with Input from Bursting','FontSize',14);
xlabel('Time[ms]','FontSize',12); ylabel('u','FontSize',12);