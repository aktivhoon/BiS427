%% Homework 1-6 (20130124 Younghoon Kim)
clear; clc;
 
%% Initialization
E_rest=-65; tau=20; dt=0.1; R=10; E_th=-55; E_spk=45; N=500; trials=50;            % The injected current is divided into a log manner.
firings=[]; Spike_Rate = zeros(1,N);                                                % This is used to reduce the 'jittered' shape of the
I_inj=repmat(10.^log10(linspace(0,2,N))',1,trials);                                 % current - spike rate plot which is shown up when the
                                                                                    % current value is large.
%% Simulation 1 - I_rand=0mA (no random)                                            
V_m=ones(N,trials)*E_rest;
I_rand = zeros(N,trials);
for it=0:2000/dt
    V_m(:,:) = V_m(:,:)+dt/tau*(E_rest-V_m(:,:)+R*(I_inj(:,:)+I_rand(:,:)));        % Voltage is updated for all trials, and all different cases of current
    [I_condition,~] = find(V_m>=E_th);                                              % Find the how many spikes were generated in each current value
    firings = [firings; it+0*I_condition, I_condition];                             % Add the time and current value into the 'firings' array
    if ~isempty(I_condition)                                                        % If there was at least one spike
        V_m(find(V_m>=E_th))=E_rest;                                                % Those neurons are resetted to the resting potential
    end
end
 
for x=1:N                                                                           % For all cases of current
    Spike_Rate(x) = length(find(firings(:,2)==x))/2/trials;                        % Calculate the spike rate; we devide it also with trials
end
 
figure(4);
hold on;
plot(I_inj(:,1), Spike_Rate,'Linewidth',2);
ylabel('Spike Rate[1/s]');
xlabel('I[mA]');
 
%% Simulation 2 - I_rand=2mA
firings=[];
V_m=ones(N,trials)*E_rest;
I_condition=[];
for it=0:2000/dt
    I_rand =2*randn(N,trials);                                                      % Generate a random noise signal
    V_m(:,:) = V_m(:,:)+dt/tau*(E_rest-V_m(:,:)+R*(I_inj(:,:)+I_rand(:,:)));        % Below is exactly the same as the simulation 1
    [I_condition,~] = find(V_m>=E_th);
    firings = [firings; it+0*I_condition, I_condition];
    if ~isempty(I_condition)
        V_m(find(V_m>=E_th))=E_rest;
    end
end
 
for x=1:N
    Spike_Rate(x) = length(find(firings(:,2)==x))/2/trials;
end
 
plot(I_inj(:,1), Spike_Rate,'Linewidth',2);

%% Simulation 3 - I_rand=5mA
firings=[];
V_m=ones(N,trials)*E_rest;
I_condition=[];
for it=0:2000/dt
    I_rand =5*randn(N,trials);                                                      % Generate a random noise signal
    V_m(:,:) = V_m(:,:)+dt/tau*(E_rest-V_m(:,:)+R*(I_inj(:,:)+I_rand(:,:)));        % Below is exactly the same as the simulation 1
    [I_condition,~] = find(V_m>=E_th);
    firings = [firings; it+0*I_condition, I_condition];
    if ~isempty(I_condition)
        V_m(find(V_m>=E_th))=E_rest;
    end
end
 
for x=1:N
    Spike_Rate(x) = length(find(firings(:,2)==x))/2/trials;
end
 
plot(I_inj(:,1), Spike_Rate,'Linewidth',2);
legend('No rand','Rand(s.d. 2mV)','Rand(s.d. 5mV)');
hold off;