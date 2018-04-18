%% Epoch Predictor
% This function takes a set of epochs and analyses it according to
% kalunga's paper and predicts it as a particular class
function[predic,yes]=EpochPredictor(Krn)

predic=zeros(length(Krn),1);
count=zeros(length(Krn),1);
prob=zeros(length(Krn),1);
yes=zeros(length(Krn),1);
for i=1:length(Krn)
    [predic(i,1),count(i,1),prob(i,1),yes(i,1)]=ProbThresh(Krn{i,1},0.6);
end

end