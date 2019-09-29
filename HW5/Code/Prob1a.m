%% HW 5 - Problem 1a
clear; clc; clf;

r=20;                                                                                                   % Firing Rate
time_resol=0.001;                                                                                       % Time resolution (1ms)
p=r*time_resol;
N=10;                                                                                                   % Number of trials
T=1;                                                                                                    % Length of time (s)
spk_arr=(rand(T/time_resol,N)<p);
spk_arr=double(spk_arr);

%% Raster plot the spikes
hold on;
spk=spk_arr.*2-1;
figure(1);
[n,trial]=find(spk==1);                                                                                 % Find spike regions
for it=1:length(n)
    plot([n(it)*time_resol n(it)*time_resol],[trial(it)-0.4 trial(it)+0.4], 'k', 'Linewidth',1.2);      % Raster plot the spikes
end
xlim([0 T])
ylim([0 N+1])
hold off;
xlabel('Time[s]','FontSize',12);
ylabel('Neuron #','FontSize',12);
title('Raster Plot','FontSize',14);

%% Plot PSTH
width=10;                                                                                               % Width of the bin (ms)
[PSTH, num_bin]=O_PSTH(spk_arr,width);
PSTH_avg=sum(PSTH,2)/N;
figure(2);
bar(((0:num_bin-1)+0.5)*width*time_resol,PSTH_avg);
xlim([0 T]);
xlabel('Time[s]','FontSize',12);
ylabel('Average # of spikes','FontSize',12);
title('PSTH','FontSize',14);

%% Obtain P(n)
figure(3);
tmp=histogram(PSTH,'Normalization','probability','BinWidth',1);
n=tmp.BinEdges(1:end-1);
P_n=tmp.Values;
bar(n,P_n,'FaceColor',[0 0.3 0.5]); hold on;
plot(n,poisspdf(n,mean2(PSTH)),'r*-');
xlabel('Number of spikes in bin','FontSize',12); ylabel('Probability','FontSize',12); title('P(n)','FontSize',14);
ylim([0 1]); legend('P(n)', 'Poisson');