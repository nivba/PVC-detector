function [ R_index,R_val] = find_R( ecg,QRS,delay,Fs )
%FIND_R Summary of this function goes here
%   Detailed explanation goes here
d_ecg=[zeros(1,delay),ecg(1:end-delay)];
R_index=zeros(1,floor(4*(length(ecg)/Fs)));
R_val=zeros(1,floor(4*(length(ecg)/Fs)));
QRS_flag=0;
P_max=0;
P_max_index=0;
N_max=0;
N_max_index=0;
j=1;
for i=1:length(ecg)
  if (QRS_flag)
      if(QRS(i))
          if(d_ecg(i)>P_max)
             P_max=d_ecg(i);
             P_max_index=i;
          else
             if(d_ecg(i)<N_max)
                N_max=d_ecg(i);
                N_max_index=i;                  
             end
          end
      else
          if(P_max>abs(N_max)*0.7)
            R_index(j)=P_max_index;
            R_val(j)=P_max;            
          else
            R_index(j)=N_max_index;
            R_val(j)=N_max;
          end
          j=j+1;
          QRS_flag=0;
      end
  else
      if (QRS(i))
          QRS_flag=1;
          P_max=d_ecg(i);
          P_max_index=i;
          N_max=d_ecg(i);
          N_max_index=i;
      end
  end
  
end


short_Rindex=R_index;
short_Rval=R_val;
j=1;
for i=1:length(R_index)
    if(abs(R_val(i))>0.65)
       short_Rindex(j)= R_index(i);
       short_Rval(j)=R_val(i);
       j=j+1;
    end
end
temp=find(short_Rindex==0);
R_index=short_Rindex(1:temp(1)-1);
R_val=short_Rval(1:temp(1)-1);
R_index=R_index-delay;
end

