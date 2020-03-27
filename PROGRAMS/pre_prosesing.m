function [S_p,blw_delay] = pre_prosesing(S_d,Fs,is_noisie )
%PRE_PROSESING Summary of this function goes here
%   Detailed explanation goes here
[h_blw,N_blw]=BLW_F(Fs);
blw_delay=floor(N_blw/2);
ecg=filter(h_blw,S_d.signal);
energy=get_energy(ecg,Fs);
if(is_noisie)
    ecg_logic=is_ecg(energy,Fs);
else
    ecg_logic=ones(size(ecg));
end

[QRS,QRS_delay]=find_QRS(ecg,Fs,ecg_logic);
[ R_index,R_val] = find_R( ecg,QRS,QRS_delay,Fs );
redundancy = FindRedundancy( R_index,R_val,ecg_logic );
R_relevant_index=R_index(redundancy==0);
R_relevant_val=R_val(redundancy==0);
[Q_index,Q_val]=find_Q(R_relevant_index,ecg);
[S_index,S_val]=find_S(R_relevant_index,ecg);
S_p=struct('ecg',ecg,'energy',energy,'ecg_logic',ecg_logic,...
    'R_index',R_index,'R_val',R_val,'redundancy',redundancy...
    ,'Q_index',Q_index,'Q_val',Q_val,'S_index',S_index,'S_val',S_val);
end

