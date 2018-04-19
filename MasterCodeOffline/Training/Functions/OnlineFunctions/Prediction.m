%% Prediction
% This function takes a single covariance matrices Ctest and classifies all of them appropriately into
% one of the classes in 'means'

%'K' is the matrix holding predictions of GDF files in the rows, the
% columns hold predictions of each gdf file

%ClassMean is the collection of class centers
%Crow is the cell structure with the unkown EEG Data
function [Predictions,yes]= Prediction(ClassMean,Ctest,classes,a,windw,thresh)
 %% Raw Prediction
% Just applying offline algorithm and predicting
 [epochs,~]=size(Ctest);      
for i=1:epochs
    Crow=Ctest(i,:);                                                   %Taking the entire row of the trials 'i', for GDF file 'j'
    if isempty(Crow{1,1})
        break;
    else
        [K{i,1}, ~,~]=TheDist(ClassMean,Crow,a);                      %K holds the predicted class of each of the epochs in the GDF file
    end
end
%% Large Epoch Prediction
% Thresholding and Predicting

[len,bred]=size(K);
for i=1:bred
    for j=1:len
        [predic(j,i),yes(j,i)]=EpochPredictor(K(j,i),thresh);                %Predictions are stored rowwise per gdf file which is columnwise
    end
end

%% Curve Movement
% Using The movement of the differenetials to classify and hold predictions
   
for i=1:epochs
    if ~exist('VarName')
        if predic(i,1)<0
            continue;
        else
            VarName=0;
        end
        
    else
        Crow=Ctest(i,:);                                                   %Taking the entire row of the trials 'i', for GDF file 'j'
        if isempty(Crow{1,1})
            break;
        else
            [Predictions(i,1)]=EpochClassifier(Crow,a,ClassMean,windw,predic(i,1),yes(i,1),classes);             %K holds the predicted class of each of the epochs in the GDF file
        end
    end
end
%% Holds and Noise
% Replacing Hold with the previous value and replacing noise with class
% 0 if it is there and no SSVEP If it isn't. Also, -10 is hold

Predictions(1,1)=classes(1,1);
for i=2:length(Predictions)
    switch Predictions(i,1)
        case -10
            Predictions(i,1)=Predictions(i-1,1);
        case -1
             Predictions(i,1)=Predictions(i-1,1);
%             if ~isempty(classes(classes==33024))
%                 Predictions(i,1)=classes(1,1);
%             else
%                 Predictions(i,1)=Predictions(i-1,1);
%             end
        otherwise
            continue;
    end
end

end