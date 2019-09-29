%% Problem 1 - d)
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

V=V(51:end);                                % Only obtain V(t) where t>0
u=u(51:end);                                % Only obtain u(t) where t>0

FS_Spk_moment=find(FS_Spk_time==1);         % Moment where spike is generated [ms]

%% Fast Spking
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

V=V(51:end);                                % Only obtain V(t) where t>0
u=u(51:end);                                % Only obtain u(t) where t>0

Bur_Spk_moment=find(Bur_Spk_time==1);       % Moment where spike is generated [ms]

%% Find optimal width for firing estimation
N=100;                                      % Number of slices for width
Width_train=linspace(0.0001,1,N);           % Vary the width of the Kernel window
Cw_FS=zeros(1,N);
Cw_Bur=zeros(1,N);
for jt=1:2
    tmp=[];
    if jt==1
        spk_time=FS_Spk_moment;
    end
    if jt==2
        spk_time=Bur_Spk_moment;
    end
    for it=1:N
        delta=Width_train(it);
        time_rel=repmat(spk_time,1,length(spk_time))-repmat(spk_time',length(spk_time),1);
        time_rel=time_rel/1000;
        sc_term=sum(sum(G_kernel(delta,time_rel)));
        int_range=0:0.001:5;
        th_term=0;
        for s=int_range
            th_term=th_term+sum(sum(G_kernel(delta,s).*G_kernel(delta,s+time_rel))).*0.001;
        end
                                            % Cost function derived using MISE
        tmp(it)=2/sqrt(2*pi)/delta*length(spk_time)-2*sc_term+th_term;
    end
    if jt==1
        Cw_FS=tmp;
    end
    if jt==2
        Cw_Bur=tmp;
    end
end

[Cmin_FS idx_FS]=min(Cw_FS);
delta_FS=Width_train(idx_FS);
[Cmin_Bur idx_Bur]=min(Cw_Bur);
delta_Bur=Width_train(idx_Bur);

%% Plot cost function
figure(1);
subplot(1,2,1); hold on;
plot(Width_train,Cw_FS); plot(delta_FS, Cmin_FS, 'r*');
ylim([-Inf 100]); title('Fast Spiking'); xlabel('width[s]'); ylabel('C_w');
subplot(1,2,2); hold on;
plot(Width_train,Cw_Bur); plot(delta_Bur, Cmin_Bur, 'r*');
ylim([-Inf 100]); title('Bursting'); xlabel('width[s]'); ylabel('C_w');

%% Plot Result (Raster plot & Instantaneous Firing Rate)
sigma=delta_FS; range=-3*sigma:0.001:3*sigma;
Filter_FS=1/sigma/sqrt(2*pi).*exp(-range.^2/2/sigma.^2);

sigma=delta_Bur; range=-3*sigma:0.001:3*sigma;
Filter_Bur=1/sigma/sqrt(2*pi).*exp(-range.^2/2/sigma.^2);

Smooth_FS=conv(FS_Spk_time, Filter_FS, 'same');
Smooth_Bur=conv(Bur_Spk_time, Filter_Bur, 'same');

figure(2);
subplot(4,1,1);
hold on;
spk_arr=FS_Spk_time;
spk=spk_arr.*2-1;
n=find(spk==1);
for it=1:length(n)
    p1=plot([n(it) n(it)],[0.6 1.4], 'color',[1 0 0.4], 'Linewidth',1.2);
end

spk_arr=Bur_Spk_time;
spk=spk_arr.*2-1;
n=find(spk==1);
for it=1:length(n)
    p2=plot([n(it) n(it)],[1.6 2.4], 'color',[0 0.6 1], 'Linewidth',1.2);
end
xlim([0 T])
ylim([0 3])
hold off;
title('Raster Plot','FontSize',14);
set(gca,'ytick',[]);
set(gca,'xtick',[]);
grid on;

subplot(4,1,[2 3 4]); hold on;
p1=plot(0:T/dt,Smooth_FS,'Linewidth',2,'color',[1 0 0.4]); hold on;
p2=plot(0:T/dt,Smooth_Bur,'Linewidth',2,'color',[0 0.6 1]); hold on;
legend([p1,p2],'Fast Spiking', 'Bursting');
title('Instantaneous Firing Rate','FontSize',14);
xlim([0 T]); xlabel('Time[ms]','FontSize',12); ylabel('Spike Rate[Hz]','FontSize',12);
grid on;