function [hil, hilAmp, fou]=hilberFourierN(y,Ts)

N = length(y);
c = linspace(0,(N-2)*Ts,N-1);
Fs=1/Ts;
n = N/2; % 2nd half are complex conjugates
f = 0:30;% (0:N/2)/(2*n/Fs);
if size(y,3) == 1
  for i= 1:size(y,1);
   imf{i}=y(i,:);
   Y{i} = fft(y(i,:));
   fou(i,:)= abs(Y{i})/n;
   hilAmp(i,:) = abs(hilbert(y(i,:)));
  end

  for k = 1:length(imf)
    b(k) = sum(imf{k}.*imf{k});
    th   = unwrap(angle(hilbert(imf{k})));
    d{k} = (diff(th)/Ts/(2*pi)); % instantaneousâ€? frequency is calculated by dividing each frequency difference by the digitizing step in s to give radians/s.
                                % by the digitizing step in s to give radians/s. Division by 2*pi gives frequency in Hz
  end 
 


  for i = 1:length(d)
   hil(i,:) = d{i};
  end 
   hil(hil<0)=0;
    hil(:,500)=0;

else

c=1;    
for i= 1:size(y,1);
    for j=1:size(y,3)
    imf{c}=squeeze(y(i,:,j));
    Y{c} = fft(y(i,:,j));
    fou(i,:,j)= abs(Y{c})/n;
    hilAmp(i,:,j) = abs(hilbert(y(i,:,j)));
    c=c+1;
    end
end

for k = 1:length(imf)
    b(k) = sum(imf{k}.*imf{k});
   th   = unwrap(angle(hilbert(imf{k})));
   d{k} = (diff(th)/Ts/(2*pi)); 
                               
end 
 

c=1;
  for i = 1:length(d)/size(y,3)
      for j=1:size(y,3)
       hil(i,:,j) = d{c};
       c=c+1;
      end 
  end
  hil(hil<0)=0;
   hil(:,500,:)=0;
end
end
    
    


