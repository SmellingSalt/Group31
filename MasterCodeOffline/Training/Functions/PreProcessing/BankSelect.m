%% Bank Select
% This function filters the entire epoch to one of the classes it belongs
function[X]= BankSelect(X,snrboost,iter,classes)
[len, bredx, ~]=size(X);
for i=1:len
    for j=1:bredx
       energy=sqrt(sum(sum(X{i,j}.^2).^2));
       X{i,j}=X{i,j}/energy; %Normalising the signal
       temp1=X{i,j};                     %Temp is one of the EEG Epochs, X{i,j}
       temp2=temp1;
       [~, bred]=size(temp1); 
        
       for k=1:bred
        temp1(:,k)=cheby17_1(temp1(:,k));   %BandPass filtering each column of temp
       
            switch classes(iter)
        case 33024
           temp1(:,k)=cheby0_1(temp1(:,k));  
        case 33025
            temp1(:,k)=cheby13_1(temp1(:,k));   %BandPass filtering each column of temp
            temp2(:,k)=cheby26_1(temp1(:,k));   %BandPass filtering each column of temp  
            temp1=(temp1+temp2)/2;
        case 33027
            temp1(:,k)=cheby17_1(temp1(:,k));   %BandPass filtering each column of temp
            temp2(:,k)=cheby34_1(temp1(:,k));   %BandPass filtering each column of temp
            temp1=(temp1+temp2)/2;
        case 33026
            temp1(:,k)=cheby21_1(temp1(:,k));   %BandPass filtering each column of temp
            temp2(:,k)=cheby42_1(temp1(:,k));   %BandPass filtering each column of temp
            temp1=(temp1+temp2)/2;
        otherwise
            temp1(:,k)=temp1(:,k);

           end
      end
       t=1;
      if snrboost==0
            X{i,j}=temp1*energy;
      else    
            X{i,j}=energy*(t*temp1+X{i,j})/2;
      end
      
    end
end

    
end

