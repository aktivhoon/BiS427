function [ delta_EPSC ] = STDP( tau_plus, tau_minus, delta_t )      % Obtain delta EPSC
    delta_EPSC=zeros(length(delta_t),1);
    delta_EPSC=100.*exp(-delta_t./tau_plus).*(delta_t>=0)-100.*exp(delta_t./tau_minus).*(delta_t<0);
end

