function [ Energy ] = get_energy( ecg,Fs )
%IS_ECG Summary of this function goes here
%   Detailed explanation goes here
w_size=0.5*Fs;
Energy=zeros(size(ecg));

for i=1:length(ecg)-w_size
    window_s=floor(0.5*w_size)+i-1;
    window_e=window_s+w_size;
    Energy(window_s)=ecg(i:i+w_size)*ecg(i:i+w_size)';
end

end

