%% ProbThresh
% This function takes 'predictions' and finds the most occurring number in
% it. It then returns the 'count' and 'prob' of this and makes 'yes' 0 if the count's
% probability lies below 'threshold'. 'yes' is 1 if the number of maximums
% is only 1 and if its probability is above the threshold.

function [count,prob,yes]=ProbThresh(predictions,threshold)
y=tabulate(predictions);
[count, index]=max(y(:,2));
checks=y(:,2);
prob=y(index,3);
checks=checks(checks==count);
if length(checks)>1
        yes=0;
elseif ((y(index,3)/100)>=threshold)&&(length(checks)==1)
        yes=1;
else
        yes=0;
end
end