%This function returns the accuracy of classes, taking in 'a' as the type
%of distance to be used to test
function [acc,output]= ClassAccuracy(ClassMean,Ctest,a)
[~,bred,depth]=size(Ctest);
acc=zeros(1,length(ClassMean));
hits=0;                                     %Number of class hits
coulumnindex=0;
output=zeros(length(ClassMean),bred*depth*length(ClassMean));
for i=1:length(ClassMean)       
    for j=1:depth
        Crow=Ctest(i,:,j);                  %Taking the entire row of the trials 'i', for GDF file 'j'
        class=TheDist(ClassMean,Crow,a);    %Gives the predicted class of each of the trials in the
                                            %row of the single covariance data structure
        for k=1:bred                                 
            classindex=class(k,1);
            coulumnindex=coulumnindex+1;                   %(j-1)*bred+k;
            output(classindex,coulumnindex)=1;  %To accomodate the other gdf files    
            
        end
        count=class(class==i);              %sets count to the values of the class 
        hits=hits+length(count);            %Adds up all the hits in that particular class, so far
        acc(1,i)=hits/(length(class)*depth);%divides hits by total classes=depth*classes
    end
    hits=0;                                 %Resetting hits for next class
end
acc=acc*100;
