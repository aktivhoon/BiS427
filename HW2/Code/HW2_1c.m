%% Poisson Spike Generator
clear; clc;

N=2000;                                             % # of trials
T=1000;                                             % ms
r=50;                                               % # of spikes/s (constant)
p=r/1000;                                           % 1ms
sr_id=zeros(1,N);
sr_rp=zeros(1,N);

%% No refractory period
for trial=1:N
    spk=-1*ones(1,T);
    for ii=1:T
        xrand=rand(1);
        if p>xrand
            spk(ii)=1;
        end
    end
    spk_time=find(spk==1);
    fr_mean=length(spk_time)/T*1000;
    sr_id(trial)=fr_mean;
end
%% Refractory period
for trial=1:N
    spk=-1*ones(1,T);
    for ii=1:T
        xrand=rand(1);
        if p>xrand
            spk(ii)=1;
        end
    end
    for ii=1:T
        if spk(ii)==1
            for jj=1:5
                spk(ii+jj)=0;
            end
        end
    end
    spk_time=find(spk==1);
    fr_mean=length(spk_time)/T*1000;
    sr_rp(trial)=fr_mean;
end

%% Find average firing rate of models in a and b
mean_sr_id = mean(sr_id);
mean_sr_rp = mean(sr_rp);

disp('mean without rp: '); disp(mean_sr_id);
disp('mean with rp: '); disp(mean_sr_rp);