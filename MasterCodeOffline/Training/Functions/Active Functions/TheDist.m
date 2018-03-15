%This function returns the calculated class, by returning the smallest
%distance to mean, found
function [class]= TheDist(ClassMean,Crow,type_dist)
class=zeros(length(Crow),1);% initialising the class prediction to the number of classes
temp=zeros(1,length(ClassMean));
for i=1:length(Crow)
    tst=Crow(1,i);
    tst=tst{:,:};%Holds the trials out of the entire class
    for j=1:length(ClassMean)
        mn=ClassMean(1,j);
        mn=mn{:,:};%Holds the mean value
        temp(1,j)=distance(mn,tst,type_dist); %Fills distances of trial with all means
    end
    [~,indx]= min(temp);%The minimum of this is the mean
    class(i,1)=indx;%%The index of the minimum element is returned
end
end

       