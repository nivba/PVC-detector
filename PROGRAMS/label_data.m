function [ L ] = label_data( info,R_index,redundancy,delay )
%LABEL_DATA Summary of this function goes here
%   Detailed explanation goes here
R=R_index(redundancy==0);
L=zeros(size(R));
for i=1:length(L)   
   [distanse,ind]=min(abs(info.sample-(R(i)-delay)));
   if distanse<30
       if(info.type(ind)=='V')
           L(i)=1;
       end 
   end
end

end

