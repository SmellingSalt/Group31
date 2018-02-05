signal = EEGSignals.OzTrials(251:end,5);
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