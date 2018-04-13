function y = doFilter(x)
%DOFILTER Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the DSP System Toolbox 9.4.
% Generated on: 13-Apr-2018 09:42:21

%#codegen

% To generate C/C++ code from this function use the codegen command.
% Type 'help codegen' for more information.

persistent Hd;

if isempty(Hd)
    
    % The following code was used to design the filter coefficients:
    %
    % Fstop1 = 41.6;  % First Stopband Frequency
    % Fpass1 = 41.8;  % First Passband Frequency
    % Fpass2 = 42.2;  % Second Passband Frequency
    % Fstop2 = 42.4;  % Second Stopband Frequency
    % Astop1 = 80;    % First Stopband Attenuation (dB)
    % Apass  = 1;     % Passband Ripple (dB)
    % Astop2 = 80;    % Second Stopband Attenuation (dB)
    % Fs     = 256;   % Sampling Frequency
    %
    % h = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', Fstop1, Fpass1, ...
    %                      Fpass2, Fstop2, Astop1, Apass, Astop2, Fs);
    %
    % Hd = design(h, 'cheby1', ...
    %     'MatchExactly', 'passband', ...
    %     'SystemObject', true);
    
    Hd = dsp.BiquadFilter( ...
        'Structure', 'Direct form II', ...
        'SOSMatrix', [1 0 -1 1 -1.01965698228669 0.999727619956949; 1 0 -1 1 ...
        -1.03645025991423 0.999729213422632; 1 0 -1 1 -1.02041422212435 ...
        0.999216185910687; 1 0 -1 1 -1.03517959483749 0.999220218686142; 1 0 -1 ...
        1 -1.02211280824374 0.998800163517864; 1 0 -1 1 -1.03307063936993 ...
        0.998804747578752; 1 0 -1 1 -1.02454475308604 0.99852968724917; 1 0 -1 1 ...
        -1.03037480035547 0.998532678507152; 1 0 -1 1 -1.02741431703482 ...
        0.99843698662077], ...
        'ScaleValues', [0.0048963390499039; 0.0048963390499039; ...
        0.00432074462502439; 0.00432074462502439; 0.00324882713089302; ...
        0.00324882713089302; 0.00185077553835054; 0.00185077553835054; ...
        0.000781506689614954; 1]);
end

s = double(x);
y = step(Hd,s);

