%% Epoch Predictor
% This function takes a set of epochs and analyses it according to
% kalunga's paper and predicts it as a particular class
function[predic,yes]=EpochPredictor(Krn,classes)

predic=zeros(length(Krn),1);
count=zeros(length(Krn),1);
prob=zeros(length(Krn),1);
yes=zeros(length(Krn),1);
for i=1:length(Krn)
    [predic(i,1),count(i,1),prob(i,1),yes(i,1)]=ProbThresh(Krn{i,1},0.6);
end

class=zeros(length(classes),1);
for i=1:length(classes)
    class(i,1)=code(classes(i,1));
end
predic(predic==1)=class(1,1);
predic(predic==2)=class(2,1);
predic(predic==3)=class(3,1);
predic(predic==4)=class(4,1);