%% HW 5 - Problem 2a
clear; clc; clf;

delta_t=linspace(-100,100,501);

delta_EPSC=STDP(10,10,delta_t);                     % Obtain the delta EPSC value

%% Plot Result
figure(1);
plot(delta_t,delta_EPSC);
title('STDP','FontSize',14);
xlabel('t_p_o_s_t - t_p_r_e [ms]','FontSize',12);
ylabel('\Delta EPSC (%)','FontSize',12);