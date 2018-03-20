function[X]= Bank(X,snrboost)
[len, bred, ~]=size(X);
for i=1:len
    for j=1:bred
       temp1=X{i,j};                     %Temp is one of the EEG Epochs, X{i,j}
       temp2=temp1;
       temp3=temp1;
       temp4=temp1;
       [~, bred]=size(temp1); 
        
       for k=1:bred
        temp1(:,k)=Band7(temp1(:,k));    %BandPass filtering each column of temp
        temp2(:,k)=Band13(temp2(:,k));   %BandPass filtering each column of temp
        temp3(:,k)=Band21(temp3(:,k));   %BandPass filtering each column of temp
        temp4(:,k)=Band0(temp4(:,k));   %BandPass filtering each column of temp
       end
     
       temp=(temp1+temp2+temp3+temp4)/4;
      if snrboost==0
            X{i,j}=temp;
        else    
            X{i,j}=(temp+X{i,j})/2;
      end
    end
end

    
end

