function [ S_index,S_val ] = find_S( R_index,ecg )
%FIND_S Summary of this function goes here
%   Detailed explanation goes here
S_index=zeros(size(R_index));
S_val=S_index;
for i=1:length(S_index)
    left=R_index(i);
    if(ecg(left)>0)
        while(ecg(left)>ecg(left+1)||ecg(left+1)>ecg(left+2))
            left=left+1;
        end
    else
        while(ecg(left)<ecg(left+1)||ecg(left+1)<ecg(left+2))
            left=left+1;
        end 
    end
    S_index(i)=left;
    S_val(i)=ecg(left);
end

end

