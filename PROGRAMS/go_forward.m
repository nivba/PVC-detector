function [opt_feture,opt_F1] = go_forward( tr_set,tr_label,v_set,v_label,is_feture,F1,K)
%GO_FORWARD Summary of this function goes here
%   Detailed explanation goes here
flag=0;
new_F1=F1;
opt_F1=F1;
opt_feture=is_feture;
steps=0;
minstep=3;
while((~flag||steps<=minstep-1)&&sum(opt_feture)<10)
    old_F1=new_F1;
    off_fetures=find(opt_feture==0);
    max_F1=0;
    max_ind=0;
    for i=1:length(off_fetures)
        this_fetures=opt_feture;
        this_fetures(off_fetures(i))=1;
        P=KNN( K,this_fetures,tr_set,tr_label,v_set );
        this_F1=F1_score(P,v_label);
        if(this_F1>max_F1)
           max_F1=this_F1;
           max_ind=i;
        end
    end
    new_F1=max_F1;
    flag=(new_F1<=old_F1);
    if (~flag||steps<=minstep)
        opt_feture(off_fetures(max_ind))=1;   
        opt_F1=new_F1;
        steps=steps+1;
    end
end
fprintf('%d steps forward\n',steps);
end

