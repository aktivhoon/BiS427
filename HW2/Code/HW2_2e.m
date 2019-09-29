%% Poisson Spike Generator with stochastic refractory period
clear; clc;

N=1000;                                                                 % # of trial
fr_mean=50/1000;                                                        % Mean firing rate
time=0;                                                                 % Time
T=1/fr_mean;                                                            % Inverse firing rate
ns=1000;                                                                % Number of spikes to be generated
rfp_mean=5;                                                             % Refractory period mean
rfp_var=2;                                                              % Refractory period variance
rfp=zeros(ns,N);                

for x=1:ns
    for y=1:N
        random_rfp=rfp_mean+randn(1);                                   % Generate Random 
        while random_rfp<0; random_rfp=rfp_mean+rand(1); end            % When random refractory period is not 0
        rfp(x,y)=random_rfp;                                            % Add that refractory period
    end
end

isi = rfp-T.*log(rand(ns,N));                                           % Generation of expo. distr. ISIs + refractory period


figure(1);
isi=reshape(isi,1,N*ns);
histfit(isi,150,'gamma');                                               % Fit the ISI histogram to Gamma distribution
xlim([0 150]);
xlabel('ISI[ms]');