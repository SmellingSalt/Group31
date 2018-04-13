function [class]=code(varargin)
class=zeros(1,nargin);
for i=1:nargin
    switch varargin{i}
        case 0
            class(1,i)=33024;
        case 13
            class(1,i)=33025;
        case 17
            class(1,i)=33027;
        case 21
            class(1,i)=33026;
        otherwise
            continue;
    end
    
end
class=sort(class);
end