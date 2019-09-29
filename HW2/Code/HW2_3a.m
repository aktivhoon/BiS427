%% Synaptic conductance model to simulate an EPSP
clear; clc;

%% Setting some constants and inital values
g_L=1; tau_syn = 1; E_syn = 10; delta_t = 0.01; T=50; N=10000;
g_syn=zeros(N,T/delta_t); I_syn=zeros(N,T/delta_t); v_m=zeros(N,T/delta_t); 
t=zeros(1,T/delta_t); c_m=1; theta=2; E_L=0; spk_tf=zeros(1,N);
c_g=linspace(0,3,N);

%% Find range of c_m
spk=[1 3.99; 1 4; 1 4.01];
for isi_trial=1:3                                                                       % For all three different spike sequence
    for i=2:T/delta_t
        t(i)= t(i-1)+delta_t;
        if min(abs(t(i)-spk(isi_trial,:)))<0.005; g_syn(:,i-1)=c_g; end                 % Change g_syn to c_g if there is a spike
        g_syn(:,i) = g_syn(:,i-1) - delta_t/tau_syn.*g_syn(:,i-1);
        I_syn(:,i) = g_syn(:,i).*(v_m(:,i-1)-E_syn);
        v_m(:,i) = v_m(:,i-1)- delta_t/c_m*g_L.*v_m(:,i-1)-delta_t/c_m.*I_syn(:,i);
    end
    for j=1:N                                                                           % For all case of c_g,
        if max(v_m(j,:))>theta                                                          % If v_m is over the threshold,
            spk_tf(j)=spk_tf(j)+1;                                                      % Add 1 to spk_tf
        end
    end
end

%% Find C_m

C_g=c_g(find(spk_tf==1));                                                               % Find c_g whre [1 3.99] can only generate a spike
min_cg=min(C_g);
max_cg=max(C_g);
fprintf('%f <= C_g <= %f \n', min_cg, max_cg);
