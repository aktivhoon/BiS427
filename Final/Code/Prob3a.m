%% Problem 3 - a)
clear; clc; clf;
N=5;
Input=rand(N,10000);
Input=double(Input>0.5);
Input_val=[1 2 4 8 16]*Input;
figure(1);
h=histogram(Input_val,'BinWidth',1,'BinLimits',[0 32],'Normalization','probability');
P_n=h.Values;
title('Probability of input patterns','FontSize',14);
xlabel('Input Pattern','FontSize',12); ylabel('Probability','FontSize',12);
xlim([0 32]);
S=sum(-P_n.*log2(P_n));
S_anal=5;
fprintf('Numerically calculated entropy: %f\n', S);
fprintf('Analytically calculated entropy: %f\n', S_anal);
