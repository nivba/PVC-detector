function [ red ] = FindRedundancy( R_index,R_val,ecg_logic )
%FINDREDUNDANCY Summary of this function goes here
%   Detailed explanation goes here
red=zeros(size(R_index));
% red(abs(R_val)<0.65)=1;
% red_temp=red;
% for i=2:length(red)-1
%    if(red_temp(i+1)|| red_temp(i-1))
%        red(i)=1;
%    end
% end
if (sum(ecg_logic)<length(ecg_logic))
    for i=2:length(red)-1
        no_ecg_zone=sum(1-ecg_logic(R_index(i):R_index(i+1)))+...
            sum(1-ecg_logic(R_index(i-1):R_index(i)));
        if(no_ecg_zone)
            red(i)=1;
        end
    end
end

red(1)=1;
red(end)=1;
end

