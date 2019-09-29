%% Problem 3 - d)
clear; clc;
N=5;
r_in=rand(N,10000);
r_in=double(r_in>0.5);
r_in_val=[1 2 4 8 16]*r_in;
h=histogram(r_in_val,'BinWidth',1,'BinLimits',[0 32],'Normalization','probability');
P_rin=h.Values;
S=sum(-P_rin.*log2(P_rin));
In_row=unique(r_in_val','rows')';
close(gcf);

%% Case 1) w= [0 0 0 0 0]
w=zeros(1,5);
r_out=w*r_in;
Out_row=unique(r_out','rows')';
P_rout=zeros(1,length(Out_row));
P_rinout=zeros(length(In_row),length(Out_row));
I_min=0;
for it=1:length(Out_row)
    P_rout(it)=length(find(r_out==Out_row(it)))/length(r_out);
    for jt=1:length(In_row)
        P_rinout(jt,it)=length(intersect(find(r_out==Out_row(it)),find(r_in_val==In_row(jt))))/length(find(r_out==Out_row(it)));
        if P_rinout(jt,it)~=0
            I_min=I_min+P_rinout(jt,it)*P_rout(it)*log2(P_rinout(jt,it)/P_rin(jt));
        end
    end
end
fprintf('The mutual information for the case of [0 0 0 0 0] is: %f\n',I_min);

%% Case 2) w= [1 1/2 1/4 1/8 1/16]
w=[1 1/2 1/4 1/8 1/16];
r_out=w*r_in;
Out_row=unique(r_out','rows')';
P_rout=zeros(1,length(Out_row));
P_rinout=zeros(length(In_row),length(Out_row));
I_max=0;
for it=1:length(Out_row)
    P_rout(it)=length(find(r_out==Out_row(it)))/length(r_out);
    for jt=1:length(In_row)
        P_rinout(jt,it)=length(intersect(find(r_out==Out_row(it)),find(r_in_val==In_row(jt))))/length(find(r_out==Out_row(it)));
        if P_rinout(jt,it)~=0
            I_max=I_max+P_rinout(jt,it)*P_rout(it)*log2(P_rinout(jt,it)/P_rin(jt));
        end
    end
end
fprintf('The mutual information for the case of [1 1/2 1/4 1/8 1/16] is: %f\n',I_max);

%% Case 3) w= [0.5 0.5 0.5 0.5 0.5]
w=ones(1,5)*0.5;
r_out=w*r_in;
Out_row=unique(r_out','rows')';
P_rout=zeros(1,length(Out_row));
P_rinout=zeros(length(In_row),length(Out_row));
I_same=0;
for it=1:length(Out_row)
    P_rout(it)=length(find(r_out==Out_row(it)))/length(r_out);
    for jt=1:length(In_row)
        P_rinout(jt,it)=length(intersect(find(r_out==Out_row(it)),find(r_in_val==In_row(jt))))/length(find(r_out==Out_row(it)));
        if P_rinout(jt,it)~=0
            I_same=I_same+P_rinout(jt,it)*P_rout(it)*log2(P_rinout(jt,it)/P_rin(jt));
        end
    end
end
fprintf('The mutual information for the case of [0.5 0.5 0.5 0.5 0.5] is: %f\n',I_same);

%% Case 4) w= [0.3 0.3 0.3 1 1]
w=[0.3 0.3 0.3 1 1];
r_out=w*r_in;
Out_row=unique(r_out','rows')';
P_rout=zeros(1,length(Out_row));
P_rinout=zeros(length(In_row),length(Out_row));
I_inter=0;
for it=1:length(Out_row)
    P_rout(it)=length(find(r_out==Out_row(it)))/length(r_out);
    for jt=1:length(In_row)
        P_rinout(jt,it)=length(intersect(find(r_out==Out_row(it)),find(r_in_val==In_row(jt))))/length(find(r_out==Out_row(it)));
        if P_rinout(jt,it)~=0
            I_inter=I_inter+P_rinout(jt,it)*P_rout(it)*log2(P_rinout(jt,it)/P_rin(jt));
        end
    end
end
fprintf('The mutual information for the case of [0.3 0.3 0.3 1 1] is: %f\n',I_inter);
fprintf('The maximum entropy of the input is: %f\n', S);