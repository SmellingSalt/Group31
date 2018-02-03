%%% Demo of MLR for SSVEP Recognition in comparison with CCA, MCCA, CFA %%%

% Notes: MCCA requires tensor toolbox that can be downloaded at:
%        http://www.sandia.gov/~tgkolda/TensorToolbox/index-2.6.html
%        CFA requires a toolbox that can be downloaded at:
%        http://bsp.brain.riken.jp/~zhougx/cifa.html
% To run MCCA and CFA, you need to download the two toolboxes and add them into matlab path.
%
% By Yu Zhang and Haiqiang Wang, ECUST, 2015.
% Email: yuzhang@ecust.edu.cn


clc;
clear all;
close all;

% B = permute(A,order)
% iSSVEPdata=EEGSignals.Trials(:,:,:,[2:4]);
% SSVEPdata=permute(iSSVEPdata,[2 1 3 4]);
load issvep;


%% Initialization
method={'CCA'};   % method={'CCA','MLR'};
n_meth=length(method);
n_ch=size(SSVEPdata,1);
Fs=250;                                  % sampling rate
N=2;                                     % number of harmonics
t_length=5;                              % analysis window length
TW=0.5:0.5:t_length;
TW_p=round(TW*Fs);
n_run=size(SSVEPdata,1);                 % number of used runs
sti_f=[10 15 12];                        % stimulus frequencies
n_sti=length(sti_f);                     % number of stimulus frequencies

% Reference signals
refSignals=ck_signal_fyp(sti_f);
sc1=refSignals(:,:,1);
sc2=refSignals(:,:,2);
sc3=refSignals(:,:,3);
n_correct=zeros(length(TW),n_meth);


%% Classify
for run=1:n_run      % leave-one-run-out cross-validation
    idx_traindata=1:n_run;
    idx_traindata(run)=[];
    for mth=1:n_meth
        for tw_length=1:length(TW)
            switch method{mth}
                case 'CCA'
                    fprintf('CCA Processing TW %fs, No.crossvalidation %d \n',TW(tw_length),run);
                    % recognize SSVEP
                    for j=1:n_sti
                        [wx1,wy1,r1]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),sc1(:,1:TW_p(tw_length)));
                        [wx2,wy2,r2]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),sc2(:,1:TW_p(tw_length)));
                        [wx3,wy3,r3]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),sc3(:,1:TW_p(tw_length)));
                        [v,idx]=max([max(r1),max(r2),max(r3)]);
                        if idx==j
                            n_correct(tw_length,mth)=n_correct(tw_length,mth)+1;
                        end
                    end
                    
                case 'MCCA'
                    fprintf('MCCA Processing TW %fs, No.crossvalidation %d \n',TW(tw_length),run);
                    max_iter=200;
                    n_comp=1;
                    iniw3=ones(length(idx_traindata),1);
                    % run mcca to find projection matrices
                    [w11,w13,v11,cor1]=mcca(sc1(:,1:TW_p(tw_length)),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,1),max_iter,iniw3,n_comp);
                    [w21,w23,v21,cor2]=mcca(sc2(:,1:TW_p(tw_length)),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,2),max_iter,iniw3,n_comp);
                    [w31,w33,v31,cor3]=mcca(sc3(:,1:TW_p(tw_length)),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,3),max_iter,iniw3,n_comp);
                    [w41,w43,v41,cor4]=mcca(sc4(:,1:TW_p(tw_length)),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,4),max_iter,iniw3,n_comp);
                    % compute optimal reference signals
                    % op_reference 1
                    op_refer1=ttm(tensor(SSVEPdata(:,1:TW_p(tw_length),idx_traindata,1)),w13',3);
                    op_refer1=tenmat(op_refer1,1);
                    op_refer1=op_refer1.data;
                    op_refer1=w11'*op_refer1;
                    % op_reference 2
                    op_refer2=ttm(tensor(SSVEPdata(:,1:TW_p(tw_length),idx_traindata,2)),w23',3);
                    op_refer2=tenmat(op_refer2,1);
                    op_refer2=op_refer2.data;
                    op_refer2=w21'*op_refer2;
                    % op_reference 3
                    op_refer3=ttm(tensor(SSVEPdata(:,1:TW_p(tw_length),idx_traindata,3)),w33',3);
                    op_refer3=tenmat(op_refer3,1);
                    op_refer3=op_refer3.data;
                    op_refer3=w31'*op_refer3;
                    % op_reference 4
                    op_refer4=ttm(tensor(SSVEPdata(:,1:TW_p(tw_length),idx_traindata,4)),w43',3);
                    op_refer4=tenmat(op_refer4,1);
                    op_refer4=op_refer4.data;
                    op_refer4=w41'*op_refer4;
                    % recognize SSVEP
                    pre_Y=zeros(1,4);
                    for j=1:n_sti
                        [wx1,wy1,r1]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),op_refer1);
                        [wx2,wy2,r2]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),op_refer2);
                        [wx3,wy3,r3]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),op_refer3);
                        [wx4,wy4,r4]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),op_refer4);
                        [v,idx]=max([max(r1),max(r2),max(r3),max(r4)]);
                        pre_Y(j)=idx;
                        if idx==j
                            n_correct(tw_length,mth)=n_correct(tw_length,mth)+1;
                        end
                    end
                    
                case 'CFA'
                    fprintf('CFA Processing TW %fs, No.crossvalidation %d \n',TW(tw_length),run);
                    traindata=cat(3,SSVEPdata(:,1:TW_p(tw_length),idx_traindata,1),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,2),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,3),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,4));
                    traindata=permute(traindata,[2 1 3]);
                    traindata=reshape(traindata,n_ch*TW_p(tw_length),76)';
                    trainlabel=[ones(19,1);ones(19,1)*2;ones(19,1)*3;ones(19,1)*4];
                    testdata=cat(3,SSVEPdata(:,1:TW_p(tw_length),run,1),SSVEPdata(:,1:TW_p(tw_length),run,2),SSVEPdata(:,1:TW_p(tw_length),run,3),SSVEPdata(:,1:TW_p(tw_length),run,4));
                    testdata=permute(testdata,[2 1 3]);
                    testdata=reshape(testdata,n_ch*TW_p(tw_length),4)';
                    cobe_opts.cobeAlg='cobec';
                    cobe_opts.subgroups=19;                     % number of spliting for each class
                    cobe_opts.c=1;
                    [label pCOBE CF(cros,:)]=cobe_classify(testdata,traindata,trainlabel,cobe_opts);
                    n_correct(tw_length,mth)=n_correct(tw_length,mth)+sum(label==[1 2 3 4]');
                    
                case 'MLR'
                    fprintf('MLR Processing TW %fs, No.crossvalidation %d \n',TW(tw_length),run);
                    train_rawData=cat(3,SSVEPdata(:,1:TW_p(tw_length),idx_traindata,1),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,2),SSVEPdata(:,1:TW_p(tw_length),idx_traindata,3));
                    test_rawData=cat(3,SSVEPdata(:,1:TW_p(tw_length),run,1),SSVEPdata(:,1:TW_p(tw_length),run,2),SSVEPdata(:,1:TW_p(tw_length),run,3));
                    train_rawData=reshape(train_rawData,n_ch*TW_p(tw_length),size(train_rawData,3));
                    test_rawData=reshape(test_rawData,n_ch*TW_p(tw_length),size(test_rawData,3));
                    MeanTrainData=mean(train_rawData,2);
                    train_rawData=train_rawData-repmat(MeanTrainData,1,15);
                    train_Y=[repmat([1 0 0 0]',1,5) repmat([0 1 0 0]',1,5) repmat([0 0 1 0]',1,5)];
                    clsY=[ones(1,5) ones(1,5)*2 ones(1,5)*3];
                    [Ydim,Num]=size(train_Y);
                    PCA_W=pca_func(train_rawData);
                    train_Data=PCA_W'*train_rawData;
                    train_Data=[ones(1,15);train_Data];
                    W_mlr=MultiLR(train_Data,train_Y);
                    trainFeat=W_mlr'*train_Data;
                    test_rawData=test_rawData-repmat(MeanTrainData,1,3);
                    test_Data=PCA_W'*test_rawData; test_Data=[ones(1,3);test_Data]; 
                    testFeat=W_mlr'*test_Data;
                    label=knnclassify(testFeat',trainFeat',clsY',4,'euclidean');
                    n_correct(tw_length,mth)=n_correct(tw_length,mth)+sum(label==[1 2 3]');
            end
        end
    end
end


%% Plot results
accuracy=100*n_correct/n_sti/n_run;
clor={'-bo','-m*','-gs','-r^'};
for i=1:n_meth
    plot(TW,accuracy(:,i),clor{i});
    hold on
end
legend(method);
title('SSVEP Recognition Accuracy');
xlabel('Time window (s)');
ylabel('Accuracy (%)');
grid;
xlim([0.25 4.25]);
ylim([20 100]);
set(gca,'xtick',TW,'xticklabel',TW);
set(gca,'ytick',20:20:100,'yticklabel',20:20:100);
legend(method);
legend(method,'location','best');

