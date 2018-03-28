%This function returns the accuracy of classes, taking in 'a' as the type
%of distance to be used to test
function [acc]= ClassAccuracy(ClassMean,Ctest,a)
[~,~,depth]=size(Ctest);
acc=zeros(1,length(ClassMean));
hits=0;                                     %Number of class hits
for i=1:length(ClassMean)       
    for j=1:depth
        Crow=Ctest(i,:,j);                  %Taking the entire row of the trials 'i', for GDF file 'j'
        class=TheDist(ClassMean,Crow,a);    %Gives the predicted class of each of the trials in the
                                            %row of the single covariance data structure
        count=class(class==i);              %sets count to the values of the class 
        hits=hits+length(count);            %Adds up all the hits in that particular class, so far
        acc(1,i)=hits/(length(class)*depth);%divides hits by total classes=depth*classes
    end
    hits=0;                                 %Resetting hits for next class
end
acc=acc*100;

