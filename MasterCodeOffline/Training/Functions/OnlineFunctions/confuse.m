%% confuse
% This function takes the predictions Krn and the actual class of the
% epoch and appropriately makes the confusion matrix
function[target,output]=confuse(Krn,trgt,classes)
target=zeros(length(classes)+2,length(Krn));
output=target;
classes=[classes; -1; -10];
for i=1:length(trgt)
 
    index1= classes==trgt(i,1);
    target(index1,i)=1;
    if Krn(i,1)~=-10
    index2= classes==Krn(i,1);
    output(index2,i)=1;
    else
        index2=length(classes);
        output(index2,i)=1;
    end

end
target=target(:,Krn~=-1);
output=output(:,Krn~=-1);
plotconfusion(target,output);