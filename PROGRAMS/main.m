%% Reset workspace
clear all;clc;
%% load data
S_data=LoadDataBase;
Fs=360;
N=10;

%% Pre-processing
S_pre(1:10)=struct('ecg',[],'energy',[],'ecg_logic',[],...
    'R_index',[],'R_val',[],'redundancy',[]...
    ,'Q_index',[],'Q_val',[],'S_index',[],'S_val',[],'subject',[]);
is_noisie=zeros(1,N);
is_noisie(1)=1;
fprintf(...
    'pre-processing all the data, it may take a while (about 2 minutes)\n');

for i=1:N
   fprintf('subject %d out of %d...\n',i,N);
   [S_p,blw_delay]=pre_prosesing(S_data(i),Fs,is_noisie(i)) ;
   S_pre(i).ecg=S_p.ecg;
   S_pre(i).energy=S_p.energy;
   S_pre(i).ecg_logic=S_p.ecg_logic;
   S_pre(i).R_index=S_p.R_index;
   S_pre(i).R_val=S_p.R_val;
   S_pre(i).redundancy=S_p.redundancy;
   S_pre(i).Q_index=S_p.Q_index;
   S_pre(i).Q_val=S_p.Q_val;
   S_pre(i).S_index=S_p.S_index;
   S_pre(i).S_val=S_p.S_val;
   S_pre(i).subject=S_data(i).subject;
end
%% feture exrtraction
S_fetures(1:10)=struct('X',[]);
N_test_b=0;
for i=1:10
  S_fetures(i).X=feture_extraction(S_pre(i)); 
  if(i>6)
    N_test_b=N_test_b+length(S_fetures(i).X(:,1));
  end
end

%% label data
S_label(1:10)=struct('label',[],'subject',[]);
for i=1:N
    S_label(i).label=label_data...
        ( S_data(i).info,S_pre(i).R_index,S_pre(i).redundancy,blw_delay );
    S_label(i).subject=S_data(i).subject;
end

%% order data
training_set_pvc2=1:2:13;
training_set_normal=[11:50:461,1100:50:1300];
validation_set_pvc=2:2:14;
validation_set_normal=[600:50:1050,1400:20:1480];
N_fetures=length(S_fetures(1).X(1,:));
N_train=(length(training_set_pvc2)+length(training_set_normal))*6;
N_validation=(length(validation_set_pvc)+length(validation_set_normal))*6;
training_set=zeros(N_train,N_fetures);
training_label=zeros(N_train,1);
validation_set=zeros(N_validation,N_fetures);
validation_label=zeros(N_validation,1);
testing_set=zeros(N_test_b,N_fetures);
testing_label=zeros(N_test_b,1);
train_subject=training_label;
val_subject=validation_label;
test_subject=testing_label;
i_tr=1;
i_v=1;
i_te=1;
for i=1:N
    X=S_fetures(i).X;
    L=S_label(i).label;
    if i<7
        normal_index=find(L==0);
        pvc_index=find(L==1);
        training_set(i_tr:i_tr+14,:)=X(normal_index(training_set_normal),:);
        training_label(i_tr:i_tr+14)=L(normal_index(training_set_normal));
        train_subject(i_tr:i_tr+14)=S_data(i).subject;
        i_tr=i_tr+15;
        training_set(i_tr:i_tr+6,:)=X(pvc_index(training_set_pvc2),:);
        training_label(i_tr:i_tr+6)=L(pvc_index(training_set_pvc2));
        train_subject(i_tr:i_tr+6)=S_data(i).subject;
        i_tr=i_tr+7;
        validation_set(i_v:i_v+14,:)=X(normal_index(validation_set_normal),:);
        validation_label(i_v:i_v+14)=L(normal_index(validation_set_normal));
        val_subject(i_v:i_v+14)=S_data(i).subject;
        i_v=i_v+15;
        validation_set(i_v:i_v+6,:)=X(pvc_index(validation_set_pvc),:);
        validation_label(i_v:i_v+6)=L(pvc_index(validation_set_pvc));
        val_subject(i_v:i_v+6)=S_data(i).subject;
        i_v=i_v+7;
    else
        N_X=length(X);
        testing_set(i_te:i_te+N_X-1,:)=X;
        testing_label(i_te:i_te+N_X-1)=L;
        test_subject(i_te:i_te+N_X-1)=S_data(i).subject;
        i_te=i_te+N_X;
    end
end
%% feture selection
[ K,fetures ] = feture_selection(training_set,training_label,...
    validation_set,validation_label );
%% test
Predict=KNN( K,fetures,training_set,training_label,testing_set );

%% system evaluation
% data sets tabels
train_table=array2table(zeros(6,3)...
    ,'VariableNames',{'Subject','PVC_beats','Normal_beats'});
train_sub=[105,109,118,119,200,202];
for i=1:6
   train_table.Subject(i)=train_sub(i);
   PVC_beats=...
   sum(training_label((train_subject==train_sub(i)))==1);
   train_table.Normal_beats(i)=...
   sum(training_label((train_subject==train_sub(i)))==0);
end
val_table=array2table(zeros(6,3)...
    ,'VariableNames',{'Subject','PVC_beats','Normal_beats'});
val_sub=[105,109,118,119,200,202];
for i=1:6
   val_table.Subject(i)=val_sub(i);
   val_table.PVC_beats(i)=...
   sum(validation_label((val_subject==val_sub(i)))==1);
   val_table.Normal_beats(i)=...
   sum(validation_label((val_subject==val_sub(i)))==0);
end
test_table=array2table(zeros(4,3)...
    ,'VariableNames',{'Subject','PVC_beats','Normal_beats'});
test_sub=[210,214,221,223];
for i=1:4
   test_table.Subject(i)=test_sub(i);
   test_table.PVC_beats(i)=...
   sum(testing_label((test_subject==test_sub(i)))==1);
   test_table.Normal_beats(i)=...
   sum(testing_label((test_subject==test_sub(i)))==0);
end

% evaluation table
evaluation_table=array2table(zeros(5,9)...
    ,'VariableNames',{'Subject','PVC_beats','PVC_detect',...
    'Normal_beats','Normal_detect','sensitivity','positive_predictive',...
    'spesicifity','accurasy'});
for i=1:4
   evaluation_table.Subject(i)=test_sub(i);
   evaluation_table.PVC_beats(i)=test_table.PVC_beats(i);
   evaluation_table.Normal_beats(i)=test_table.Normal_beats(i);
   TP=sum((testing_label((test_subject==test_sub(i)))==1).*...
       (Predict((test_subject==test_sub(i)))==1));
   evaluation_table.PVC_detect(i)=TP;
   TN=sum((testing_label((test_subject==test_sub(i)))==0).*...
       (Predict((test_subject==test_sub(i)))==0));
   evaluation_table.Normal_detect(i)=TN;
   if(evaluation_table.PVC_beats(i))
       sensitivity=TP/evaluation_table.PVC_beats(i);
       evaluation_table.sensitivity(i)=sensitivity;
   end
   if(evaluation_table.PVC_beats(i))
       pp=TP/sum((Predict((test_subject==test_sub(i)))==1));
       evaluation_table.positive_predictive(i)=pp;
   end
   if(evaluation_table.PVC_beats(i))
        spesicifity=TN/evaluation_table.Normal_beats(i);
        evaluation_table.spesicifity(i)=spesicifity;
   end
   evaluation_table.accurasy(i)=sum(Predict((test_subject==test_sub(i)))...
   ==testing_label(test_subject==test_sub(i)))/...
   sum(test_subject==test_sub(i));
end
evaluation_table.PVC_beats(5)=sum(evaluation_table.PVC_beats(1:4));
evaluation_table.Normal_beats(5)=sum(evaluation_table.Normal_beats(1:4));
total_TP=sum(evaluation_table.PVC_detect(1:4));
total_TN=sum(evaluation_table.Normal_detect(1:4));
total_sensitivity=total_TP/sum(evaluation_table.PVC_beats(1:4));
total_spesicifity=total_TN/sum(evaluation_table.Normal_beats(1:4));
total_pp=total_TP/sum(Predict==1);

evaluation_table.PVC_detect(5)=total_TP;
evaluation_table.Normal_detect(5)=total_TN;
evaluation_table.sensitivity(5)=total_sensitivity;
evaluation_table.positive_predictive(5)=total_pp;
evaluation_table.spesicifity(5)=total_spesicifity;

total_accuracy=sum(Predict==testing_label)/length(Predict);
evaluation_table.accurasy(5)=total_accuracy;
%% test with papper fetures
papper_Predict=KNN( 5,[0,1,1,1,1,1,0,0,0,0],training_set,training_label,testing_set );
%% papper fetures evaluation
papper_evaluation_table=array2table(zeros(5,9)...
    ,'VariableNames',{'Subject','PVC_beats','PVC_detect',...
    'Normal_beats','Normal_detect','sensitivity','positive_predictive',...
    'spesicifity','accurasy'});
for i=1:4
   papper_evaluation_table.Subject(i)=test_sub(i);
   papper_evaluation_table.PVC_beats(i)=test_table.PVC_beats(i);
   papper_evaluation_table.Normal_beats(i)=test_table.Normal_beats(i);
   TP=sum((testing_label((test_subject==test_sub(i)))==1).*...
       (papper_Predict((test_subject==test_sub(i)))==1));
   papper_evaluation_table.PVC_detect(i)=TP;
   TN=sum((testing_label((test_subject==test_sub(i)))==0).*...
       (papper_Predict((test_subject==test_sub(i)))==0));
   papper_evaluation_table.Normal_detect(i)=TN;
   if(papper_evaluation_table.PVC_beats(i))
       sensitivity=TP/papper_evaluation_table.PVC_beats(i);
       papper_evaluation_table.sensitivity(i)=sensitivity;
   end
   if(papper_evaluation_table.PVC_beats(i))
       pp=TP/sum((papper_Predict((test_subject==test_sub(i)))==1));
       papper_evaluation_table.positive_predictive(i)=pp;
   end
   if(papper_evaluation_table.PVC_beats(i))
        spesicifity=TN/papper_evaluation_table.Normal_beats(i);
        papper_evaluation_table.spesicifity(i)=spesicifity;
   papper_evaluation_table.accurasy(i)=...
       sum(papper_Predict((test_subject==test_sub(i)))...
       ==testing_label(test_subject==test_sub(i)))/...
   sum(test_subject==test_sub(i));
   end
end
papper_evaluation_table.PVC_beats(5)=...
    sum(papper_evaluation_table.PVC_beats(1:4));
papper_evaluation_table.Normal_beats(5)=...
    sum(papper_evaluation_table.Normal_beats(1:4));
papper_total_TP=...
    sum(papper_evaluation_table.PVC_detect(1:4));
papper_total_TN=...
    sum(papper_evaluation_table.Normal_detect(1:4));
papper_total_sensitivity=...
    papper_total_TP/sum(papper_evaluation_table.PVC_beats(1:4));
papper_total_spesicifity=...
    papper_total_TN/sum(papper_evaluation_table.Normal_beats(1:4));
papper_total_pp=papper_total_TP/sum(papper_Predict==1);

papper_evaluation_table.PVC_detect(5)=papper_total_TP;
papper_evaluation_table.Normal_detect(5)=papper_total_TN;
papper_evaluation_table.sensitivity(5)=papper_total_sensitivity;
papper_evaluation_table.positive_predictive(5)=papper_total_pp;
papper_evaluation_table.spesicifity(5)=papper_total_spesicifity;

papper_total_accuracy=...
    sum(papper_Predict==testing_label)/length(papper_Predict);
papper_evaluation_table.accurasy(5)=papper_total_accuracy;
%% figures for Doc




ecg1=S_pre(1).ecg;
R_index1=S_pre(1).R_index;
R_val1=S_pre(1).R_val;
red1=S_pre(1).redundancy;
t1=linspace(0,(length(ecg1)-1)/Fs,length(ecg1));% time vactor
figure;%% figurre of pre-prosses noicie ecg 
plot(t1,ecg1);hold on;
plot((R_index1(red1==1)-1)/Fs,R_val1(red1==1),'*');hold on;
plot((R_index1(red1==0)-1)/Fs,R_val1(red1==0),'*');
xlim([1284,1292]);
title('subject 105 ECG pre-prossesing with R ditection')
xlabel('time [s]')
ylabel('voltage [mv]')
legend('ECG','Redundant R','Relevant R');


ecg2=S_pre(2).ecg;
R_index2=S_pre(2).R_index;
R_val2=S_pre(2).R_val;
red2=S_pre(2).redundancy;
Q_index2=S_pre(2).Q_index;
Q_val2=S_pre(2).Q_val;
S_index2=S_pre(2).S_index;
S_val2=S_pre(2).S_val;
t2=linspace(0,(length(ecg2)-1)/Fs,length(ecg2));% time vactor
figure;%% figurre of pre-prosses noicie ecg 
plot(t2,ecg2);hold on;
plot((Q_index2-1)/Fs,Q_val2,'*');hold on;
plot(((R_index2(red2==0))-1)/Fs,(R_val2(red2==0)),'*');hold on;
plot((S_index2-1)/Fs,S_val2,'*');
xlim([352,358]);
title('subject 109 ECG pre-prossesing with Q R S ditection')
xlabel('time [s]')
ylabel('voltage [mv]')
legend('ECG','Q','R','S');


ecg8=S_pre(8).ecg;
R_index8=S_pre(8).R_index;
R_val8=S_pre(8).R_val;
red8=S_pre(8).redundancy;
R_relvant_index8=R_index8(red8==0);
R_relvant_val8=R_val8(red8==0);
t8=linspace(0,(length(ecg2)-1)/Fs,length(ecg2));% time vactor
pvc_index8=R_relvant_index8(Predict(test_subject==214)==1)';
pvc_val8=R_relvant_val8(Predict(test_subject==214)==1)';
normal_index8=R_relvant_index8(Predict(test_subject==214)==0)';
normal_val8=R_relvant_val8(Predict(test_subject==214)==0)';

figure;% figurre of pvc corect detaction
plot(t8,ecg8);hold on;
plot((pvc_index8-1)/Fs,pvc_val8,'*');hold on;
plot((normal_index8-1)/Fs,normal_val8,'*');hold on;
xlim([390,396]);
title('subject 214 ECG PVC ditection')
xlabel('time [s]')
ylabel('voltage [mv]')
legend('ECG','PVC beat','Normal beat','Location','south');




ecg9=S_pre(9).ecg;
R_index9=S_pre(9).R_index;
R_val9=S_pre(9).R_val;
red9=S_pre(9).redundancy;
R_relvant_index9=R_index9(red9==0);
R_relvant_val9=R_val9(red9==0);
t9=linspace(0,(length(ecg2)-1)/Fs,length(ecg2));% time vactor
pvc_index9=R_relvant_index9(Predict(test_subject==221)==1)';
pvc_val9=R_relvant_val9(Predict(test_subject==221)==1)';
normal_index9=R_relvant_index9(Predict(test_subject==221)==0)';
normal_val9=R_relvant_val9(Predict(test_subject==221)==0)';

figure;%% figurre of pvc corect detaction
plot(t9,ecg9);hold on;
plot((pvc_index9-1)/Fs,pvc_val9,'*');hold on;
plot((normal_index9-1)/Fs,normal_val9,'*');hold on;
 xlim([238,242.5]);
title('subject 221 ECG PVC ditection')
xlabel('time [s]')
ylabel('voltage [mv]')
legend('ECG','PVC beat','Normal beat','Location','southeast');




ecg10=S_pre(10).ecg;
R_index10=S_pre(10).R_index;
R_val10=S_pre(10).R_val;
red10=S_pre(10).redundancy;
R_relvant_index10=R_index10(red10==0);
R_relvant_val10=R_val10(red10==0);
t10=linspace(0,(length(ecg2)-1)/Fs,length(ecg2));% time vactor
pvc_index10=R_relvant_index10(Predict(test_subject==223)==1)';
pvc_val10=R_relvant_val10(Predict(test_subject==223)==1)';
normal_index10=R_relvant_index10(Predict(test_subject==223)==0)';
normal_val10=R_relvant_val10(Predict(test_subject==223)==0)';

figure;%% figurre of pvc corect detaction
plot(t10,ecg10);hold on;
plot((pvc_index10-1)/Fs,pvc_val10,'*');hold on;
plot((normal_index10-1)/Fs,normal_val10,'*');hold on;
xlim([576,586]);
title('subject 223 ECG PVC ditection')
xlabel('time [s]')
ylabel('voltage [mv]')
legend('ECG','PVC beat','Normal beat','Location','southwest');
%%







