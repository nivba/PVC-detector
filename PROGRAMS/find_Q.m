function [ Q_index,Q_val ] = find_Q( R_index,ecg )
%FIND_Q Summary of this function goes here
%   Detailed explanation goes here
Q_index=zeros(size(R_index));
Q_val=Q_index;
for i=1:length(Q_index)
    right=R_index(i);
    if(ecg(right)>0)
        while(ecg(right)>ecg(right-1)||ecg(right-1)>ecg(right-2))
            right=right-1;
        end
    else
        while(ecg(right)<ecg(right-1)||ecg(right-1)<ecg(right-2))
            right=right-1;
        end
    end
    Q_index(i)=right;
    Q_val(i)=ecg(right);
end

