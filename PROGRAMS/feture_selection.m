function [ opt_K,opt_feture ] = feture_selection( tr_set,tr_label,v_set,v_label )
%FETURE_SELECTION Summary of this function goes here
%   Detailed explanation goes here
K=11:2:21;
opt_feture=ones(1,10);
is_feture=ones(length(K),10);
opt_F1=0;
for i=1:length(K)
    fprintf('K=%d\n',K(i))
    flag=0;
    old_F1=0;
    new_F1=0;
    N_fetures=0;
    while(~flag)
        if(sum(is_feture(i,:))>1)
            [is_feture(i,:),b_F1]=go_backward( tr_set,tr_label,v_set,...
                v_label,is_feture(i,:),old_F1,K(i));
        end
        [is_feture(i,:),f_F1]=go_forward( tr_set,tr_label,v_set,...
            v_label,is_feture(i,:),b_F1,K(i));
        if(sum(is_feture(i,:))>1)
            [is_feture(i,:),new_F1]=go_backward( tr_set,tr_label,v_set,...
                v_label,is_feture(i,:),f_F1,K(i));
        end

        if(new_F1>old_F1||sum(is_feture(i,:))<N_fetures)
            old_F1=new_F1;
            N_fetures=sum(is_feture(i,:));
        else
            flag=1;
        end
    end
    if(new_F1>opt_F1)
        opt_F1=new_F1;
        opt_K=K(i);
        opt_feture=is_feture(i,:);
    else
        if(new_F1==opt_F1&&sum(is_feture(i,:))<sum(opt_feture))
            opt_K=K(i);
            opt_feture=is_feture(i,:);
        end
    end

end
fprintf('F1=%d\n',opt_F1);
end

