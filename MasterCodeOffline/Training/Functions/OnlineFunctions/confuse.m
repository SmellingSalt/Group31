%% confuse
% This function takes the predictions Krn and the actual class of the
% epoch and appropriately makes the confusion matrix
function[target,output]=confuse(Krn,trgt,classes)
target=zeros(length(classes),length(Krn));
output=target;
for i=1:length(trgt)
    index1= classes==trgt(i,1);
    target(index1,i)=1;
    index2= classes==Krn(i,1);
    output(index2,i)=1;
end
target=target(:,Krn~=-1);
output=output(:,Krn~=-1);
plotconfusion(target,output);