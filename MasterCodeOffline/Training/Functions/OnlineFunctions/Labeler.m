%%Labeler
% This function takes the timestamps and actual time handle and labels the
% entire EEG session as belonging to a particular class.
function[target, K]=Labeler(timestamp,hand,classes,Krn)
time=timestamp{:,:};
[len,bred]=size(time);
hand=hand(:,1);

target=zeros(length(hand),1);
for i=1:len
    for j=1:bred
        interval=time{i,j};
        low=interval(1,1);
        high=interval(1,2);
        
        switch classes(i,1)
            case 33024
                for k=1:length(hand)
                    if hand(k,1)<=high&&hand(k,1)>=low
                        target(k-1,1)=33024;
                        
                    else
                        continue;
                    end
                end
                
            case 33025
                for k=1:length(hand)
                    if hand(k,1)<=high&&hand(k,1)>=low
                        target(k-1,1)=33025;
                        
                    else
                        continue;
                    end
                end
                
            case 33026
                for k=1:length(hand)
                    if hand(k,1)<=high&&hand(k,1)>=low
                        target(k-1,1)=33026;
                        
                    else
                        continue;
                    end
                end
                
            case 33027
                for k=1:length(hand)
                    if hand(k,1)<=high&&hand(k,1)>=low
                        target(k-1,1)=33027;
                        
                    else
                        continue;
                    end
                end
            otherwise
                continue;
                
        end
        
    end
end
if isempty(classes(classes==33024))
    target(target==0)=-1;
else
    target(target==0)=-1;
end

K=Krn(target~=-1);
target=target(target~=-1);
end
