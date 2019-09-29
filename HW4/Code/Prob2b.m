%% HW 4 - Problem 2b
clear; clc; clf;

%% Plot turning curve of theta_p = 90 degree
Degree_Range=linspace(0,360,400);                       % Degree_Range is from 0 to 360 (you should not modify the range, if you want to use Response function!)
Neuron_Response=Response(1.5,90,Degree_Range);          % Obtain the neural response for the case where theta_p = 90

figure(1);
plot(Degree_Range,Neuron_Response);
xlim([0, 360]); xlabel('Angle[degree]'); ylabel('f_\theta / f_m_a_x'); title('Neural Response for the case where \theta_p = 90 degrees');

%% Generate stimulus and neuron
Direction=60;
N=100;
theta_p=rand(N,1)*360;                                  % Generate 100 different neurons with randomized theta_p

%% Linear Method with cos(1.5(theta-theta_p))
Neural_Response=Response(1.5,theta_p,60);               % Obtain the neural response ([cos(1.5*(theta-theta_p))]+)
r_theta=theta_p*pi/180;                                 % Change the theta_p from degree to rad
Res_Vec=Neural_Response.*exp(1i*r_theta);               % Obtain the response vectors
Dir_Vec=sum(Res_Vec)./abs(sum(Res_Vec))*1.2;            % Obtain the Direction vector

figure(2);
gca2=compass(Dir_Vec);                                  % Plot the result
for k = 1:length(gca2)
    a = get(gca2(k), 'xdata'); 
    b = get(gca2(k), 'ydata'); 
    set(gca2(k), 'xdata', a(1:2), 'ydata', b(1:2), 'color', 'r','LineWidth',2);
end
hold on;
gca=compass(Res_Vec);
for k = 1:length(gca)
    a = get(gca(k), 'xdata'); 
    b = get(gca(k), 'ydata'); 
    set(gca(k), 'xdata', a(1:2), 'ydata', b(1:2), 'color', [0.5 0.5 0.5]);
end
hold off;
title('Angle Prediction of the [cos(1.5*(\theta-\theta_p))]_+ function','FontSize',14);
Pred_Angle=angle(Dir_Vec)*180/pi;
fprintf('The predicted angle is %f\n',Pred_Angle);