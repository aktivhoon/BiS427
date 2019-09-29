%% HW 5 - Problem 2d (Additional session: what if pre-synaptic and post-synaptic are independent?)
clear; clc; clf;

%% Declare the pre-, post-synaptic spike train
r=20;                                                                               % Firing Rate
time_resol=0.001;                                                                   % Time resolution
p=r*time_resol;                                                                     % Time resolution normalized
N=2; T=10;
Time=linspace(0,T,T/time_resol+1)';
 
pre_spk=double((rand(T/time_resol+1,1)<p));                                         % 20Hz Poisson spike generator
post_spk=double((rand(T/time_resol+1,1)<5*time_resol));                             % 20Hz Poisson spike generator

pre_spk_time=find(pre_spk==1);
post_spk_time=find(post_spk==1);
spk_arr=[pre_spk post_spk];

%% Process with the spike train
delta_pre=[]; update_pre=[];
for it=1:length(pre_spk_time)
    delta_all=post_spk_time-pre_spk_time(it);                                       % Relative post-synaptic spike time to pre-synaptic spike time [ms]
    if sum(delta_all<0 & delta_all>-100)~=0
        update_pre=[update_pre; pre_spk_time(it)];
        delta_pre=[delta_pre; max(delta_all(find(delta_all<0)))];                   % Find the closest post-synaptic spike previous to pre-synaptic 
    end                                                                             % spike to calculate delta_t
end
delta_post=[]; update_post=[];
for it=1:length(post_spk_time)
    delta_all=post_spk_time(it)-pre_spk_time;                                       % Relative post-synaptic spike time to pre-synaptic spike time [ms]
    if sum(delta_all<100 & delta_all>=0)~=0
        update_post=[update_post; post_spk_time(it)];
        delta_post=[delta_post; min(delta_all(find(delta_all>=0)))];                % Find the closest pre-synaptic spike previous to post-synaptic 
    end                                                                             % spike to calculate delta_t
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

%% Simulate the EPSC (additive rule)
for jt=1:length(update_time)
    index=update_time(jt);
    tmp_dEPSC=STDP(10,10,delta_t(jt))/100;
    EPSC_max=3; EPSC_min=0; a_p=1; a_m=1;
    if EPSC(index)+tmp_dEPSC<EPSC_max && EPSC(index)+tmp_dEPSC>EPSC_min             % When EPSC_min < EPSC < EPSC_max
        const=(tmp_dEPSC>0).*a_p+(tmp_dEPSC<0).*a_m;
        d_EPSC(index)=tmp_dEPSC*const;
    end
    if EPSC(index)+tmp_dEPSC>=EPSC_max                                              % EPSC cannot exceed EPSC_max
        d_EPSC(index)=0;
    end
    if EPSC(index)+tmp_dEPSC<=EPSC_min                                              % EPSC cannot be smaller than EPSC_min
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

%% Plot Result
figure(1);
plot(linspace(0,T,length(EPSC)),EPSC);
xlim([0 T]); ylim([0 4]);
xlabel('Time [s]','FontSize',12); ylabel('EPSC','FontSize',12);