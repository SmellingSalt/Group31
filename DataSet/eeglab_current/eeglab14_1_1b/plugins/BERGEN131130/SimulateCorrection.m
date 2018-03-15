% SimulateCorrection.m is used as part of the Bergen EEG&fMRI Toolbox 
% plugin for EEGLAB.
% 
% Copyright (C) 2009 The Bergen fMRI Group
% 
% Bergen fMRI Group, Department of Biological and Medical Psychology,
% University of Bergen, Norway
% 
% Written by Emanuel Neto, 2009
% netoemanuel@gmail.com
% 
% Last Modified on 18-Jun-2009 08:07:11
% 
function [ simulation ] = SimulateCorrection( EEG, weighting_matrix, Peak_references, onset_value, offset_value)
%UNTITLED1 Summary of this function goes here
%  Detailed explanation goes here
lim1 = length(Peak_references);
lim2 = length(weighting_matrix);
residual = lim2-lim1+1;
ch = 1; % Test for channel 1;
flag = 0;
firstime = 1;
initialtime = 0;
simulation1 = 0;
simulation2 = 0;
count=0;
tic

try
    for i= residual:lim2
        if i == residual
            starter = fix(Peak_references(i)+onset_value);
            ender = fix(Peak_references(i)+offset_value);
            A = rand(lim2,ender-starter+1);
            B = rand(ch,ender-starter+1);
        end
        try
            if i == residual
            end
        catch
        end
        if i > 10
            break
        end
    end
end

initialtime = toc;
tic;

try
    % simulation 1 - Build Matrix A
    for i = residual  : lim2
        try
            starter = fix(Peak_references(i)+onset_value);
            ender = fix(Peak_references(i)+offset_value);
            A(i,:) = (EEG.data(ch,starter:ender))';
        catch
            fprintf(['Warning: Artifact ', num2str(i), ' length mismatch. It might not be corrected successfully!', 10]);
        end
        if i > 10
            break
        end
    end
end

simulation1 = toc;
tic;

    % simulation 2 - Apply Correction
try
    for i= residual : lim2
        %Normalization of the Matrix values
        starter = fix(Peak_references(i)+onset_value);
        ender = fix(Peak_references(i)+offset_value);
        w=weighting_matrix(i,:)/sum(weighting_matrix(i,:)); 
        Correctionmatrix (i,:) = w*A;
        B(ch,starter:ender) = Correctionmatrix (i,:);
        count = count+1;
        if i > 10
            break
        end
    end
catch

end

simulation2 = toc;
% simulation2 = toc;
simulation = (simulation1 + simulation2 - initialtime*0.75) * lim2/11;



