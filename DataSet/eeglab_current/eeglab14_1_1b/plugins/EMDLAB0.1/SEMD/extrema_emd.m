% This is a utility program for emd.
%
%   function [maxima, minima]= extrema(data)
%
% INPUT:
%       data: Inputted data, a time series to be sifted;
% OUTPUT:
%       maxima: The locations (col 1) of the maxima and its corresponding values (col 2)
%       minima: The locations (col 1) of the minima and its corresponding values (col 2)
%
% The code is prepared by Zhaohua Wu (zhwu@cola.iges.org) and modified by
% Angela Zeiler (angela.zeiler@biologie.uni-regensburg.de).


function [maxima, minima]= extrema_emd(data)

xsize=length(data);

maxima = zeros(ceil(xsize/2),2);
minima = maxima;

% maxima
maxima(1,1) = 1;
maxima(1,2) = data(1); % first data point -> first max

data_b = sign(data(2:xsize)-data(1:xsize-1));
data_f = sign(data(1:xsize-1)-data(2:xsize));
data_s = data_b(1:end-1)+data_f(2:end);
tmp_max = find(data_s == 2)';
maxima(2:length(tmp_max)+1,:) = [(tmp_max+1)' , data(tmp_max+1)];
k=length(tmp_max)+2;

maxima(k,1)=xsize;
maxima(k,2)=data(xsize); % last data poing -> last max
maxima=maxima(1:k,:);

% boundary conditions
if k>=4
	slope1=(maxima(2,2)-maxima(3,2))/(maxima(2,1)-maxima(3,1));
	tmp1=slope1*(maxima(1,1)-maxima(2,1))+maxima(2,2);
	if tmp1>maxima(1,2)
	    maxima(1,2)=tmp1;
	end

	slope2=(maxima(k-1,2)-maxima(k-2,2))/(maxima(k-1,1)-maxima(k-2,1));
	tmp2=slope2*(maxima(k,1)-maxima(k-1,1))+maxima(k-1,2);
	if tmp2>maxima(k,2)
		maxima(k,2)=tmp2;
	end
end

% minima
minima(1,1) = 1;
minima(1,2) = data(1);  % first data point -> first min

tmp_min = find(data_s == -2)';
minima(2:length(tmp_min)+1,:) = [(tmp_min+1)' , data(tmp_min+1)];
k=length(tmp_min)+2;

minima(k,1)=xsize;
minima(k,2)=data(xsize); % last data poing -> last min
minima=minima(1:k,:);

% boundary conditions
if k>=4
	slope1=(minima(2,2)-minima(3,2))/(minima(2,1)-minima(3,1));
	tmp1=slope1*(minima(1,1)-minima(2,1))+minima(2,2);
	if tmp1<minima(1,2)
		minima(1,2)=tmp1;
	end

	slope2=(minima(k-1,2)-minima(k-2,2))/(minima(k-1,1)-minima(k-2,1));
	tmp2=slope2*(minima(k,1)-minima(k-1,1))+minima(k-1,2);
	if tmp2<minima(k,2)
		minima(k,2)=tmp2;
	end
end


