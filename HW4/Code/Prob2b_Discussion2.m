%% HW 4 - Problem 2b Discussion 2: Confirm that the narrower width response function has better performance in direction decoding
clear; clc; clf;

%% Generate stimulus and neuron
Direction=60;
N=100;
Trial=1000;
theta_p=rand(N,Trial)*360;

%% Linear Method with different width response function
Neural_Response=zeros(N,Trial);
Width_arr=linspace(1,7,100);                                                    % Vary the width (apparently, the constant in front of the (theta-theta_p))
RMSE_Angle=zeros(1,100);
for jt=1:length(Width_arr)
    for it=1:Trial
        Neural_Response(:,it)=Response(Width_arr(jt),theta_p(:,it),Direction);  % Obtain neural response
    end
    r_theta=theta_p*pi/180;                                                     % Change the theta_p from degree to rad
    Res_Vec=Neural_Response.*exp(1i*r_theta);                                   % Obtain response vector
    Dir_Vec=sum(Res_Vec)./abs(sum(Res_Vec))*1.2;                                % Obtain direction vector

    Pred_Angle=angle(Dir_Vec)*180/pi;
    RMSE_Angle(jt)=sqrt(sum((Pred_Angle-Direction).^2)/N);                      % RMSE of the predicted angle
end

Total_Width=1./Width_arr*180;
plot(Total_Width,RMSE_Angle);                                                   % Plot result
set(gca,'Xdir','reverse');
ylabel('RMSE','FontSize',14); xlabel('Width[Degree]','FontSize',14); xlim([min(Total_Width), max(Total_Width)]);
title('Performance of the population coding when width varies','FontSize',14);