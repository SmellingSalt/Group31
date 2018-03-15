% This is an EMD/EEMD program
%
%   function imfs=emd(data,noise_std,ensemble)
%
% INPUT:
%       data: Inputted data;
%       noise_std: ratio of the standard deviation oslidingemd_weighted_sed_ssa.mf the added noise and that of data;
%       ensemble: Ensemble number for the EEMD
% OUTPUT:
%       A matrix of N*(m+1) matrix, where N is the length of the input
%       data, and m=fix(log2(N))-1. Column 1 is the original data, columns 2, 3, ...
%       m are the IMFs from high to low frequency, and comlumn (m+1) is the
%       residual (over all trend).
%
% NOTE:
%       It should be noted that when noise_std is set to zero and ensemble is set to 1, the
%       program degenerates to an EMD program [imfs=emd(data,0,1)].
%
% The code is prepared by Zhaohua Wu (zhwu@cola.iges.org) and modified by
% Angela Zeiler (angela.zeiler@biologie.uni-regensburg.de).


function imfs=emd(data,noise_std,ensemble)

imfall=0;
xsize=length(data);
dd=1:xsize;
data_std=std(data(:));
data=data/data_std;

m=fix(log2(xsize))-1; % number of IMFs
m2=m+2;
imfs=zeros(xsize,m2);
data_noise=zeros(xsize,1);

imfs(1:xsize,1) = data(1:xsize);

for j=1:ensemble,
	for i=1:xsize, % add noise for Ensemble EMD
		temp=randn(1,1)*noise_std;
		data_noise(i)=data(i)+temp;
	end
	
	xend = data_noise;
    
	nmode = 1;
	while nmode <= m, % calculate m IMFs
		xstart = xend;
		iter = 1;

		while iter<=10, % 10 sifting steps
			[maxima, minima]=extrema_emd(xstart);
			upper= spline(maxima(:,1),maxima(:,2),dd);
			lower= spline(minima(:,1),minima(:,2),dd);
			mean_ul = (upper + lower)/2;
			xstart = xstart - transpose(mean_ul);
			iter = iter +1;            
		end
		xend = xend - xstart;
		
		nmode=nmode+1;
        
		imfs(1:xsize,nmode) = xstart(1:xsize);
	end
	
	imfs(1:xsize,nmode+1)=xend(1:xsize);
	
	imfall=imfall+imfs;
end
imfs=imfall;
imfs=imfs/ensemble;
imfs=imfs.*data_std;

