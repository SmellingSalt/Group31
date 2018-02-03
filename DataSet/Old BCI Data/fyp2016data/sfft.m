%signal = EEGSignals.OzTrials(251:end,5);

% 5s data - 6channels - 8 trials - 4 classes
%class 0 - null
%class 1 - 10Hz
%class 2 - 15Hz
%class 3 - 12Hz

signal = EEGSignals.Trials(:,3,8,1);
fs = 250;
L = length(signal(1:2*fs));
y = signal;

NFFT = floor(2^nextpow2(L));
Y = fft(y,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);

y_y = 2*abs(Y(1:NFFT/2+1));
x = f;
figure;
plot(x,y_y);
xlim([0 40]);