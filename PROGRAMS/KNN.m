function [ prediction ] = KNN( K,is_feture,training_set,training_label,X )
%KNN Summary of this function goes here
%   Detailed explanation goes here
%% choose  fetures
training_set=training_set(:,is_feture==1);
X=X(:,is_feture==1);
%% feture normalization
training_mean=mean(training_set);
training_var=var(training_set)+0.01;%% adding 0.01 to avoid devidion by
%very small numbers
training_set=(training_set-training_mean)./training_var;
X=(X-training_mean)./training_var;
%%

L2_dis=zeros(length(training_label),1);
prediction=zeros(length(X(:,1)),1);
for i=1:length(prediction)
    for j=1:length(L2_dis)
        L2_dis(j)=sqrt((X(i,:)-training_set(j,:))...
            *(X(i,:)-training_set(j,:))');
    end
    [~,I]=sort(L2_dis);
    prediction(i)=sum(training_label(I(1:K)))>(K/2);
end

