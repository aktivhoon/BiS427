%% HW 4 - Problem 1c
clear; clc; clf;

N=500;

Down_Response=randn(N,1)*5+19;                          % Generate Down response
Up_Response=randn(N,1)*5+22;                            % Generate Up response

z=linspace(0, max(Up_Response),5);
p_string=zeros(1,300);

figure(1); hold on;
histogram(Down_Response);
histogram(Up_Response);
xlabel('Firing Rate [Hz]'); ylabel('Number counted'); title('Histogram for neural response in 1% correlated motion stimulus');
legend('Down','Up');
hold off;

figure(2); hold on;
histogram(Down_Response);
histogram(Up_Response);

for it=1:length(z)
    threshold=z(it);
    alpha=length(find(Down_Response>threshold))/N;  % Obtain the alpha value
    beta=length(find(Up_Response>threshold))/N;     % Obtain the beta value
    fprintf('For %f as a threshold value:\n Alpha: %f \t Beta: %f \t p: %f\n',z(it),alpha,beta,(beta+1-alpha)/2);
    plot([z(it) z(it)],[0 N/5], 'r--', 'Linewidth',1.2);
end
xlabel('Firing Rate [Hz]'); ylabel('Number counted'); title('Histogram for neural response in 1% correlated motion stimulus');
legend('Down','Up');
hold off;