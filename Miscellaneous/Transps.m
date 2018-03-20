%% This Function transposes each element of a cell of depth 1
function[X]= Transps(X)
[len, bred, ~]=size(X);
for i=1:len
    for j=1:bred
        
        temp=X{i,j};
        temp=temp';
        X{i,j}=temp;
    end
end