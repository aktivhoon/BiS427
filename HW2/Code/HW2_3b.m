%% Cross-correlation graph (using histogram)
clear; clc; clf; hold on;


%% Poisson Spike Generator
fr_mean=100/1000;           % Mean firing rate
time=0;                     % Time
T=1/fr_mean;                % Inverse firing rate
ns=3000;                    % Number of spikes to be generated

isi = -T.*log(rand(ns,1));  % Generation of expo. distr. ISIs

inspk=zeros(ns,1);
for ii=1:ns
    time=time+isi(ii);
    inspk(ii)=time;
end

%% Setting some constants and inital values for the neuron
g_L=1;                      % Contuctance peak when spike occurs 
tau_syn = 1;                % Tau value of the neuron
E_syn = 10;                 % E_syn
delta_t = 0.01;             % Time interval
Time=ceil(max(inspk));      % Total time [ms]
c_m=1;                      % c_m value obtained in 3a
theta=2;                    % Threshold value
E_L=0;                      % Resting potential
E_spk=10;                   % Spike potential
c_g=0.5603;                 % c_g spike

g_syn=zeros(1,Time/delta_t); 
I_syn=zeros(1,Time/delta_t); 
v_m=zeros(1,Time/delta_t); 
t=zeros(1,Time/delta_t);

%% Neuron output
outspk=[];
for i=2:Time/delta_t
    t(i)= t(i-1)+delta_t;
    if min(abs(t(i)-inspk))<0.005; g_syn(i-1)=c_g; end
    g_syn(:,i) = g_syn(i-1) - delta_t/tau_syn*g_syn(i-1);
    I_syn(:,i) = g_syn(i)*(v_m(i-1)-E_syn);
    v_m(i) = v_m(i-1)- delta_t/c_m*g_L*v_m(i-1)-delta_t/c_m*I_syn(i);
    if v_m(i)>theta
        v_m(i-1)=E_spk;
        v_m(i)=E_L;
        outspk=[outspk t(i-1)];
    end
end

%% Generate cross-correlation graph (using histogram)
Range=50;                                                                       % Decide the range
N=length(outspk);                                                               
Bin_size=3;                                                                     % Decide the bin size [ms]
Bin=-Range-mod(-Range,Bin_size):Bin_size:Range-mod(Range,Bin_size);             % Divide the range (-range, range) in bin size
Bin=Bin+Bin_size/2;
f=zeros(length(Bin),1);                                                     
for it=1:N
    interval=inspk-outspk(it);                                                  % Relative time of input spikes to output spikes
    [f_tmp]=histc(interval(find(interval>-Range & interval<Range)),Bin);        % Generate a historgram
    f=f+f_tmp;                                                                  % Stack it
end
hold on;
bar(Bin,f);                                                                     % Bar graph the result
xlim([-Range-mod(-Range,Bin_size) Range-mod(Range,Bin_size)]);
xlabel('Time[ms]');
ylabel('Number of spikes');
hline=refline([0 sum(f)/length(f)]);
hline.Color = 'r';

%% Plot the spike of input and output
figure(2); 
subplot(2,1,1); hold on;
for i=1:length(inspk)
    plot([inspk(i) inspk(i)],[1-0.4 1+0.4], 'k', 'Linewidth',1.2);
end
xlim([0 10000]);
ylim([0 2]);
xlabel('Time[ms]');

subplot(2,1,2); hold on;
for i=1:length(outspk)
    plot([outspk(i) outspk(i)],[1-0.4 1+0.4], 'k', 'Linewidth',1.2);
end
xlim([0 10000]);
ylim([0 2]);
xlabel('Time[ms]');