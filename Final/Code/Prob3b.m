%% Problem 3 - b)
clear; clc; clf;
N=5;
r_in=rand(N,10000);
r_in=double(r_in>0.5);
r_in_val=[1 2 4 8 16]*r_in;
h=histogram(r_in_val,'BinWidth',1,'BinLimits',[0 32],'Normalization','probability');
P_rin=h.Values;
S=sum(-P_rin.*log2(P_rin));
w=0.5*ones(1,5);
r_out=w*r_in;
In_row=unique(r_in_val','rows')';
Out_row=unique(r_out','rows')';
close(gcf);

%% Change value
P_rout=zeros(1,length(Out_row));
P_rinout=zeros(length(In_row),length(Out_row));
I_m=0;
for it=1:length(Out_row)
    P_rout(it)=length(find(r_out==Out_row(it)))/length(r_out);
    for jt=1:length(In_row)
        P_rinout(jt,it)=length(intersect(find(r_out==Out_row(it)),find(r_in_val==In_row(jt))))/length(find(r_out==Out_row(it)));
        if P_rinout(jt,it)~=0
            I_m=I_m+P_rinout(jt,it)*P_rout(it)*log2(P_rinout(jt,it)/P_rin(jt));
        end
    end
end
fprintf('The mutual information for the case of w_i=0.5 is: %f\n',I_m);