% ciac() -  evaluates temporal and spatial properties of ICs included in a STUDY and selects ICs representing CI artifacts.
%           It displays the scalp maps of the  ICs selected and the original and corrected AEPs for each dataset contained in the STUDY.
%           All datasets MUST be epoched to the same auditory stimuli.
%           IMPORTANT: It requires that the user had run DIPFIT for each dataset contained in the STUDY. For details about
%           how to use DIPFIT, please check http://sccn.ucsd.edu/wiki/A08:_DIPFIT.
%
%
%
% Usage:
%          >> [CIAC,STUDY,ALLEEG] = ciac(STUDY, ALLEEG, dur,twind,th_rv,th_der,th_corr,Cz_ind, plot);
%
% Inputs:
%  STUDY - input STUDY structure
%  ALLEEG - input ALLEEG structure
%  dur - duration of the auditory stimuli [ms]
%  twind - time window of interest [ms] containing the AEP response. It should
%  be an interval, e.g. [80 140]
%  th_rv - threshold for residual variance. Recommended values 0.15 < th_rv  < 0.25
%  th_der - threshold for derivative. Recommended values 1.5 < th_der < 3.5
%  th_corr - threshold for correlation. Recommended values 0.85 < th_corr < 0.95
%  Cz_ind - index of the channel of interest. Recommended Cz index.
%  plot - if plot=1, output plots for each dataset are displayed, if plot=0, plots are saved automatically
%  in the same folder where the STUDY set is saved. Default: plot=1.
%
% Outputs:
% CIAC - structure that contains indices of ICs selected as
% representing the CI artifact for each dataset analysed.
% STUDY - STUDY structure updated
% ALLEEG - ALLEEG structure
%
% See also:  pop_ciac()
%
% Author: F.C. Viola, Neuropsychology Lab, Department of Psychology, University of Oldenburg, Germany 21/10/2011 (filipa.viola@uni-oldenburg.de)

%123456789012345678901234567890123456789012345678901234567890123456789012

% Copyright (C) F.C. Viola, Neuropsychology Lab, Dept. Psychology, Uni
% Oldenburg, Germany
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


function [CIAC,STUDY,ALLEEG]=ciac(STUDY,ALLEEG,dur,twind,th_rv,th_der,th_corr,Cz,pl)

tic
CIAC=[];


% %%%%% checking if data is epoched %%%%%%%%%%%%%
if nargin < 8
    fprintf('ERROR: Not enough input parameters. Please, check: help ciac. \n');
    return
end

%%% checking ig first dataset in STUDY is epoched
if length(size(ALLEEG(1).data))~=3
    
    fprintf('Error: At least one dataset is in continuous format. The datasets included in the STUDY must be epoched to auditory stimuli. \n');
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% checking if duration of the auditory stimuli is valid %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if dur<=0
    fprintf('Error: The duration of the auditory stimuli needs to be a positive value. \n' );
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end

if dur>ALLEEG(1).xmax*1000
    fprintf('Warning: The duration of the auditory stimuli is larger than the duration of the epoches. \n' );
    fprintf('The last 50 ms from the epoch will be used. \n');
    t1=0;
    t2=50;
    t3=ALLEEG(1).xmax*1000-t2;
    t4=ALLEEG(1).xmax*1000;
else
    
    %% time window onset/offset artifact - by default 20 ms. It can be changed by the user.
    t1=0;
    t2=50;
    t3=dur;
    t4=dur+t2;
end

%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
%%time window AEP
%%%%%%%%%%%%%%%%%
tin=twind(1);
tfin=twind(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% checking if time window of interest is valid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if tin<0 || tfin<0
    fprintf('Error: The limits for the AEP time window of interest need to be positive values. \n' );
    fprintf('It is assumed that the onset of the auditory stimuli occured at t=0ms. \n' );
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end

if tin>=tfin
    fprintf('Error: The upper limit for the AEP time window of interest needs to be bigger than the lower limit. \n' );
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end

if tfin>ALLEEG(1).xmax*1000
    fprintf('Error: The upper limit for the AEP time window of interest needs to be smaller than the duration of the epoch. \n' );
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end

%%%%%%%%%%%
%%%%%%%%%%%
%thresholds
%%%%%%%%%%%
Nder=th_der;

Ncorr=th_corr;

th_rv1=th_rv;

th_rv2=0.88; %% upper limit for RV - may be changed by the user

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% checking if thresholds are valid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if th_der<=1
    fprintf('Error: The threshold for the derivative criterion needs to be a value larger than 1. \n' );
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end

if th_corr>1 || th_corr<=0
    fprintf('Error: The threshold for the correlation criterion needs to be a value between ]0 1]. \n' );
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end

if th_rv1>0.25 || th_rv1<=0
    fprintf('Error: The threshold for the residual variance criterion nshoudl be a value between ]0 0.25]. \n' );
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end

l=length(ALLEEG);

fprintf('\n')
fprintf('%11.4g datasets are going to be evaluated. Single subject outputs will be displayed. \n', l)
fprintf('After each output plot is displayed, please press any key to continue.\n')
fprintf('\n')

%finding positions

%%% onset of artifact
pos1=find(ALLEEG(1).times==t1);
pos2=find(ALLEEG(1).times==t2);

%%% offset of artifact
pos3=find(ALLEEG(1).times==t3);
pos4=find(ALLEEG(1).times==t4);

%%% N1-P2 time window AEP
pos_in=find(ALLEEG(1).times==tin);
pos_fin=find(ALLEEG(1).times==tfin);


if Cz<1
    fprintf('Error: The index for Cz channel needs to be a value larger or equal to 1. \n' );
    fprintf('see >> help ciac or check the tutorial. \n');
    return
end


CIAC.dur_audio=dur;
CIAC.aep_tw=[twind(1) twind(2)];
CIAC.threshold.rv=th_rv1;
CIAC.threshold.deriv=th_der;
CIAC.threshold.corr=th_corr;
CIAC.cz=Cz;
CIAC.plot=pl;

for s=1:l
    
    if length(size(ALLEEG(s).data))~=3
        fprintf('Error: Dataset %s is continuous. The datasets included in the STUDY must be epoched to auditory stimuli. \n',ALLEEG(s).filename,n);
        fprintf('see >> help ciac or check the tutorial. \n');
        return
    end
    
    
    if Cz>ALLEEG(s).nbchan
        fprintf('Error: The index for Cz channel: %11.4g is not valid. The dataset has %11.4g channels. \n', Cz,ALLEEG(s).nbchan);
        fprintf('see >> help ciac or check the tutorial. \n');
        return
    end
    
    chan(s)=ALLEEG(s).nbchan;
    
    %%%% excluding ICs based in residual variance
    
    vari=[ALLEEG(s).dipfit.model.rv];
    
    
    excl1=[];
    excl2=[];
    excl=[];
    
    excl1=find(vari<th_rv1);
    
    excl2=find(vari>th_rv2);
    
    excl=sort(unique([excl1 excl2]));
    
    EEG=ALLEEG(s);
    
    EEG = pop_jointprob(EEG,1,[1:EEG.nbchan] ,5,5,0,0);
    EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
    
    EEG.badepochs=find(EEG.reject.rejglobal);
    EEG.numb_badepochs=length(find(EEG.reject.rejglobal));
    
    EEG = pop_rejepoch( EEG, find(EEG.reject.rejglobal), 0);
    
    
    erp_ics=mean(EEG.icaact,3);
    
    n=size(erp_ics,1);
    
    if isempty(n)
        
        fprintf('Error: EEG.icaact is not available, please check your "Memory and other options". \n');
        fprintf('see >> help ciac or check the tutorial. \n');
        return
        
    end
    len=[];
    
    len=1:n;
    
    len(excl)=[];
    
    i=1;
    
    
    for k=1:n
        
        if isempty(find(k==excl))
            
            %%%%parameters for derivative of IC ERP AUDIO
            deriv=derivative(erp_ics(k,:));
            
            bas_deriv(i)=sqrt(mean(deriv(1:pos1).^2)); %%% rms baseline
            mean_deriv(i)=mean((deriv(pos2:pos3)));
            std_deriv(i)=std((deriv(pos2:pos3)));
            
            
            rms_deriv(i)=sqrt(mean(deriv(pos_in:pos_fin).^2)); %%% rms for N1_P2 time window
            
            rms_on_deriv(i)=sqrt(mean(deriv(pos1:pos2).^2));
            
            rms_off_deriv(i)=sqrt(mean(deriv(pos3:pos4).^2));
            
            
            th2_on_deriv{s}(i)=rms_on_deriv(i)/rms_deriv(i);
            th2_off_deriv{s}(i)=rms_off_deriv(i)/rms_deriv(i);
            i=i+1;
        end
    end
    
    pos_template1=find(th2_on_deriv{s}==max(th2_on_deriv{s}));
    pos_template2=find(th2_off_deriv{s}==max(th2_off_deriv{s}));
    
    
    max_val=[max(th2_on_deriv{s}) max(th2_off_deriv{s})];
    
    pos_max=[len(pos_template1) len(pos_template2)];
    
    badcomps_corr1=[];
    pos_exc_corr1=[];
    
    badcomps1=[];
    pos_exc1=[];
    
    
    
    if  max_val(1)>max_val(2)
        template_cl1=ALLEEG(s).icawinv(:,pos_max(1));
        id=1;
    else
        template_cl1=ALLEEG(s).icawinv(:,pos_max(2));
        id=2;
        
    end
    
    k=1;
    kk=1;
    
    j=1;
    jj=1;
    
    th_corr1=[];
    th_der1=[];
    
    
    for i=1:length(th2_on_deriv{s})
        
        th_corr1(i)=abs(corr(template_cl1,ALLEEG(s).icawinv(:,len(i))));
        
        th_der1(i)=max([th2_on_deriv{s}(i) th2_off_deriv{s}(i)]);
        
        
        if  th_der1(i)>Nder
            badcomp1(k)=len(i);
            pos_exc1(k)=len(i);
            k=k+1;
        end
        
        
        if   th_corr1(i)>Ncorr
            badcomp_corr1(j)=len(i);
            pos_exc_corr1(j)=len(i);
            j=j+1;
            
        end
        
        
        
    end
    
    
    clear var
    clear erp_ics
    clear n
    
    clear bas_deriv
    clear mean_deriv
    clear std_deriv
    clear rms_deriv
    clear rms_on_deriv
    clear rms_off_deriv
    clear deriv
    clear pos_template1
    clear pos_template2
    clear max_val
    clear pos_max
    clear pos_f
    
    rej=sort(unique([pos_exc_corr1 pos_exc1]));
    
    
    CIAC.output(s).ics=rej;
    CIAC.output(s).setname=ALLEEG(s).setname;
    
    
    erp_orig{s}=mean(EEG.data,3); %% saving erp for each dataset, in order to calculate grand average
    
    EEG2=pop_subcomp(EEG,  rej, 0); %% correcting ICs selected by CIAC - temporary, does not affect original data
    
    erp_corr{s}=mean(EEG2.data,3); %% saving erp for each corrected dataset, in order to calculate grand average
    
    
    
    if length(rej)<=9
        nx=3;
        ny=3;
        
    elseif length(rej)>9 && length(rej)<=16
        nx=4;
        ny=4;
        
    elseif length(rej)>16 && length(rej)<=25
        nx=5;
        ny=5;
        
    else
        nx=6;
        ny=6;
    end
    
    fig1name=['CI-ICs-' ALLEEG(s).setname];
    
    fig1=figure('Name', fig1name);
    
    dat=zeros(length(rej),3);
    rnames=cell(length(rej));
    
    for nn=1:length(rej);
        rnames{nn}=['IC=' num2str(rej(nn))];
        subplot(nx,ny,nn),topoplot(ALLEEG(s).icawinv(:,rej(nn)), ALLEEG(s).chanlocs);
        set(gca,'FontUnits','normalized')
        title(rnames{nn})
        %%%'; thr-dev=' num2str(th_der1(find(rej(nn)==len)), '%6.2f' )], ['thr-rv=' num2str(vari(rej(nn)),'%6.2f' ) '; thr-corr=' num2str(th_corr1(find(rej(nn)==len)),'%6.2f')]})
        dat(nn,:) = [th_der1( find(rej(nn)==len) ),vari(rej(nn)), th_corr1(find(rej(nn)==len))];
    end
    
    path=cd;
    
    if pl==0;
        cd(STUDY.filepath)
        print(fig1, '-dtiff', fig1name);
        close
        cd(path)
    end
    
    fig2name=['Thresholds-' ALLEEG(s).setname];
    
    fig2 = figure('Name',fig2name );
    cnames = {'thr-dev','thr-rv','thr-corr'};
    uitable('Parent',fig2,'Data',dat,'ColumnName',cnames,'RowName',rnames);
    
    if pl==0;
        cd(STUDY.filepath)
        print(fig2, '-dtiff', fig2name);
        close
        cd(path)
    end
    
    fig3name=['AEPs-' ALLEEG(s).setname];
    
    fig3=figure('Name',fig3name);
    
    subplot(1,2,1),
    plot(ALLEEG(s).times,erp_orig{s},'k'), hold on
    plot(ALLEEG(s).times,erp_orig{s}(Cz,:),'r','linew',2)
    set(gca,'FontUnits','normalized')
    ylabel('Amplitude [\muV]')
    xlabel('Time [ms]')
    set(gca,'YDir','reverse')
    title('Original AEP')
    ax=axis;
    line([t1 t1 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
    line([t2 t2 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
    line([t3 t3 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
    line([t4 t4 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
    
    line([tin tin ],[ax(3) ax(4)],'color','b')
    line([tfin tfin ],[ax(3) ax(4)],'color','b'), hold on
    xlim([ax(1) ax(2)])
    
    subplot(1,2,2), plot(ALLEEG(s).times,erp_corr{s},'k'), hold on
    plot(ALLEEG(s).times,erp_corr{s}(Cz,:),'r','linew',2)
    set(gca,'FontUnits','normalized')
    ylabel('Amplitude [\muV]')
    xlabel('Time [ms]')
    set(gca,'YDir','reverse')
    title('AEP after suggested correction')
    ax=axis;
    line([t1 t1 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
    line([t2 t2 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
    line([t3 t3 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
    line([t4 t4 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
    
    line([tin tin ],[ax(3) ax(4)],'color','b')
    line([tfin tfin ],[ax(3) ax(4)],'color','b')
    xlim([ax(1) ax(2)])
    
    if pl==0;
        cd(STUDY.filepath)
        print(fig3, '-dtiff', fig3name);
        close
        cd(path)
    end
    
    clear rej
    clear EEG2
    
    fprintf('\n')
    fprintf(['Graphic results for ''' ALLEEG(s).setname ''' will be displayed.'])
    fprintf('\n')
    fprintf('Please press any key to continue analysis for the next dataset.')
    fprintf('\n')
    if pl==1
        pause
    else
        pause(0.01)
    end
end


tot=min(chan); %% finding minimum number of channels in the STUDY

%%% to plot grand averages - for all datasets a number o fixed channels ('tot') is
%%% displayed

for j=1:length(chan)
    
    erp_orig_interp(:,:,j)=erp_orig{j}(1:tot,:);
    erp_corr_interp(:,:,j)=erp_corr{j}(1:tot,:);
    
end


fprintf('\n')
fprintf('Graphic results for grand average will be displayed.')
fprintf('\n')

figure('Name', ' AEPs - Grand average'),
subplot(1,2,1), plot(ALLEEG(1).times,mean(erp_orig_interp,3),'k'), hold on
plot(ALLEEG(1).times,mean(erp_orig_interp(Cz,:,:),3),'r','linew',2)
set(gca,'FontUnits','normalized')
ylabel('Amplitude [\muV]')
xlabel('Time [ms]')
set(gca,'YDir','reverse')
title('Original grand average AEP')

ax=axis;
line([t1 t1 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
line([t2 t2 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
line([t3 t3 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
line([t4 t4 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])

line([tin tin ],[ax(3) ax(4)],'color','b')
line([tfin tfin ],[ax(3) ax(4)],'color','b')


subplot(1,2,2), plot(ALLEEG(1).times,mean(erp_corr_interp,3),'k'), hold on
plot(ALLEEG(1).times,mean(erp_corr_interp(Cz,:,:),3),'r','linew',2)
set(gca,'FontUnits','normalized')
ylabel('Amplitude [\muV]')
xlabel('Time [ms]')
set(gca,'YDir','reverse')
title('Grand average AEP after suggested correction')

ax=axis;
line([t1 t1 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
line([t2 t2 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
line([t3 t3 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])
line([t4 t4 ],[ax(3) ax(4)],'color',[0.8 0.8 0.8])

line([tin tin ],[ax(3) ax(4)],'color','b')
line([tfin tfin ],[ax(3) ax(4)],'color','b')



fprintf('\n')
fprintf('CIAC processing is done \n')
toc
end

