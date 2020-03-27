function [ pre_RR,post_RR ] = get_RRInterval(R_index,red)
%GET_RRINTERVAL Summary of this function goes here
%   Detailed explanation goes here
pre_RR=zeros(1,sum(1-red));
post_RR=pre_RR;
j=1;
for i=1:length(R_index)
   if(~red(i))
      pre_RR(j)=R_index(i)-R_index(i-1);
      post_RR(j)=R_index(i+1)-R_index(i);
      j=j+1;
   end
end


end

