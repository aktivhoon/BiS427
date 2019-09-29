%% Problem 1 - c)
clear; clc; clf;

dt=1;                                       % Time resolution [ms]
tau=1;                                      % Time constant
T=500;                                      % Time [ms]

%% Fast Spking
V=-65*ones(length(-50:T/dt),1);             % Voltage [mV]
u=zeros(length(-50:T/dt),1);
I=zeros(length(-50:T/dt),1);                
I(51:end)=10*ones(length(I(51:end)),1);     % Current is 10mA starting from t=0ms
FS_Spk_time=zeros(length(0:T/dt),1);        % Array for Spike timing [ms]

FS=[0.04, 0.2, -65, 2];                     % Parameters for fast spiking

tmp=FS; a=tmp(1); b=tmp(2); c=tmp(3); d=tmp(4);

u(1)=V(1)*b;

for it=1:T/dt+50;
    V(it+1)=(V(it)+(0.04*V(it)^2+5*V(it)+140-u(it)+I(it))*dt/tau).*(V(it)<=30)+c.*(V(it)>30);
    u(it+1)=u(it)+(a*(b*V(it+1)-u(it))*dt/tau).*(V(it)<=30)+d.*(V(it)>30);
    if it>=51                               % After first 50ms (for stabilizing the volatge
        FS_Spk_time(it-50)=(V(it)>30);      % Find spike timings
    end
end

V=V(51:end);                                % Only obtain V(t) where t>0
u=u(51:end);                                % Only obtain u(t) where t>0

FS_Spk_moment=find(FS_Spk_time==1);         % Moment where spike is generated [ms]

%% Fast Spking
V=-65*ones(length(-50:T/dt),1);             % Voltage [mV]
u=zeros(length(-50:T/dt),1);
I=zeros(length(-50:T/dt),1);                
I(51:end)=10*ones(length(I(51:end)),1);     % Current is 10mA starting from t=0ms
Bur_Spk_time=zeros(length(0:T/dt),1);       % Array for Spike timing [ms]

Bur=[0.02, 0.2, -50, 2.5];                  % Parameters for bursting

tmp=Bur; a=tmp(1); b=tmp(2); c=tmp(3); d=tmp(4);

u(1)=V(1)*b;

for it=1:T/dt+50;
    V(it+1)=(V(it)+(0.04*V(it)^2+5*V(it)+140-u(it)+I(it))*dt/tau).*(V(it)<=30)+c.*(V(it)>30);
    u(it+1)=u(it)+(a*(b*V(it+1)-u(it))*dt/tau).*(V(it)<=30)+d.*(V(it)>30);
    if it>=51                               % After first 50ms (for stabilizing the volatge)
        Bur_Spk_time(it-50)=(V(it)>30);     % Find spike timings
    end
end

V=V(51:end);                                % Only obtain V(t) where t>0
u=u(51:end);                                % Only obtain u(t) where t>0

Bur_Spk_moment=find(Bur_Spk_time==1);       % Moment where spike is generated [ms]

%% Raster Plot
figure(1);
hold on;
spk_arr=FS_Spk_time;
spk=spk_arr.*2-1;
n=find(spk==1);                             % Find spike regions
for it=1:length(n)
    p1=plot([n(it) n(it)],[0.6 1.4], 'color',[1 0 0.4], 'Linewidth',1.2);
end

spk_arr=Bur_Spk_time;
spk=spk_arr.*2-1;
n=find(spk==1);                             % Find spike regions
for it=1:length(n)
    p2=plot([n(it) n(it)],[1.6 2.4], 'color',[0 0.6 1], 'Linewidth',1.2);
end
legend([p1,p2],'Fast Spiking', 'Bursting');
xlim([0 T]);
ylim([0 3]);
title('Raster Plot','FontSize',14);
xlabel('Time[ms]','FontSize',12);
set(gca,'ytick',[]);

%% Plot accumulated histogram
width=10;                                   % Width of the bin (ms)
                                            % Find number of spikes for the given time bin
[PSTH_FS, num_bin]=O_PSTH(FS_Spk_time,width);
[PSTH_Bur, num_bin]=O_PSTH(Bur_Spk_time,width);

figure(2);                                  % Plot the accumulated number of spike bar graph
hold on;
vals_FS=repelem(((0:num_bin-1)+0.5)*width,PSTH_FS);
histogram(vals_FS,'Normalization','cumcount','BinWidth',width,'BinLimits',[0 500]);
vals_Bur=repelem(((0:num_bin-1)+0.5)*width,PSTH_Bur);
histogram(vals_Bur,'Normalization','cumcount','BinWidth',width,'BinLimits',[0 500]);
xlim([0 500]);
xlabel('Time[ms]','FontSize',12);
ylabel('# of spikes','FontSize',12);
title('Accumulated number of spikes','FontSize',14);
legend('Fast Spiking', 'Bursting');
hold off;