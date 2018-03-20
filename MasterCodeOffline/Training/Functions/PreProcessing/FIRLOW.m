function[X]= FIRLOW(X,snrboost)
[len, bred]=size(X);
X1=X;

for i=1:len
    for j=1:bred
        temp=X{i,j};                     %Temp is one of the EEG Epochs, X{i,j}
       [~, bred1]=size(temp); 
        
       for k=1:bred1
        temp(:,k)=LowPass(temp(:,k));    %LowPass filtering each column of temp
       end
       
      if snrboost==0
            X{i,j}=temp;
        else    
            X{i,j}=(temp+X{i,j})/2;
      end
    end
end
end