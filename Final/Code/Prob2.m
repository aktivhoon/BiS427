%% Problem 2
clear; clc; clf;
load('DATA.mat');
data=data';
figure(1); hold on;
plot(data(1,:),data(2,:),'.');
xlim([-1 1]); ylim([-1 1]); grid on;
w=[0.1; 0.4];

for it=1:1000
    rPre=data(:,it);
    rPost=w'*rPre;                                      % Network update
    w=w+0.1*rPost*(rPre-rPost*w);                       % Hebbian training
    w_traj(:,it)=w;                                     % Recording of weight history
end

%% Plotting results (raw data & predicted main axis)
plot(w_traj(1,:),w_traj(2,:),'r');
plot([0 w(1)],[0 w(2)], 'k', 'linewidth', 2);
plot([-1 1], [0 0], 'k'); plot([0 0], [-1 1], 'k');
title('PCA using Oja`s rule','FontSize',14);
xlabel('x','FontSize',12); ylabel('y','FontSize',12);

%% Rotate data
figure(2); hold on;
theta=atan(w(2)/w(1));
rot_data=[cos(theta) sin(theta); -sin(theta) cos(theta)]*data;
                                                        % Reverse rotation matrix
plot(data(1,:),data(2,:),'r.');
plot(rot_data(1,:),rot_data(2,:),'.');
xlim([-1 1]); ylim([-1 1]); grid on;
title('Raw Data & Rotated Data','FontSize',14);
xlabel('x','FontSize',12); ylabel('y','FontSize',12);
legend('Raw Data', 'Rotated Data');

%% Find sigma x and sigma y
figure(3); hold on;
s_x=sqrt(var(rot_data(1,:)));
s_y=sqrt(var(rot_data(2,:)));

resol=0.01;
rsize=1;
rspace=-rsize:resol:rsize;
[xx, yy]=meshgrid(rspace,rspace);

a=(cos(theta))^2/2/s_x^2+(sin(theta))^2/2/s_y^2;
b=sin(2*theta)/4/s_y^2-sin(2*theta)/4/s_x^2;
c=(sin(theta))^2/2/s_x^2+(cos(theta))^2/2/s_y^2;
RFs=exp(-a*xx.^2+2*b*xx.*yy-c*yy.^2);                   % Rotated 2-D Gaussian distribution
contour(xx, yy, RFs, 4, 'LineWidth',2); colormap gray;  % Plot a contour
xlabel('x'); ylabel('y');
plot(data(1,:),data(2,:),'.'); xlim([-1 1]); ylim([-1 1]);
grid on;
title('Data with 2D-Gaussain','FontSize',14);
xlabel('x','FontSize',12); ylabel('y','FontSize',12);
legend('2D-Gaussain','Data');
hold off;

%% Plot the theta, s_x, s_y value
fprintf('theta:\t %f(degree) \ns_x:\t %f \ns_y:\t %f \n', theta*180/pi, s_x, s_y);