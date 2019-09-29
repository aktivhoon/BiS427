function [ Res ] = Response( W,theta_p, x)              % Function for [cos(W*(x-theta_p))]+
    raw=zeros(length(theta_p),length(x));               % !!!!! Only use x in 0~360 range
    min_x=0; max_x=360;
    for it=1:length(theta_p)
        if theta_p(it)-90/W>=min_x && theta_p(it)+90/W<=max_x
            raw(it,:)=cos(W*(x-theta_p(it))*pi/180).*(abs(x-theta_p(it))<=90/W);
        end
        if theta_p(it)-90/W<min_x
            raw(it,:)=cos(W*(x-theta_p(it))*pi/180).*(min_x<=x & x-theta_p(it)<=90/W)+cos(W*(x-360-theta_p(it))*pi/180).*(360-90/W<=x-theta_p(it) & x<=max_x);
        end
        if theta_p(it)+90/W>max_x
            raw(it,:)=cos(W*(x-theta_p(it))*pi/180).*(-90/W<=x-theta_p(it) & x<=max_x)+cos(W*(x+360-theta_p(it))*pi/180).*(min_x<=x & x-theta_p(it)+360<=90/W);
        end
    end
    Res=raw;
end
