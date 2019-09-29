%% Poisson Spike Generator
clear; clc;

N=50;                       % # of trial
fr_mean=50/1000;            % Mean firing rate
time=0;                     % Time
T=1/fr_mean;                % Inverse firing rate
ns=100;                     % Number of spikes to be generated

isi = -T.*log(rand(ns,N));  % Generation of expo. distr. ISIs

figure(1);
hold on;
for it=1:N
    time=0;                 % Reset time
    for ii=1:ns
        time=time+isi(ii,it);
        plot([time time],[it-0.4 it+0.4], 'k', 'Linewidth',1.2);
    end    
end

xlim([0 1000]);
ylim([0 N+1]);
xlabel('Time[ms]');
ylabel('Neuron #');

hold off;