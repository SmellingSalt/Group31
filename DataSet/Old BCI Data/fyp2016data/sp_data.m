function outFile = sp_data(inFile)

outFile = strcat(inFile, '.mat');
inFile = strcat(inFile, '.gdf');

[s, h] = sload(inFile,0,'OVERFLOWDETECTION:OFF');
EEGdata.SampleRate = h.SampleRate;

EEGdata.data = s;

EEGdata.EVENT = h.EVENT;
EEGdata.EVENT.TYP = h.EVENT.TYP;
EEGdata.EVENT.POS = h.EVENT.POS;

EEGdata.FiltData = bandfilter(s,EEGdata.SampleRate,4,1,40);

EEGdata.Label = h.Label;
% 6s x250 - 6channels - 8 trials - 4 classes
EEGdata.Trials = zeros(1500,length(h.Label),8,4);
%class 0 - null
%class 1 - 10Hz
%class 2 - 15Hz
%class 3 - 12Hz
classStimCodes = [33024 33025 33026 33027];
for class = 1:4
    pos = find(ismember(h.EVENT.TYP,classStimCodes(class)));
   for trial = 1:8
       EEGdata.Trials(:,:,trial,class) = EEGdata.FiltData(h.EVENT.POS(pos(trial)+1):h.EVENT.POS(pos(trial))+1749,:);
   end
end
EEGdata.Trials = permute(EEGdata.Trials,[2 1 3 4]);

EEGSignals = EEGdata;
%% Saving the Results to the appropriate Matlab files
save(outFile, 'EEGSignals');
