%% HW 5 - Problem 1d (Plot N vs. Entropy)
clear; clc; clf;

r_ar=linspace(0,350,300);
time_resol=0.001;                                           % Time resolution (1ms)
p_ar=r_ar*time_resol;
N=1000;                                                     % Number of trials
T=1;                                                        % Length of time (s)
N_ar=zeros(length(r_ar),1);

%% Obtain P(n) and entropy
S=zeros(length(r_ar),1);
S_theor=zeros(length(r_ar),1);
for xt=1:length(r_ar)
    p=p_ar(xt);
    spk_arr=(rand(T/time_resol,N)<p);
    spk_arr=double(spk_arr);

    width=100;                                              % Width of the bin (ms)
    [PSTH, num_bin]=O_PSTH(spk_arr,width);
    tmp=histogram(PSTH,'Normalization','probability','BinWidth',1);

    P_n=tmp.Values;
    P_n_ex=P_n(P_n~=0);                                     % Obtained P(n)
    N_ar(xt)=mean2(PSTH);
    S(xt)=sum(-P_n_ex.*log2(P_n_ex));                       % P(n) based entropy
    S_theor(xt)=log2(mean2(PSTH))/2+log2(2*pi)/2;           % Sterling's approximation entropy
end

clf;
merge=[N_ar S S_theor];                                     % Sort results based on N
[Y,I]=sort(merge(:,1));
sort_merge=merge(I,:);
N_ar=sort_merge(:,1);
S=sort_merge(:,2);
S_theor=sort_merge(:,3);

%% Plot Result
hold on;
plot(N_ar,S,'b.--');
plot(N_ar,S_theor,'r*-');
xlabel('Average number of spikes in the bin','FontSize',13);
ylabel('Entropy','FontSize',13);
xlim([0 max(N_ar)]);
h_legend=legend('Entropy based on P(n)', 'Entropy based on Sterling approximation');
set(h_legend, 'FontSize',14);