%% EpochClassifier
% This function classifies a set of epochs belonging to noise or a class
% using algorithm 3's curve movement
function [class]=EpochClassifier(Cr,a,ClassMean,window,predic,yes)
[~,sums]=Curve(ClassMean,Cr,window,a);
sums=cell2mat(sums);
switch predic
    case -1
        class="noise";
    case -2
        class="Magic Noise";
    case 1
        if sums(1,1)<0
            class="1";
        else
            class="hold";
        end
    case 2
        if sums(2,1)<0
            class="2";
        else
            class="hold";
        end
    case 3
        if sums(3,1)<0
            class="3";
        else
            class="hold";
        end
    case 4
        if sums(4,1)<0
            class="4";
        else
            class="hold";
        end
    otherwise
        class="hold";
end
if yes==0
    class="No Idea";
end
end