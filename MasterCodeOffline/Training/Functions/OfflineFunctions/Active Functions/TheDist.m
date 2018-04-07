%This function computes the class, by returning the smallest distance to mean, found
%ClassMean is the collection of class centers
%Crow is the cell structure with the unkown EEG Data
function [class1,class2,class3]= TheDist(ClassMean,Crow,type_dist)
class1=zeros(length(Crow),1);% initialising the class prediction to the number of classes
class2=zeros(length(Crow),1);% initialising the second class prediction to the number of classes
class3=zeros(length(Crow),1);% initialising the second class prediction to the number of classes
temp=zeros(1,length(ClassMean));
for i=1:length(Crow)
    tst=Crow(1,i);
    tst=tst{:,:};                                                %Holds the trials out of the entire class
    for j=1:length(ClassMean)
        mn=ClassMean(1,j);
        mn=mn{:,:};                                              %Holds the mean value
        if isempty(tst)                                          %If the cell is empty, then there will be a problem so we manually add zeros
           tst=zeros(length(mn),length(mn));    
           temp(1,j)=distance(mn,tst,type_dist);
        else
            if (sum(sum(tst))~=0)
                temp(1,j)=distance(mn,tst,type_dist);                    %Fills distances of trial with all means
            else
                continue;
            end
        end
    end
    if isempty(temp)
     class1(i,1)=0;
     class2(i,1)=0;
     class3(i,1)=0;
    else
    temp=temp(temp>-1);                                          %Removing negative distances
    [~,indx1]= min(temp);                                        %The minimum of this is the mean
    class1(i,1)=indx1;                                           %The index of the minimum element is returned
    
    temp(1,indx1)=temp(1,indx1)+max(temp);
    [~,indx2]= min(temp);                                      %The second smallest of temp
    class2(i,1)=indx2;                                         %The index of the second smallest element is returned
    
    temp(1,indx2)=temp(1,indx2)+max(temp);
    [~,indx3]= min(temp);                                      %The second smallest of temp
    class3(i,1)=indx3;                                         %The index of the second smallest element is returned
    end
end
end

       