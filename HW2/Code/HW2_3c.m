%% Cross-correlation graph (using xcorr)
clear; clc; clf; hold on;

%% Poisson Spike Generator
fr_mean=100/1000;           % Mean firing rate
time=0;                     % Time
T=1/fr_mean;                % Inverse firing rate
ns=5000;                    % Number of spikes to be generated

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
inspk_ar=zeros(1,Time/delta_t);
outspk_ar=zeros(1,Time/delta_t);

%% Neuron output
for i=2:Time/delta_t
    t(i)= t(i-1)+delta_t;
    if min(abs(t(i)-inspk))<0.005; g_syn(i-1)=c_g; inspk_ar(i)=1; end
    g_syn(:,i) = g_syn(i-1) - delta_t/tau_syn*g_syn(i-1);
    I_syn(:,i) = g_syn(i)*(v_m(i-1)-E_syn);
    v_m(i) = v_m(i-1)- delta_t/c_m*g_L*v_m(i-1)-delta_t/c_m*I_syn(i);
    if v_m(i)>theta
        v_m(i-1)=E_spk;
        v_m(i)=E_L;
        outspk_ar(i)=1;
    end
end

%% Generate cross-correlation graph (using xcorr)
Range=80;
cross_corr = xcorr(inspk_ar, outspk_ar, Range/delta_t);         % Cross corelation of input spikes and output spike (-80ms to 80ms)
plot(linspace(-Range,Range,2*Range/delta_t+1), cross_corr);     % (0ms is the output spike timing)
xlim([-Range Range]);
ylim([0 max(cross_corr)]*1.2); hold on;
xlabel('Time[ms]'); ylabel('Number of spikes'); hold off;