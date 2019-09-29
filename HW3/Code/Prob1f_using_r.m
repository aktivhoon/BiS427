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
N=100000;                                               % Number of stimulus
L=zeros(1,N);
L_avg=zeros(1,100);
Pred_RF=zeros(length(rspace),length(rspace));
total_num=0;
Mean_fr=1;                                              % Mean firing rate of the neuron with no stimulus
Std_fr=1;                                               % Standard deviation of the firing rate of the nueron with no stimulus
threshold = 3.5;                                        % Select the statistical threshold for firing rate
for t=1:N
    S=rand(length(rspace),length(rspace));
    S=round(S)*2-1;
    L(t)=sum(sum(S.*RFs));
    r_0=randn(1)+1;
    while r_0<=0
        r_0=randn(1)+1;
    end
    r=r_0+200*L(t).*(L(t)>0.1);                         % This is what we really obtain from an experiment
    if (r>threshold && t>=100)                          % If the firing rate is statistically significant to be considered to have meaningful spike
        L_tmp=L(t-99:t);                                % Save all L values for previous 99 stimulus and current stimulus
        total_num=total_num+1;                          % Count the total number of stimulus where L>0.1
        L_avg=L_avg+L_tmp;
        Pred_RF=Pred_RF+S;
    end
end
Pred_positive=Pred_RF.*(Pred_RF>0);
Total=sum(sum(Pred_positive));
Pred_RF=Pred_RF/Total;
L_avg=L_avg/total_num;

%% Plot result
figure(1); hold on;
plot(0:99,fliplr(L_avg)); set(gca,'XDir','reverse'); xlabel('\tau'); ylabel('L');
hold off;

figure(2);
subplot(1,2,1);
surf(xx, yy, Pred_RF);
az = 0; el = 90; view(az, el);
axis xy image; colormap jet; colorbar;
title('Predicted RF');

subplot(1,2,2);
surf(xx, yy, RFs);
az = 0; el = 90; view(az, el);
axis xy image; colormap jet; colorbar;
title('Real RF');