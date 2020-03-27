function [ F1 ] = F1_score( predict,label )
%F1_SCORE Summary of this function goes here
%   Detailed explanation goes here
recall=sum(label(predict==1)==1)/sum(label==1);
precision=sum(label(predict==1)==1)/sum(predict==1);
F1=(2*precision*recall)/(precision+recall);

end

