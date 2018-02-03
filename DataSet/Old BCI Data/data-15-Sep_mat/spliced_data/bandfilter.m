function sig = bandfilter(s, fs, order, lowBand, highBand)
signal = s;        

lowFreq = lowBand * (2/fs);
highFreq = highBand * (2/fs);

[B A] = butter(order, [lowFreq highFreq]);

sig = filter(B, A, signal);

end