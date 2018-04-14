a='riemann';
[len, bred, depth]=size(Cr);
for i=1:depth
    for j=1:len
        Crow=Cr(j,:,i);
        [temp1,temp2]=Differential(ClassMean,Crow,D,a);         %Each column is for a GDF File, each row is the reult of the Differential of the epoch.
        result{j,i}=temp1;
        sums{j,i}=temp2;
    end
end