%% HW 4 - Problem 1e
clear; clc;

N=140;

Down_Response=randn(1,N)*4+17;
Up_Response=randn(1,N)*4+38;

Mean_Down=mean(Down_Response);              % Mean of the down response for 140 samples
Mean_Up=mean(Up_Response);                  % Mean of the up response for 140 samples
Var_Down=var(Down_Response);                % Variance of the down response for 140 samples
Var_Up=var(Up_Response);                    % Variance of the up response for 140 samples

z=linspace(0,max(Up_Response),1000);        % For many different z values
p=zeros(1000,1);
for it=1:length(z)
    one_minus_alpha=normcdf(z(it),Mean_Down,sqrt(Var_Down));
    beta=1-normcdf(z(it),Mean_Up,sqrt(Var_Up));
    p(it)=(one_minus_alpha+beta)/2;         % Obtain the accuracy
end
opt_z=z(find(p==max(p)));                   % Optimal z value

N=1000;

Down_Response=randn(1,N)*4+17;
Up_Response=randn(1,N)*4+38;

alpha=length(find(Down_Response>opt_z))/N;  % Find the alpha value of the 1000 samples
beta=length(find(Up_Response>opt_z))/N;     % Find the beta value of the 1000 samples
fprintf('The accuracy for this z value is: %f\n',(beta+1-alpha)/2);