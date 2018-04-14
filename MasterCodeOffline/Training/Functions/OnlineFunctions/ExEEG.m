%% This function arranges the EEG data of a session into a cell structure
%The Row contains all the D Epochsa and the columns contain remaining D
%Epochs 
%Note:MegaEpoch is the set of D Epochs
function[X,hand]= ExEEG(s,h,window)
% [s,h]=sload('..\..\..\..\DataSet\Old BCI Data\fyp2016data\gdf\Indra\ssvep-record-train-indra-3-[2016.03.31-23.42.46].gdf'); %Possible inputs {classes,s,h}
% w=2.3*h.SampleRate;          %Window Length in 'number of samples'
% dn=0.2*h.SampleRate;         %Window Spacing in 'number of samples'
% D=10;                        %Number of Epochs
% window=[w, dn, D];
%Above line is to debug, ignore it
window(1,1:2)=ceil(window(1,1:2)*h.SampleRate);
w=window(1,1);
dn=window(1,2);
D=window(1,3);
BigWindow=w+(D-1)*dn;                                 %This is the number of samples D Epochs would require, or the window size of a mega epoch
%% Padding Zeros
% There will be DD=1+(N-BigWindow)/(D*dn) number of mega overlapping Epochs in the
% entire GDF File. This section pads zeros to the end of the gdf file so
% that there will be a whole number of rows in the X File, not fractional
% (Which is not possible to construct)
N=length(s);
DD=1+(N-BigWindow)/(D*dn);                            %D*dn is the spacing between megaepochs
excess=BigWindow+(ceil(DD)-1)*(dn*D);                 %Now that we have the number of megaepochs, we calculate the number of samples required to get the nearest whole number of megaepochs
excess=excess-N;                                      %Excess is now just the difference between the larger calculated length from the above line and the original length of the signal, 'N'  
s=[s; zeros(excess,h.NS)];                            %Concatenating zeroes to the end, in all the NS number of channels
N=length(s);                                          %Updating the length of 's'
DD=1+(N-BigWindow)/(D*dn);                            %DD is the number of large windows the entire GDF File is divided into, again updated and will always be a whole number.
                                                      %Handle, returning the sample start and ends of all megaEpochs
%% Filling the cell
% D epochs in each Row, and DD number of Rows
  sampl1=1;                                           %Initialising start sample as sample number 1.
  sampl2=w;                                           %Initialising the end of the first epoch as the length of the entire epoch
   for i=1:DD
       
   for j=1:D   
       if sampl2>N
           break;
        end
       X{i,j}=s(sampl1:sampl2,:);
       hand{i,j}=[sampl1,sampl2]./h.SampleRate;
       sampl1=sampl1+dn;
       sampl2=sampl2+dn;
   end
   
  end
%X=Bank(X,1);