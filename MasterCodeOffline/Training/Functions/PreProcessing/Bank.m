function[X]= Bank(X,snrboost)
[len, bredx, ~]=size(X);
for i=1:len
    for j=1:bredx
       temp1=X{i,j};                     %Temp is one of the EEG Epochs, X{i,j}
       temp2=temp1;
       temp3=temp1;
       temp4=temp1;
       [~, bred]=size(temp1); 
        
       for k=1:bred
        temp1(:,k)=cheby17_1(temp1(:,k));   %BandPass filtering each column of temp
        temp2(:,k)=cheby13_1(temp2(:,k));   %BandPass filtering each column of temp
        temp3(:,k)=cheby21_1(temp3(:,k));   %BandPass filtering each column of temp
        temp4(:,k)=cheby0_1(temp4(:,k));    %Low Pass to extract 0 Hz
       end
       t=100;
       temp=(t*temp1+t*temp2+t*temp3+temp4)/sqrt(sum(3*t^2+1));
      if snrboost==0
            X{i,j}=temp;
        else    
            X{i,j}=(temp+X{i,j})/sqrt(2);
      end
    end
end

    
end

