[s,h]=sload('record-[2012.07.06-19.02.16].gdf');
% s is the data
% h has the markers in 'EVENT'
% Stim Codes tell you what to do 
 n=13;
 z1=h.EVENT.POS(n-1,1);
 z2=h.EVENT.POS(n,1);
 
 t1=h.EVENT.TYP(n+3,1);
 
% 
% z is the Stim code number
% t is the sample value
% 
% If z1 and z2 are two stim codes, then the values of s between the sample
% number t1 and t2 are the EEG signal within the event z1 and z2.
% 
 s1=s(z1,1:8);
 s2=s(z2,:);