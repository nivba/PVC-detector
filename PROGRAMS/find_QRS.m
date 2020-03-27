function [ QRS_vec,delay ] = find_QRS( x,Fs,ecg_logic )
h_bpf=BPF();
x_bpf=filter(h_bpf,x);
N_bpf=100;

h_div=(1/8)*[2,1,-1,-2];
x_div=filter(h_div,1,x_bpf);
N_div=4;

val_squere=x_div.^2;

N_ma=30;
h_ma=(1/N_ma)*ones(1,N_ma);
x_ma=filter(h_ma,1,val_squere);

Th=zeros(size(x_ma));
dt=0.4;
for i=1+dt*Fs:length(x_ma)-dt*Fs
    Th(i)=0.3*max(x_ma(i-dt*Fs:i+dt*Fs));
end
Th(1:dt*Fs)=Th(dt*Fs+1);
Th(length(x_ma)-dt*Fs+1:end)=Th(length(x_ma)-dt*Fs);
QRS_vec=x_ma>Th;
delay=floor((N_bpf+N_ma+N_div)/2);
d_ecg_logic=[ones(1,delay),ecg_logic(1:end-delay)];
QRS_vec=QRS_vec.*d_ecg_logic;
QRS_vec=medfilt1(QRS_vec,15);
QRS_vec=QRS_vec>0;
QRS_length=0;
flag=0;
for i=1:length(QRS_vec)
    if flag
        if(QRS_vec(i))
           QRS_length=QRS_length+1;
        else
           if(QRS_length<15)
                QRS_vec(i-QRS_length:i-1)=zeros(1,QRS_length); 
           end
           flag=0;
           QRS_length=0;
        end
    else
        if(QRS_vec(i))
           QRS_length=1;
           flag=1;
        end
    end
    
end
end

