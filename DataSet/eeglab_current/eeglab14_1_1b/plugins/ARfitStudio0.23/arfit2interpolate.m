% arfit2interpolate()-- takes epoched EEGLAB data structure. Interpolates
%                       single-trial data specified with interpStart and
%                       interpEnd in epoch latency (in datapoints, not seconds). 
%                       Learns ARfit model between 1 to interpStart of epoch latency.
%                       It detrends the data for internal process but put
%                       it back before output. AFfit was written by 
%
% Usage: output = arfit2interpolate(EEG.data(:,:,:), [interpStart interpEnd], overlapForSmoothBlending);
%
% [interpStart interpEnd]:  must be in frame, not millisecond
% overlapForSmoothBlending: the LAST n datapoints from interpEnd to be smoothly blended with the original signal 

% History:
% 08/15/2017 Makoto. 'noise' scaling bug (*R) fixed.
% 05/02/2017 Makoto. Error reported by Jacqueline Palmer.
% 12/13/2015 ver 2.2 by Makoto. Substracts and adds back trends instead of mean.
% 01/29/2015 ver 2.1 by Makoto. SBC model order statistics display.
% 06/13/2014 ver 2.0 by Makoto. Blending implemented.
% 02/28/2014 ver 1.0 by Makoto. Created.

% Copyright (C) 2011, 2014 Makoto Miyakoshi and Tim Mullen, JSPS/SCCN,INC,UCSD.
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1.07  USA

function processedData = arfit2interpolate(epochedData, startEndIdx, blendingLength)

% subtract trend
extensionLength = diff(startEndIdx);
baselineData = epochedData(:,1:startEndIdx(1)-1,:);
baselinePerm = permute(baselineData, [2,1,3]);
detrendData = detrend(baselinePerm(:,:));
detrendData = reshape(detrendData, size(baselinePerm));
detrendData = permute(detrendData, [2,1,3]);
trendData = baselineData-detrendData;
epochedData_detrend = epochedData;
epochedData_detrend(:,1:startEndIdx(1)-1,:) = detrendData;
clear baselineData baselinePerm detrendData

% linear blending
if any(blendingLength)
    blendingCurve = linspace(1,0,blendingLength);
end

% main loop
processedData = zeros(size(epochedData_detrend));
for chIdx = 1:size(epochedData_detrend,1)
    modelOrderList = zeros(size(epochedData_detrend,3),1);
    for epochIdx = 1:size(epochedData_detrend,3)
        
        % extract single epoch
        tmpEpoch      = epochedData_detrend(chIdx,:,epochIdx);
        originalEpoch = tmpEpoch;
        
        % determine model oder bounds
        minModelOrder = 1;
        maxModelOrder = round((startEndIdx(2)-startEndIdx(1)));
        
        % run arfit
        [w,A,C] = arfit(tmpEpoch(1:startEndIdx(1)-1)', minModelOrder, maxModelOrder);
        modelOrderList(epochIdx,1) = length(A);
        [R,err]= chol(C);
        if err ~= 0
            error('Covariance matrix not positive definite.')
        end
        noise = randn(1,length(tmpEpoch))*R;
        
        % PREDICT THE FUTURE!! (by Tim Mullen)
        for latencyIdx = startEndIdx(1):startEndIdx(2)
            tmpEpoch(latencyIdx) = A*tmpEpoch(latencyIdx-1:-1:latencyIdx-length(A))'+noise(latencyIdx);
        end
        
        % Add trend that is extended to cover the interpolated timepoints
        tmpTrend = trendData(chIdx,:,epochIdx);
        deltaTrend = mean(diff(tmpTrend));
        extendedTrend = linspace(tmpTrend(1), (deltaTrend*(length(tmpEpoch)-1)+tmpTrend(1)), length(tmpEpoch));
        tmpEpoch = tmpEpoch+extendedTrend;
            %
            % 05/02/2017 Makoto. Define this extendedTrend to have the exact same length as tmpEpoch.
            %
            % extendedTrend = tmpTrend(1):deltaTrend:(deltaTrend*(length(tmpEpoch)-1)+tmpTrend(1));
            % if length(extendedTrend)==length(tmpEpoch)
            %     tmpEpoch = tmpEpoch+extendedTrend;
            % elseif median(diff(tmpTrend))==0 % if median of the trend is zero
            %     tmpEpoch = tmpEpoch+zeros(1,length(tmpEpoch));
            % else
            %     error('Fail to extend baseline period.')
            % end

        % Blending
        if any(blendingLength)
            interpolatedEpochCropped = tmpEpoch(startEndIdx(1):startEndIdx(2));
            originalEpochCropped     = originalEpoch(startEndIdx(1):startEndIdx(2));
            % figure; plot(interpolatedEpochCropped); hold on; plot(originalEpochCropped ,'r')
            fadeOutData = interpolatedEpochCropped(end-length(blendingCurve)+1:end).*blendingCurve;
            fadeInData  = originalEpochCropped(end-length(blendingCurve)+1:end).*(1-blendingCurve);
            blendedData = fadeOutData + fadeInData;
            % figure; plot(fadeOutData); hold on; plot(fadeInData, 'r'); plot(blendedData, 'g')
            tmpEpoch(startEndIdx(2)-length(blendingCurve)+1:startEndIdx(2)) = blendedData;
        end
        
        % put back the processed data
        processedData(chIdx,:,epochIdx) = tmpEpoch;
    end
    disp(sprintf('%2.0d/%2.0dch done. Model order %2.1f (SD %2.1f Range %d-%d) by Schwart''s Bayesian Criterion.', chIdx, size(epochedData_detrend,1), mean(modelOrderList), std(modelOrderList), min(modelOrderList), max(modelOrderList)))
end