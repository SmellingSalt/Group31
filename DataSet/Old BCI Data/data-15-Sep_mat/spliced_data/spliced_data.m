function outFile = spliced_data(inFile)

filename='';

for i = 1:3
if inFile(25+i)=='H'
    break;
else
filename=strcat(filename,inFile(25+i));
end
end
EEGdata.TargetFrequency=str2num(filename);

EEGdata.Duration=10;

outFile = strcat(inFile, '.mat');
inFile = strcat(inFile, '.gdf');

[s, h] = sload(inFile,0,'OVERFLOWDETECTION:OFF');
EEGdata.SampleRate = h.SampleRate;

EEGdata.data = s

EEGdata.EVENT = h.EVENT;
EEGdata.EVENT.TYP = h.EVENT.TYP;
EEGdata.EVENT.POS = h.EVENT.POS;


EEGdata.OzFilt = bandfilter(s(:,1),EEGdata.SampleRate,4,1,40);

EEGdata.Label = h.Label;
EEGdata.OzTrials = zeros(2500,5);
j=h.EVENT.POS(2);
for i = 1:5
    EEGdata.OzTrials(:,i) = EEGdata.OzFilt(j:j+2499);
    j = j+5000;
end


if length(EEGdata.Label)==2
EEGdata.POzFilt = bandfilter(s(:,2),EEGdata.SampleRate,4,1,40);    
EEGdata.POzTrials = zeros(2500,5);
j=h.EVENT.POS(2);
for i = 1:5
    EEGdata.POzTrials(:,i) = EEGdata.POzFilt(j:j+2499);
    j = j+5000;
end

end
EEGSignals = EEGdata;
%% Saving the Results to the appropriate Matlab files
save(outFile, 'EEGSignals');
