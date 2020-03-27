function [ pre_RR_rat,post_RR_rat ] = get_RR_amp_ratio( R_val,red )
%GET_RR_AMP_RATIO Summary of this function goes here
%   Detailed explanation goes here
pre_RR_rat=zeros(1,sum(1-red));
post_RR_rat=pre_RR_rat;
j=1;
for i=1:length(R_val)
   if(~red(i))
      pre_RR_rat(j)=R_val(i)/R_val(i-1);
      post_RR_rat(j)=R_val(i)/R_val(i+1);
      j=j+1;
   end

end

