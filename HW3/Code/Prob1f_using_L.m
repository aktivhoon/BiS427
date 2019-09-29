%% Generate RF
clear; clc; clf;
resol=1;                                                % Decide the resolution of the RF
rsize=25.0;                                             % Decide the size of the RF
rspace=-rsize:resol:rsize;                              % Make a RF array with the set resolution
[xx, yy]=meshgrid(rspace,rspace);                       % Make a RF space with the set resolution

RFs=exp(-(xx.^2+yy.^2)/64).*cos(pi.*xx/12-pi/2);
RF_positive=RFs.*(RFs>0);                               % Extract RF regions with positive value
Total=sum(sum(RF_positive));                            % Add their values

Ncoef=1/Total;                                          % Select the coefficient to make the total sum 1
RFs=Ncoef*exp(-(xx.^2+yy.^2)/64).*cos(pi.*xx/12-pi/2);

%% Create Random checkerboard & Obtain Linear Response
N=100000;
L=zeros(1,N);
total_num=0;
L_avg=zeros(1,100);
Pred_RF=zeros(length(rspace),length(rspace));
for t=1:N
    S=rand(length(rspace),length(rspace));
    S=round(S)*2-1;
    L(t)=sum(sum(S.*RFs));
    if (L(t)>0.1 && t>=100)                             % If L is larger than 0.1 and t is later than 100
        L_tmp=L(t-99:t);                                % Save all L values for previous 99 stimulus and current stimulus
        total_num=total_num+1;                          % Count the total number of stimulus where L>0.1
        L_avg=L_avg+L_tmp;                              % Add the L_tmp into L_avg
        Pred_RF=Pred_RF+S*L(t)/2;                       % Add the given random signal for predicting receptive field
    end
end
L_avg=L_avg/total_num;                                  % Find the time dependency of the stimulus with the L value
Pred_RF=Pred_RF/total_num;                              % Normalize the predicted receptive field

%% Plot result
figure(1); hold on;
plot(0:99,fliplr(L_avg)); set(gca,'XDir','reverse'); xlabel('\tau'); ylabel('L');
hold off;

figure(2); hold on;
subplot(1,2,1);
surf(xx, yy, Pred_RF); xlabel('x'); ylabel('y');
az = 0; el = 90; view(az, el);
axis xy image; colormap jet; colorbar;
title('Predicted RF');

subplot(1,2,2);
surf(xx, yy, RFs);
az = 0; el = 90; view(az, el);
axis xy image; colormap jet; colorbar;
title('Real RF');
hold off;