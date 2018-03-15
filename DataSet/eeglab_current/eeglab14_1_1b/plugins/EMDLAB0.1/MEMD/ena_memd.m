function [imfs, imfsRealizations] = ena_memd(temdata, varargin)
%ENA_MEMD Ensemble Noise Assisted Multivariate Empirical Mode Decomposition
%   TCMAT is the matrix containing time series of all EEG-channels in the
%   form 'samples x channels'. REALIZATIONS shall be the user-defined number
%   of noise/IMF-realizations created for averaging. NUMNOISECHANNELS is
%   the user-defined number of noise channels added to the signal channels.
%   Results are almost not sensitive to the number of noise channels
%   according to literature - four channels are chosen as default.
%   NOISEAMP is the user-defined noise amplitude (suggestions in the
%   literature range from 2-10%, hence 6% is chosen as default value).
%   Returns IMFS with 'dimension channels x numberOfImfs x samples' and
%   IMFSREALIZATIONS as a cell-array of dimension 'realizations' containing
%   all realizations created by ENA_MEMD.
%
%   [1] Rehman, N., Park, C., Huang, N. E., Mandic, D. P., Apr. 2013. EMD via
%       MEMD: multivariate noise-aided computation of standard EMD. Advances
%       in Adaptive Data Analysis 05 (02), 1350007.

%% Handle input, set defaults
if length(size(temdata.data))>2
for j=1:size(temdata.data,3);
tcMat(:,:,j)=temdata.data';
end
else
tcMat=temdata.data';
end  
if nargin < 1
    error('Not enough inputs');
end
numvarargs = length(varargin);
if numvarargs > 4
    error('Allows at most 4 inputs')
end
args = {tcMat 30 4 .06};
args(2 : 1 + numvarargs) = varargin;
[tcMat, realizations, numNoiseChannels, noiseAmp] = args{:};

%% ENA-MEMD
imfsRealizations = cell(realizations, 1); % Cell, because MEMD algorithm can result in slightly differing number of IMFs per noise initialization

% Calculate average power amplitude for noise channels
powerSignal = zeros(size(tcMat, 2), 1);
for nChannels = 1 : size(tcMat, 2)
    powerSignal(nChannels) = bandpower(tcMat(:, nChannels));
end
powerSignal = mean(powerSignal);

% Create ensemble
fprintf('Realization ');
for nReal = 1 : realizations
    fprintf([num2str(nReal), '.']);
    tcNoiseMat = [tcMat, wgn(size(tcMat, 1), numNoiseChannels, noiseAmp * powerSignal, 'linear')]; % using NA-MEMD as suggested in 'Filter Bank Property of Multivariate Empirical Mode Decomposition' and 'EMD via MEMD: Multivariate ... '
    imfsRealizations{nReal} = memd(tcNoiseMat, size(tcNoiseMat, 2) * 2); % At least double the number of direction vectors than input channels
    imfsRealizations{nReal} = imfsRealizations{nReal}(1 : size(tcMat, 2), :, :); % Discarding noise channels
end
fprintf('\n');

% Get minimum number of extracted IMFs common to all realizations
sizesImfsRealizations = cell2mat(cellfun(@(x) size(x, 2), imfsRealizations, 'UniformOutput', false));

% Only average over IMF-realizations without residuals
tempImfs = cellfun(@(x) x(:, 1 : min(sizesImfsRealizations) - 1, :), imfsRealizations, 'UniformOutput', false);
imfs = mean(cat(4, tempImfs{:}), 4);
