function [ val ] = G_kernel( width, t )                     % The Gaussian Kernel used in firing rate estimation
    val=1/width/sqrt(2*pi).*exp(-t.^2/2/width.^2);
end