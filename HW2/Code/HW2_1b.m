%% Poisson Spike Generator
clear; clf; clc;

N=50;                                                                           % # of trials
T=1000;                                                                         % ms
r=50;                                                                           % # of spikes/s (constant)
p=r/1000;                                                                       % 1ms

hold on;
for trial=1:N
    spk=-1*ones(1,T);                                                           % Initialize spk value
    for ii=1:T
        xrand=rand(1);                                                          % Generate random number
        if p>xrand                                                              
            spk(ii)=1;                                                          % Poisson Process for each bin
        end
    end
    for ii=1:T
        if spk(ii)==1                                                           % If there is a spike,
            for jj=1:5                                                          % for 5ms,
                spk(ii+jj)=0;                                                   % remove all spikes
            end
        end
    end
    n=find(spk==1);                                                             % Find spike regions
    for it=n
        plot([it it],[trial-0.4 trial+0.4], 'k', 'Linewidth',1.2);              % Raster plot the spikes
    end
    xlim([1 T])
    ylim([0 N+1])
end
hold off;
xlabel('Time[ms]');
ylabel('Neuron #');

%% For analysis of ISI: change value of T into T=100000ms, r=100, N=1 to use this
spk_time=find(spk==1);
ISI=zeros(1,length(spk_time)-1);
for iter=1:length(spk_time)-1
    ISI(iter)=spk_time(iter+1)-spk_time(iter);
end
[f,x]=hist(ISI, 100);
fr_mean = length(spk_time)/T;
g=p*exp(-p.*(x-5));
h=p*exp(-p.*x);
figure(2);
bar(x,f/trapz(x,f)); hold on;
plot(x,g,'r','Linewidth',3);
plot(x,h,'y--','Linewidth',2); 
hold off;
xlim([0 60]);
xlabel('ISI[ms]');
legend('ISI','Shift','Non-shift');