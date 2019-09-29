%% Poisson Spike Generator
clear; clc;

N=50;                               % # of trial
fr_mean=50/1000;                    % Mean firing rate
time=0;                             % Time
T=1/fr_mean;                        % Inverse firing rate
ns=100;                             % Number of spikes to be generated
rfp=5;                              % Refractory period

%% Without refractory period
isi_id=-T.*log(rand(ns,N));         % Generation of expo. distr. ISIs
sr_id=zeros(1,N);
for it=1:N
    time=0;
    for ii=1:ns
        time=time+isi_id(ii,it);
        if(time<=1000)
            sr_id(it)=ii-1;
        end
    end
end

%% With refractory period
isi_rp=rfp-T.*log(rand(ns,N));      % Add refractory period to ISI
sr_rp=zeros(1,N);
for it=1:N
    time=0;
    for ii=1:ns
        time=time+isi_rp(ii,it);
        if(time<=1000)
            sr_rp(it)=ii;
        end
    end
end

mean_sr_id = mean(sr_id);
mean_sr_rp = mean(sr_rp);

disp('mean without rp: '); disp(mean_sr_id);
disp('mean with rp: '); disp(mean_sr_rp);