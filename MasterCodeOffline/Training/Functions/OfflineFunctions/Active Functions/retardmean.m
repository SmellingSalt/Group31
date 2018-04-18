%% Retard Mean
% This function computes the mean as one of the data points (B) provided. The
% mean is the datapoint which yields the smallest squared distance with the
% other points.

function [center] = retardmean(B)
%% Initialisation
% Initialising cost and center
[~,~,len]=size(B);
center=B(:,:,1);
j=2;
while sum(sum(center))==0
    center=B(:,:,j);
    j=j+1;
end
mincost=distance(center,B(:,:,2),'');
    for j=2:len
        
        mincost=mincost+(distance(center,B(:,:,j),''))^2; 
    end

%% Computation
% Here, the mean is computed
for i=2:len
    test=B(:,:,i);
    cost=0;
    for j=1:len
        if sum(sum(test))==0 || sum(sum(B(:,:,j)))==0
            continue;
        else
         cost=cost+(distance(test,B(:,:,j),''))^2;
        end
    end
    if mincost>cost
        center=test;
        mincost=cost;
    end
end