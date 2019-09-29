%% Calculate the total sum of positive region
clear; clc; clf;
resol=1;                                                % Decide the resolution of the RF
rsize=25.0;                                             % Decide the size of the RF
rspace=-rsize:resol:rsize;                              % Make a RF array with the set resolution
[xx, yy]=meshgrid(rspace,rspace);                       % Make a RF space with the set resolution

Ncoef=1;                                                % Set the Coefficient as 1 at first

RFs=Ncoef*exp(-(xx.^2+yy.^2)/64).*cos(pi.*xx/12-pi/2);
RF_positive=RFs.*(RFs>0);                               % Extract RF regions with positive value

Total=sum(sum(RF_positive));                            % Add their values

%% Normalize RF(x,y)
Ncoef=1/Total;                                          % Select the coefficient to make the total sum 1

RFs=Ncoef*exp(-(xx.^2+yy.^2)/64).*cos(pi.*xx/12-pi/2);

surf(xx, yy, RFs); xlabel('x'); ylabel('y');
axis xy image; colormap jet; colorbar;                  
az = 0; el = 90; view(az, el);                          % Look at the image from the top