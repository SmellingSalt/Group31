%% EpochClassifier
% This function classifies a set of epochs belonging to noise or a class
% using algorithm 3's curve movement
function [class]=EpochClassifier(Cr,a,ClassMean,window,predic,yes,classes)
[~,sums]=Curve(ClassMean,Cr,window,a);
sums=cell2mat(sums);
switch predic
    case -1
        yes=0;
    case -2
        class=-2;
    case 1
        if sums(1,1)<0
            class=classes(1,1);
        else
            class=-10;
        end
    case 2
        if sums(2,1)<0
            class=classes(2,1);
        else
            class=-10;
        end
    case 3
        if sums(3,1)<0
            class=classes(3,1);
        else
            class=-10;
        end
    case 4
        if sums(4,1)<0
            class=classes(4,1);
        else
            class=-10;
        end
    otherwise
        class=-10;
end
if yes==0
    class=-1;
%     if isempty(classes(classes==33024))
%     class=-1;
%     else
%         class=classes(1,1);
%     end
end
end