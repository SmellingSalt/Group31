%% Load trials of one human subject
% Store all the SSVEP sessions of a person in one location and access all
% of them from there.
% X holds all the extracted EEG data
clear
clc
p1=genpath('Functions');
addpath(p1);
TrainPath='..\..\DataSet\From the Internet\4\subject10\Training GDF\*.gdf';
%TrainPath='..\..\DataSet\Old BCI Data\fyp2016data\gdf\Indra\*.gdf';
%TrainPath='C:\Users\Sawan Singh Mahara\Desktop\New folder1\*.gdf';
nbrClasses=[13,21];
[X,debug, timestamp,classes]=SubjectEEG(TrainPath,nbrClasses);              % extracts the eeg data from all gdf files in the folder
%% Covariance Matrix
% The covariance matrix is constructed here and then the center of the
% clusters is also computed. The tangent space projection of the matrices
% are also obtained
C=EEGtoCov(X,classes);                                                      % compute covariance matrix of each trail and store in corresponding location
[SubjectMean,feat]=CovMean(C);                                              % returns the Cluster center/mean Covariance matrix of the subject
                                                                            % before outlier removal

%% Outlier Removal
%This is a crude optimisation to remove outliers
Co=OutlierRemoval(C,'riemann','riemann',SubjectMean);
[ClassMean, TanSpace]=CovMean(C);                                           % returns the Cluster center/mean Covariance matrix
%% Testing
% This part tests the obtained centers with 8 trails for each class
TestPath='..\..\DataSet\From the Internet\4\subject10\Testing GDF\*.gdf';
%TestPath='..\..\DataSet\Old BCI Data\fyp2016data\gdf\Indra\*.gdf';
%TestPath='C:\Users\Sawan Singh Mahara\Desktop\New folder1\*.gdf';
test=SubjectEEG(TestPath,nbrClasses);
Ctest=EEGtoCov(test,classes);
% [row,col,depth]=size(Ctest);
% ct=cell(row,col*depth,1);
%a={'riemann','kullback','logeuclid','opttransp','ld',''};
AccR=ClassAccuracy(ClassMean, Ctest,'riemann');
AccK=ClassAccuracy(ClassMean, Ctest,'kullback');
AccL=ClassAccuracy(ClassMean, Ctest,'logeuclid');
AccO=ClassAccuracy(ClassMean, Ctest,'opttransp');
AccLd=ClassAccuracy(ClassMean, Ctest,'ld');
Acc=ClassAccuracy(ClassMean, Ctest,'');

%% Plotting
% This section plots the accuracy data                  
x=strtrim(cellstr(num2str(nbrClasses'))');                                  %Converts numbers to string
x=strcat(x,'Hz');
x=categorical(x);   
subplot(2,2,1);

bar(x,AccR,0.25,'c')
ylim([0 100]);                                                              %Bar Graph Height
ylabel('Accuracy %');           
text(1:length(AccR),AccR,num2str(AccR'),'vert','bottom','horiz','center');  %Sets numbers on top of graph
title('Riemann Distance Test');
grid minor;

subplot(2,2,2);
bar(x,AccK,0.25,'r')
ylim([0 100]);
ylabel('Accuracy %');
text(1:length(AccK),AccK,num2str(AccK'),'vert','bottom','horiz','center'); 
title('Kullback Lieber Distance Test');
grid minor;

subplot(2,2,3);
bar(x,AccL,0.25,'k')
ylim([0 100]);
ylabel('Accuracy %');
text(1:length(AccL),AccL,num2str(AccL'),'vert','bottom','horiz','center'); 
title('Log-Euclidean Distance Test');
grid minor;

subplot(2,2,4);
bar(x,Acc,0.25,'g')
ylim([0 100]);
ylabel('Accuracy %');
text(1:length(Acc),Acc,num2str(Acc'),'vert','bottom','horiz','center'); 
title('Euclidean Distance Test');
grid minor;
suptitle('Classification Results')
