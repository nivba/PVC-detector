function [ opt_feture,opt_F1 ] = go_backward( tr_set,tr_label,v_set,v_label,is_feture,F1,K)
%GO_BACKWARD Summary of this function goes here
%   Detailed explanation goes here
flag=0;
new_F1=F1;
opt_F1=F1;
opt_feture=is_feture;
steps=0;
while(~flag&&sum(opt_feture)>1)
    old_F1=new_F1;
    on_fetures=find(opt_feture==1);
    max_F1=0;
    max_ind=0;
    for i=1:length(on_fetures)
        this_fetures=opt_feture;
        this_fetures(on_fetures(i))=0;
        P=KNN( K,this_fetures,tr_set,tr_label,v_set );
        this_F1=F1_score(P,v_label);
        if(this_F1>max_F1)
           max_F1=this_F1;
           max_ind=i;
        end
    end
    new_F1=max_F1;
    if(new_F1>=old_F1)
        opt_feture(on_fetures(max_ind))=0;
        steps=steps+1;
        opt_F1=new_F1;
    else
        flag=1;
    end
end
if steps
    fprintf('%d steps backward\n',steps);
end
end

