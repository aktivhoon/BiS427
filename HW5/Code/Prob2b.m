%% HW 5 - Problem 2b
clear; clc; clf;

%% Declare the pre-, post-synaptic spike train
r=20;                                                                               % Firing Rate
time_resol=0.001;                                                                   % Time resolution
p=r*time_resol;                                                                     % Time resolution normalized
N=2; T=10;                                      
spk_arr=(rand(T/time_resol+1,N)<p);                                                 % Post, pre stimulus spike trains
spk_arr=double(spk_arr);                                                            % Transit spike array from logical to double

pre_spk=spk_arr(:,1);
post_spk=spk_arr(:,2);
Time=linspace(0,T,T/time_resol+1)';

%% Process with the spike train
pre_spk_time=find(pre_spk==1);                                                      % Find time where pre-synaptic spike occurs [ms]
post_spk_time=find(post_spk==1);                                                    % Find time where post-synaptic spike occures [ms]
delta_pre=[]; update_pre=[];
for it=1:length(pre_spk_time)
    delta_all=post_spk_time-pre_spk_time(it);                                       % Relative post-synaptic spike time to pre-synaptic spike time [ms]
    if sum(delta_all<0 & delta_all>-100)~=0
        update_pre=[update_pre; pre_spk_time(it)];                                  % Update time is the time when pre-synaptic spike occurs [ms]
        delta_pre=[delta_pre; max(delta_all(find(delta_all<0)))];
    end
end
delta_post=[]; update_post=[];
for it=1:length(post_spk_time)
    delta_all=post_spk_time(it)-pre_spk_time;                                       % Relative post-synaptic spike time to pre-synaptic spike time [ms]
    if sum(delta_all<100 & delta_all>=0)~=0
        update_post=[update_post; post_spk_time(it)];
        delta_post=[delta_post; min(delta_all(find(delta_all>=0)))];
    end
end

update_time=[update_pre; update_post];                                              % Obtain the updating time
delta_t=[delta_pre; delta_post];                                                    % Obtain the delta_t at that moment

d_EPSC=zeros(length(post_spk),1);
EPSC=ones(length(d_EPSC)+1,1);
EPSC(1)=1;

merge=[update_time delta_t];
[Y,I]=sort(merge(:,1));
sort_merge=merge(I,:);                                                              % Sort delta_t based on update time
update_time=sort_merge(:,1);
delta_t=sort_merge(:,2);

for jt=1:length(update_time)
    index=update_time(jt);
    d_EPSC(index)=STDP(10,10,delta_t(jt))/100;                                      % Obtain delta EPSC value using delta_t
end

%% Simulate the EPSC
for jt=1:length(update_time)
    index=update_time(jt);
    tmp_dEPSC=STDP(10,10,delta_t(jt))/100;
    EPSC_min=0; a_p=1; a_m=1;
    const=(tmp_dEPSC>0).*a_p+(tmp_dEPSC<0).*a_m;
    if EPSC(index)+tmp_dEPSC>EPSC_min
        d_EPSC(index)=const*tmp_dEPSC;
    end
    if EPSC(index)+tmp_dEPSC<=EPSC_min                                              % EPSC cannot be less than 0
        d_EPSC(index)=0;
    end
    if jt~=length(update_time)
        EPSC(index+1:update_time(jt+1))=EPSC(index)+d_EPSC(index);                  % Calculate the EPSC
    end
    if jt==length(update_time)
        EPSC(index+1:end)=EPSC(index)+d_EPSC(index);
    end
end

EPSC_ratio=ones(length(d_EPSC),1);                                                  % Obtain delta EPSC_ratio (look at the word file for details)
for it=1:length(d_EPSC);
    EPSC_ratio(it)=EPSC(it+1)/EPSC(it);
end

%% Raster Plot & delta EPSC plot
figure(1);
subplot(8,1,[1 2]);
hold on;
spk=spk_arr.*2-1;
[n,trial]=find(spk==1);
for it=1:length(n)
    plot([n(it)*time_resol n(it)*time_resol],[trial(it)-0.4 trial(it)+0.4], 'k', 'Linewidth',1.2);
end
xlim([0 T])
ylim([0 N+1])
set(gca,'Ytick',[]);
hold off;
title('Spike train (bottom: pre, up: post)','FontSize',14);
xlabel('Time[s]','FontSize',12);
ylabel('Neuron','FontSize',12);
subplot(8,1,[4 8]);
title('EPSC','FontSize',14);
hold on;
plot(linspace(0,T,length(post_spk)),d_EPSC);
plot(update_time/1000,d_EPSC(update_time),'r*');
xlim([0 T]); ylim([-1.2 1.2]);
xlabel('Time [ms]','FontSize',12); ylabel('\Delta EPSC(ratio to initial value)','FontSize',12);
hold off;

%% Raster Plot & delta EPSC_ratio plot
figure(2);
subplot(8,1,[1 2]);
hold on;
spk=spk_arr.*2-1;
[n,trial]=find(spk==1);                                                                                 % Find spike regions
for it=1:length(n)
    plot([n(it)*time_resol n(it)*time_resol],[trial(it)-0.4 trial(it)+0.4], 'k', 'Linewidth',1.2);      % Raster plot the spikes
end
xlim([0 T])
ylim([0 N+1])
set(gca,'Ytick',[]);
hold off;
title('Spike train (bottom: pre, up: post)','FontSize',14);
xlabel('Time[s]','FontSize',12);
ylabel('Neuron','FontSize',12);
subplot(8,1,[4 8]);
title('EPSC','FontSize',14);
hold on;
plot(linspace(0,T,length(post_spk)),EPSC_ratio);
plot(find(EPSC_ratio~=1)/1000,EPSC_ratio(find(EPSC_ratio~=1)),'r*');
xlim([0 T]); ylim([0 max(EPSC_ratio)]);
xlabel('Time [ms]','FontSize',12); ylabel('\Delta EPSC(EPSC_c_r_r_e_n_t / EPSC_p_r_e_v_i_o_u_s)','FontSize',12);
hold off;