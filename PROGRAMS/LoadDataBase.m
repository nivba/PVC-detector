function [ S_data ] = LoadDataBase( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
subjects=[105,109,118,119,200,202,210,214,221,223];
S_data(1:10) =struct('signal', [],'info',[],'subject',[]);
folder_path=pwd;
d_folder_path=[folder_path(1:end-8),'DATABASE\'];
dynamic_range=[-10,10];
bit=11;
q=(dynamic_range(2)-dynamic_range(1))/(2^bit);

for i=1:10
    signal=load([d_folder_path,int2str(subjects(i)),'m.mat']);
    info=load([d_folder_path,'info',int2str(subjects(i)),'.mat']);
    q_ecg=signal.val;
    ecg=dynamic_range(1)+q/2+q*(2^(bit-1)+q_ecg);
    S_data(i).signal=ecg;
    S_data(i).info=info.(sprintf('info%d', subjects(i)));
    S_data(i).subject=subjects(i);
end
end

