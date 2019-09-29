%% HW 4 - Problem 1d
clear; clc; clf;

N=500;

Hard_Down_Response=randn(N,1)*5+19;
Hard_Up_Response=randn(N,1)*5+22;
Easy_Down_Response=randn(N,1)*4+17;
Easy_Up_Response=randn(N,1)*4+38;

Num_z=50;                                       % Number of z values to be made

z=linspace(0,max(Hard_Up_Response),Num_z);
Hard_alpha=zeros(1,Num_z); Easy_alpha=zeros(1,Num_z);
Hard_beta=zeros(1,Num_z); Easy_beta=zeros(1,Num_z);
for it=1:length(z)
    threshold=z(it);
    Hard_alpha(it)=length(find(Hard_Down_Response>threshold))/N;
    Easy_alpha(it)=length(find(Easy_Down_Response>threshold))/N;
    Hard_beta(it)=length(find(Hard_Up_Response>threshold))/N;
    Easy_beta(it)=length(find(Easy_Up_Response>threshold))/N;
end

figure(1); hold on;
plot(Hard_alpha,Hard_beta,'k*--');
plot(Easy_alpha,Easy_beta,'ks--');
plot([0 1],[0 1],'k');
xlabel('False Alarms'); ylabel('Hits');
legend('1% correlation','15% correlation');
hold off;