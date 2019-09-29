%% HW 5 - Problem 1c
clear; clc; clf;

r=20;                                   % Firing Rate
time_resol=0.001;                       % Time resolution (1ms)
p=r*time_resol;
N=10;                                   % Number of trials
T=1;                                    % Length of time (s)
spk_arr=(rand(T/time_resol,N)<p);
spk_arr=double(spk_arr);

%% Obtain PSTH
width=100;                              % Width of the bin (ms)
[PSTH, num_bin]=O_PSTH(spk_arr,width);
tmp=histogram(PSTH,'Normalization','probability','BinWidth',1);

%% Plot P(n)
n=tmp.BinEdges(1:end-1);
P_n=tmp.Values;
bar(n,P_n,'FaceColor',[0 0.3 0.5]); hold on;
plot(n,poisspdf(n,mean2(PSTH)),'r*-');
xlabel('Number of spikes in bin','FontSize',12); ylabel('Probability','FontSize',12); title('P(n)','FontSize',14);
ylim([0 1.5*max(P_n)]); xlim([min(n)-0.5 max(n)+0.5]); legend('P(n)', 'Poisson');

%% Obtain S(n)
P_n_ex=P_n(P_n~=0);                     % Prevent log(0) to be calculated
S=sum(-P_n_ex.*log2(P_n_ex));
num_spk=length(find(spk_arr==1))/N;
S_per_spk=S/num_spk;
fprintf('Total entropy is: %f\n', S);
fprintf('Entropy per spike is: %f\n', S_per_spk);

%% Obtain Sterling's approximated entropy
S_theor=log2(mean2(PSTH))/2+log2(2*pi)/2;
fprintf('Theoretical entropy is: %f\n', S_theor);