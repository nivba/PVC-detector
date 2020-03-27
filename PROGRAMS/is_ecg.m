function [ ecg_logic ] = is_ecg( Energy,Fs )
%IS_ECG Summary of this function goes here
%   Detailed explanation goes here
is_energetic=Energy>100;
ecg_logic=zeros(size(Energy));
for i=Fs+1:length(Energy)
    ecg_logic(i)=sum(is_energetic(i-Fs:i))>0.95*Fs;
end
for i=1:length(Energy)-Fs
    if(~ecg_logic(i))
       ecg_logic(i)=sum(is_energetic(i:i+Fs))>0.9*Fs; 
    end
end
ecg_logic=1-ecg_logic;
ecg_logic=medfilt1(ecg_logic,2*Fs);
ecg_logic=medfilt1(ecg_logic,1*Fs);
ecg_logic=ecg_logic>0;
end

