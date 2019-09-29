%% HW 4 - Problem 1a
clear; clc; clf;

N=500;

Down_Response=randn(1,N)*4+17;              % Generate Down response
Up_Response=randn(1,N)*4+38;                % Generate Up response

figure(1); hold on;
histogram(Down_Response);
histogram(Up_Response);
xlabel('Firing Rate [Hz]'); ylabel('Number counted'); title('Histogram for neural response in 15% correlated motion stimulus');
legend('Down','Up');
hold off;

%% What would be the best number for sampling?
threshold=0.005;                            % Set the threshold
Trial=40;                                   % Trial number
N_Trial=zeros(Trial,1);
for it=1:Trial
    Change=Inf;
    N=1; obs=[randn(1,1)*4+38];
    while Change>threshold                  % While the change quantity is larger than threshold
        N=N+1;
        obs=[obs, randn(1,1)*4+38];         % Obtain another 
        Change_mean=abs(mean(obs(1:N))-mean(obs(1:N-1)));
        Change_var=abs(var(obs(1:N))-var(obs(1:N-1)));
        Change=Change_mean.^2+Change_var;
    end
    N_trial(it)=N;                          % Number of samples collected before 'stabilization'
end

fprintf('The average number of samples collected is: %f\n',mean(N_trial));