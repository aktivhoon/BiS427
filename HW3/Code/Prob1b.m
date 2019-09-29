%% Create Random checkboard
clear; clc; clf;
resol=1;                                                % Decide the resolution of the RF
rsize=25.0;                                             % Decide the size of the RF
rspace=-rsize:resol:rsize;                              % Make a RF array with the set resolution
[xx, yy]=meshgrid(rspace,rspace);                       % Make a RF space with the set resolution

N=5;                                                    % Decide the number of random stimulus to make
figure(1); hold on;
for i=1:N
    S=rand(length(rspace),length(rspace));
    S=round(S)*2-1;                                     % Each value in S is 1 or -1
    subplot(2,ceil(N/2),i);
    surf(xx, yy, S); xlabel('x'); ylabel('y');
    axis xy image; colorbar;
    az = 0; el = 90; view(az, el);
end
colormap gray;
hold off;