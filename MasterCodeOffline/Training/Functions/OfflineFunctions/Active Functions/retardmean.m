function [center] = retardmean(B)

%% Initialisation
% Initialising cost and center
[~,~,len]=size(B);
center=B(:,:,1);
mincost=distance(center,B(:,:,2),'riemann');
    for j=2:len
        mincost=mincost+(distance(center,B(:,:,j),'riemann'))^2; 
    end

%% Computation
% Here, the mean is computed
for i=2:len
    test=B(:,:,i);
    cost=0;
    for j=1:len
         cost=cost+(distance(test,B(:,:,j),'riemann'))^2;
    end
    if mincost>cost
        center=test;
    end
end