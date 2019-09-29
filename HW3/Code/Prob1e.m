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

%% Simple statitc nonlinearity
F=zeros(1,N);
r=zeros(1,N);
for i=1:N
    r_0=randn(1)+1;
    while r_0<=0
        r_0=randn(1)+1;
    end
    F(i)=200*(L(i)-0.1).*(L(i)>0.1);
    r(i)=r_0+F(i);
end
figure(1);
plot(L,r,'k.','markersize',6);
xlabel('L^i'); ylabel('r ^i');