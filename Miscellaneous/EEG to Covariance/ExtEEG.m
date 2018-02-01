function[X]= ExtEEG(s,h)

%[s,h]=sload('record-[2012.07.06-19.06.14].gdf'); %Possible inputs {classes,s,h}
events=h.EVENT.TYP(:,1); 
samples=h.EVENT.POS(:,1);


%% Template
% Runs a loop to create the template of 31 classes
template=zeros(31,1);
for i=1:31
    template(i,1)=33023+i;
end

clss=zeros(31,1); %Blank array holding 31 zeros

%% Searching for the classes
 % Out of the possible 31 classes, this finds the total number of classes
 % present in data
 for i=1:length(template)
       temp=events(events==template(i,1)); %Stores all the elements from 'events' that are equal to 'template' in temp' 
       if isempty(temp)  %If the class is not present in data, continue
          continue;
       elseif template(i,1)==temp(1,1)    %If the value of this template is found in the data 
             clss(i,1)=template(i,1);     %Store that number/class in cls  
       end 
 end
classes=clss(clss~=0);     %All non zero classes are stored in the main variable, classes
ClssLnth=length(classes);  %Number of classes in data
 

%% Filling the cell
 % Classes in the columns and Trials on the rows
 j=1;
 k=1; %Helps store trials in the column of the cell
  for i=1:ClssLnth
    while(j<length(events))
        if(classes(i,1)==events(j,1))
            strti=j+1;   %Supposed to be index of starting sample
            stpi=j+2;    %Index of ending sample
            sampl1=samples(strti,:);  % Actual sample where class 'i' starts in data
            sampl2=samples(stpi,:);   % Actual sample where class 'i' ends in data
            X{i,k}=s(sampl1:sampl2,:);    % Extracting and storing the samples
            k=k+1;
        end
            j=j+1;
    end
    j=1;
    k=1;
  end