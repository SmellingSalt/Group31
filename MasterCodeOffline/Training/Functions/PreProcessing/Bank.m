function[X]= Bank(X,snrboost)
[len, bredx, ~]=size(X);
for i=1:len
    for j=1:bredx
       X{i,j}=X{i,j}/sqrt(sum(sum(X{i,j}.^2).^2)); %Normalising the signal
       temp1=X{i,j};                     %Temp is one of the EEG Epochs, X{i,j}
       temp2=temp1;
       temp3=temp1;
       temp4=temp1;
       temp5=temp1;
       temp6=temp1;
       temp7=temp1;
       [~, bred]=size(temp1); 
        
       for k=1:bred
        temp1(:,k)=cheby17_1(temp1(:,k));   %BandPass filtering each column of temp
        temp2(:,k)=cheby13_1(temp2(:,k));   %BandPass filtering each column of temp
        temp3(:,k)=cheby21_1(temp3(:,k));   %BandPass filtering each column of temp
        temp4(:,k)=cheby0_1(temp4(:,k));    %Low Pass to extract 0 Hz
        
        temp5(:,k)=cheby34_1(temp1(:,k));   %BandPass filtering each column of temp
        temp6(:,k)=cheby26_1(temp2(:,k));   %BandPass filtering each column of temp
        temp7(:,k)=cheby42_1(temp3(:,k));   %BandPass filtering each column of temp
        
        
       end
       t=1;
       temp=(t*(temp1+temp2+temp3+temp5+temp6+temp7)+temp4)/sqrt(sum(6*t^2+1));
      if snrboost==0
            X{i,j}=temp*sqrt(sum(sum(X{i,j}.^2).^2));
      else    
            X{i,j}=(temp+X{i,j})/(2*sqrt(sum(sum(X{i,j}.^2).^2)));
      end
      
    end
end

    
end

