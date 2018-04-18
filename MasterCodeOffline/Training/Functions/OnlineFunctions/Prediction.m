%% Prediction
% This function takes a single covariance matrix C and classifies it into
% one of the classes in 'means'

%'K' is the matrix holding predictions of GDF files in the rows, the
% columns hold predictions of each gdf file

%ClassMean is the collection of class centers
%Crow is the cell structure with the unkown EEG Data
function [predic,yes]= Prediction(ClassMean,Ctest,classes,a)
[epochs,~,depth]=size(Ctest);
for j=1:depth       
    for i=1:epochs
        Crow=Ctest(i,:,j);                    %Taking the entire row of the trials 'i', for GDF file 'j'
        if isempty(Crow{1,1})
            break;
        else
        [K{i,1,j}, K{i,2,j},K{i,3,j}]=TheDist(ClassMean,Crow,a);   %K holds the predicted class of each of the epochs in the GDF file
        end
    end
    
end
[len,bred]=size(K);
for i=1:bred
    for j=1:len
        [predic(j,i),yes(j,i)]=EpochPredictor(K(j,i),classes); %Predictions are stored rowwise per gdf file which is columnwise
    end
end       