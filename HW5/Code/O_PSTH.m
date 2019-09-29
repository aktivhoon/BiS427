function [ PSTH, num_bin ] = O_PSTH(spk_arr, width)         % Obtain PSTH
    num_bin=floor(length(spk_arr)/width);                   % Set number of bins
    N=size(spk_arr);
    N=N(2);                                                 % Obtain number of trials
    PSTH=zeros(num_bin,N);
    for it=0:num_bin-1
        range=it*width+1:it*width+width;
        for jt=1:N
            tmp_PSTH=length(find(spk_arr(range,jt)==1));    % Find all peaks in certain bin
            PSTH(it+1,jt)=tmp_PSTH;
        end
    end
end

