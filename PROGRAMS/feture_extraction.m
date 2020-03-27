function [X] = feture_extraction( S_p )
%FETURE_EXTRACTION Summary of this function goes here
%   Detailed explanation goes here
ecg=S_p.ecg;
energy=S_p.energy;
R_index=S_p.R_index;
R_val=S_p.R_val;
red=S_p.redundancy;
R_relevant_index=R_index(red==0);
R_relevant_val=R_val(red==0);
Q_index=S_p.Q_index;
Q_val=S_p.Q_val;
S_index=S_p.S_index;
S_val=S_p.S_val;

[pre_RR,post_RR]=get_RRInterval(R_index,red);
QR_slope=(R_relevant_val-Q_val)./(R_relevant_index-Q_index);
RS_slope=(S_val-R_relevant_val)./(S_index-R_relevant_index);
QRS_width=(S_index-Q_index);
R_Energy=energy(R_relevant_index)/max(energy(S_p.ecg_logic==1));
RR_interval_ratio=(pre_RR./post_RR);
[pre_RR_rat,post_RR_rat] = get_RR_amp_ratio( R_val,red );
X=[R_relevant_val',pre_RR',post_RR',QR_slope',RS_slope',QRS_width',...
    R_Energy',RR_interval_ratio',pre_RR_rat',post_RR_rat'];
end

