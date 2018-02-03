function refSignal=ck_signal(f)
%% constract first and second harmonic wave
p=1250;
fs=250;
TP=1/fs:1/fs:p/fs;
for j=1:length(f)
    Sinh1=sin(2*pi*f(j)*TP);
    Cosh1=cos(2*pi*f(j)*TP);
    Sinh2=sin(2*pi*2*f(j)*TP);
    Cosh2=cos(2*pi*2*f(j)*TP);
    refSignal(:,:,j)=[Sinh1;Cosh1;Sinh2; Cosh2];
end