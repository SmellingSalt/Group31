%% Differential
% This function returns the derivative of each of the matricies in 'epochs',
% with respect to all the ClassMeans. The result has the differentials
% w.r.t each mean in the rows.
function [result,totsum]=Differential(ClassMean,epochs,D,a)
result=zeros(length(ClassMean),D-1);
for i=1:length(ClassMean)
    ClassM=ClassMean{:,:,i};
    for j=2:D
        if isempty(epochs{1,j-1})||isempty(epochs{1,j})
            continue;
        elseif ~sum(all(epochs{1,j-1}))||~sum(all(epochs{1,j}))
            continue;
        else
            normalising=0;
            for k=1:length(ClassMean)
                normalising=distance(epochs{1,j},ClassMean{:,:,k},a)+normalising;                         
            end
            result(i,j-1)=(distance(epochs{1,j},ClassM,a)-distance(epochs{1,j-1},ClassM,a))./normalising;
        end
        
    end
end
result=result';
totsum=sum(result);
totsum=totsum';
result=result';
end