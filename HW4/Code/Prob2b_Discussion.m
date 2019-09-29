%% HW 4 - Problem 2b Discussion: Compare the performance of different decoding method
clear; clc; clf;

%% Generate stimulus and neuron
Direction=60;
N=100;
Trial=100;
theta_p=rand(N,Trial)*360;

%% Linear Method with original response function (logic is same as in prob2a)
Neural_Response=zeros(N,Trial);

for it=1:Trial
    Neural_Response(:,it)=Response(1,theta_p(:,it),Direction);
end
r_theta=theta_p*pi/180;
Res_Vec=Neural_Response.*exp(1i*r_theta);
Dir_Vec=sum(Res_Vec)./abs(sum(Res_Vec))*1.2;

figure(1);
subplot(1,3,1);
gca2=compass(Dir_Vec(1));
for k = 1:length(gca2)
    a = get(gca2(k), 'xdata'); 
    b = get(gca2(k), 'ydata'); 
    set(gca2(k), 'xdata', a(1:2), 'ydata', b(1:2), 'color', 'r','LineWidth',2);
end
hold on;
gca=compass(Res_Vec(:,1));
for k = 1:length(gca)
    a = get(gca(k), 'xdata'); 
    b = get(gca(k), 'ydata'); 
    set(gca(k), 'xdata', a(1:2), 'ydata', b(1:2), 'color', [0.5 0.5 0.5]);
end
title('Original Method','FontSize',14); hold off;
Pred_Angle=angle(Dir_Vec)*180/pi;
RMSE_Angle=sqrt(sum((Pred_Angle-Direction).^2)/N);
fprintf('RMSE for original response function is %f\n',RMSE_Angle);

%% Linear Method with narrower response function (logic is same as in prob2b)
Neural_Response=zeros(N,Trial);
for it=1:Trial
    Neural_Response(:,it)=Response(1.5,theta_p(:,it),Direction);
end
r_theta=theta_p*pi/180;
Res_Vec=Neural_Response.*exp(1i*r_theta);
Dir_Vec=sum(Res_Vec)./abs(sum(Res_Vec))*1.2;

subplot(1,3,2);
gca2=compass(Dir_Vec(1));
for k = 1:length(gca2)
    a = get(gca2(k), 'xdata'); 
    b = get(gca2(k), 'ydata'); 
    set(gca2(k), 'xdata', a(1:2), 'ydata', b(1:2), 'color', 'r','LineWidth',2);
end
hold on;
gca=compass(Res_Vec(:,1));
for k = 1:length(gca)
    a = get(gca(k), 'xdata'); 
    b = get(gca(k), 'ydata'); 
    set(gca(k), 'xdata', a(1:2), 'ydata', b(1:2), 'color', [0.5 0.5 0.5]);
end
title('Narrower Response','FontSize',14); hold off;
Pred_Angle=angle(Dir_Vec)*180/pi;
RMSE_Angle=sqrt(sum((Pred_Angle-Direction).^2)/N);
fprintf('RMSE for narrowed response function is %f\n',RMSE_Angle);


%% Weighting vector directions depending on the amplitude's square value & threshold summation
Neural_Response=zeros(N,Trial);
for it=1:Trial
    Neural_Response(:,it)=Response(1,theta_p(:,it),Direction);
end
r_theta=theta_p*pi/180;
Res_Vec=Neural_Response.*exp(1i*r_theta).*(Neural_Response>0.9);    % Only obtain response vectors with neural response higher than 0.9
Dir_Vec=sum(Res_Vec.*abs(Res_Vec));                                 
Dir_Vec=Dir_Vec./abs(Dir_Vec).*1.2;                                 % Obtain the direction vector using response function's square value as weighting factor

subplot(1,3,3);
gca2=compass(Dir_Vec(1));
for k = 1:length(gca2)
    a = get(gca2(k), 'xdata'); 
    b = get(gca2(k), 'ydata'); 
    set(gca2(k), 'xdata', a(1:2), 'ydata', b(1:2), 'color', 'r','LineWidth',2);
end
hold on;
gca=compass(Res_Vec(:,1));
for k = 1:length(gca)
    a = get(gca(k), 'xdata'); 
    b = get(gca(k), 'ydata'); 
    set(gca(k), 'xdata', a(1:2), 'ydata', b(1:2), 'color', [0.5 0.5 0.5]);
end
title('Square Weighting & Threshold = 0.9','FontSize',14); hold off;

Pred_Angle=angle(Dir_Vec)*180/pi;
RMSE_Angle=sqrt(sum((Pred_Angle-Direction).^2)/N);
fprintf('RMSE for square weighting + threshold method is %f\n',RMSE_Angle);

