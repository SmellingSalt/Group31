%% Code
% This function takes a variable number of numbers and returns their gdf
% class value or the reverse of it
function [class]=code(varargin)
class=zeros(1,nargin);
flag=1;
for i=1:nargin
    switch varargin{i}
        case 0
            class(1,i)=33024;
            flag=0;
        case 13
            class(1,i)=33025;
            flag=0;
        case 17
            class(1,i)=33027;
            flag=0;
        case 21
            class(1,i)=33026;
            flag=0;
        case 33024
            class(1,i)=0;
        case 33025
            class(1,i)=13;
        case 33026
            class(1,i)=21;
        case 33027
            class(1,i)=17;
        case -1
            class(1,i)=-1;
        case -2
            class(1,i)=-2;
        otherwise
            error('Check the type of classes again');
    end
    
end

if flag==0
class=sort(class);
end

end