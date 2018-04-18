%% Curve
% This function takes ClassMean and the entire sessions Cr and returns the
% overall movement of the covariance matricies. Results holds the
% differential w.r.t each mean in the rows. The sums holds the sums of the
% differentials w.r.t each mean in each row

function [result,sums]=Curve(ClassMean,Cr,window,a)
D=window(1,3);

[len, ~, depth]=size(Cr);
for i=1:depth
    for j=1:len
        Crow=Cr(j,:,i);
        [temp1,temp2]=Differential(ClassMean,Crow,D,a);         %Each column is for a GDF File, each row is the reult of the Differential of the epoch.
        result{j,i}=temp1;
        sums{j,i}=temp2;
    end
end