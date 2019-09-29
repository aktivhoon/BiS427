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
N=100;                                                  % Select number of stimulus
L=zeros(1,N);
figure(1); hold on;
for i=1:N
    S=rand(length(rspace),length(rspace));
    S=round(S)*2-1;
    L(i)=sum(sum(S.*RFs));
end
hist(L); xlabel('L^i'); ylabel('# of L^i');