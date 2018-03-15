% pop_HilbertFourierSpectrum() - plot Hilbert & Fourier spectrum of the modes for a specific channel.
% Usage:
%   >> pop_HilbertFourierSpectrum( EEG);           % pops up a query window 
%   >> pop_HilbertFourierSpectrum( EEG, chan, ermind);
%
% Inputs:
%   EEG        - EEGLAB dataset structure
%
% Optional inputs:
%  
%   chan      - channel number to display {default: 1}
%   ermind    - mode number[s] to display {default: all}
%   aveERMs   - plot ERM option {default: 1};
%   HilbertS  - plot Hilbert Spectrum {default: 1};
%   FourierS  - plot Fourier Spectrum {default: 1};	
%
% 
%
%  This code is written by Karema Al-Subari (Karema.Al-Subari@ur.de) and Saad Al-Baddai (Saad.Al-Baddai@ur.de).
% 
%


function com = pop_HilbertFourierSpectrum(EEG, chan, ermind)



com = '';

if ~isfield( EEG,'IMFs' )
		errordlg2(strvcat('Error: no data to plot.'), 'Error'); return;
	end;

if nargin < 1
	help pop_HilbertFourierSpectrum;
	return;   
end;

if nargin == 2
	errordlg2(strvcat('Error: You should select the mode number.'), 'Error'); return;
	return;   
end;
   
 
 % channel labels
    % --------------
    if ~isempty(EEG.emdchanlocs)
           tmpchanlocs = EEG.emdchanlocs;        
           alllabels = { tmpchanlocs.labels };
           
    else
        for index = 1:EEG.emdnbchan
            alllabels{index} = int2str(index);
        end;
    end;
    
  if nargin >= 3
    channum    = chan;
    chan       = alllabels(chan);
    Freqlimits = [];
    aveERMs    = 1;
    trialIMFs  = 0;
    HilbertS   = 1;
    FourierS   = 1;
	
  end;
  

  
   commanderms = [ 'for i=2:size(EEG.IMFs,2),'...
                   'ermNames{i-1}=strcat(''MODE_'',num2str(i-1));'...
                   'end;'...
                   'set(findobj(gcbf, ''tag'', ''chanind''), ''string'', ' ...
                   'int2str(pop_erms(ermNames)));'...
                    'clear ermNames;'];
                
   commandRADIOerms = [ 'set(findobj(gcbf, ''tag'', ''radio1''), ''value'',(1));'...
                        'set(findobj(gcbf, ''tag'', ''Freqlimits''), ''enable'',''off'');'...
                        'set(findobj(gcbf, ''tag'', ''radio2''), ''value'', ' ...
                        '(0));'];
                
  commandRADIOimfs = [ 'set(findobj(gcbf, ''tag'', ''radio1''), ''value'', 0);'...
                     'set(findobj(gcbf, ''tag'', ''Freqlimits''), ''enable'',''on'');'...
                     'set(findobj(gcbf, ''tag'', ''radio2''), ''value'', ' ...  
                     '(1));'];
                 
 
      
 
if nargin == 1

geometry = { [1 0.5] [] [1 1.5] [] [1 1.5] [] [1] [1 1.5] [] [1] [1 1]};

promptstr    = {                                { 'style' 'text' 'String' 'Select Chanel:'}, ...
                                                { 'style' 'popup' 'string' strvcat(alllabels{:}) 'tag' 'params'  }, ...
                                                { 'style' 'pushbutton' 'string' '.. Select Modes' 'callback' commanderms 'fontweight', 'bold' },...
                                                { 'style' 'edit'       'string' '' 'tag' 'chanind' }, ...
                                                { 'style' 'text' 'string' 'Choose Freq limits [min max](Optional):' }, ...
                                                { 'style' 'edit'       'string' '' 'tag' 'Freqlimits' }, ...
                                                { 'style' 'text' 'string' 'Choose ERM or IMFs:' }, ...
						                        { 'style' 'radiobutton'       'string' 'ERMs' 'tag' 'radio1' 'callback' commandRADIOerms 'value', 0 'BackgroundColor' [ 0.6600    0.7600    1.0000]},...
                                                { 'style' 'radiobutton'       'string' 'IMFs' 'tag' 'radio2' 'callback' commandRADIOimfs 'value', 0  'BackgroundColor' [ 0.6600    0.7600    1.0000]},...
                                                { 'style' 'text' 'string' 'Select Frequency Spectrum:' }, ...
						                        { 'style' 'checkbox'       'string' 'Hilbert-Huang spectrum' 'tag' 'params1'  },...
                                                { 'style' 'checkbox'       'string' 'Fourier spectrum' 'tag' 'params2'}};
		
		result       = inputgui( geometry, promptstr,'Hilbert-Huang/Fourier Transform - pop_HilbertFourierSpectrum()', 'Hilbert-Huang/Fourier Transform - pop_HilbertFourier()');
                if size( result, 1 ) == 0 return; end;

                chan         = alllabels(result{1});
                channum      = (result{1});
                ermind       = str2num(result{2});

                Freqlimits   = (str2num(result{3}));
                aveERMs     = result{4};
                trialIMFs     = result{5};
                HilbertS     = result{6};
                FourierS     = result{7};
 

end;
 if length(Freqlimits)> 2 | length(Freqlimits) == 1
     
          errordlg2(strvcat('Error: The frequency limits should be 2 values: min and max!!'), 'Error'); return;
 end
   gaus = fspecial('gaussian',4,4);  
EEG.IMFs=EEG.IMFs(:,2:end,:,:);

if length(ermind)==0
  ermind = 1:size(EEG.IMFs,2) ; 
end

for j=1:length(ermind)
   leERMs{j}= strcat('ERM-',num2str(ermind(j)));
   leIMFs{j}= strcat('IMF-',num2str(ermind(j)));

end

                        
% assumed input is chan
% -------------------------
try, icadefs; 
catch, 
	BACKCOLOR = [0.8 0.8 0.8];
	GUIBUTTONCOLOR   = [0.8 0.8 0.8]; 
end;
 
basename = strcat('Channel(',chan{1},',',strjoin(leERMs),')'); 
IMFname = strcat('Channel(',chan{1},',',strjoin(leIMFs),')'); 
%fh = figure( 'color', BACKCOLOR, 'numbertitle', 'off', 'visible', 'off');
fig1=figure('name', ['Hilbert-Huang / Fourier Spectrum - ' basename],'units','normalized', 'color', BACKCOLOR );
pos = get(fig1,'Position');
%set(gcf,'Position', [pos(1) pos(2)-500+pos(4) 500 500], 'visible', 'on');

pos = get(gca,'position'); % plot relative to current axes
hh = gca;
q = [pos(1) pos(2) 0 0];
s = [pos(3) pos(4) pos(3) pos(4)]./100;
axis off;

ermtimes = linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts);
f = (0:EEG.pnts/2)/(2*(EEG.pnts/2)/EEG.pnts);
modes=squeeze(mean(EEG.IMFs(channum,ermind,:,:),4));
modestrials = squeeze(EEG.IMFs(channum,ermind,:,:));
  if length(ermind) == 1, modes=modes'; modestrials=reshape(modestrials,1,size(modestrials,1),size(modestrials,2)); end
  
  if trialIMFs == 1
      [hilbertSpectrum ,hilbertAmplitude, FourierSpectrum] = hilberFourierN(modestrials,1/EEG.srate);
  elseif aveERMs == 1
      [hilbertSpectrum ,hilbertAmplitude, FourierSpectrum  ] = hilberFourierN(modes,1/EEG.srate);
  end
% plotting Hilbert Spectrum

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  ERMs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (HilbertS == 1 & FourierS == 1) && aveERMs == 1

h = axes('Units','Normalized', 'Position',[5 60 95 40].*s+q);
  

  for j=1:size(modes,1)
      
   x = ermtimes;
   y = hilbertSpectrum(j,:);
   z = zeros(size(y));
   col = hilbertAmplitude(j,1:size(hilbertSpectrum,2));  % This is the color, vary with x in this case.
   surface([x;x],[y;y],[z;z],[col;col],'facecol','no','edgecol','interp','linew',1,'LineStyle',':','LineWidth',2);
   hold on
     set(gca, 'xlim', [EEG.xmin*1000 EEG.xmax*1000],'ylim', [0 max(hilbertSpectrum(:))],  'color', [0.6 0.6 0.6]);xlabel('Time (ms)');ylabel('Frequency (Hz)');
        
   end

  c = colorbar; ylabel(c, 'Instantaneous Amplitude')
   title('Hilbert Spectrum', 'fontsize', 12,'fontweight','bold'); 


% plotting Fourier Spectrum


	h = axes('units','normalized', 'position',[5 5 80 40].*s+q);
        
       

        for j=1:size(modes,1)
 
           plot(f,FourierSpectrum(j,1:length(f)),'LineWidth',2);
           hold all
           set(gca, 'color', [0 0 0],'XLim',[0 max(hilbertSpectrum(:))]);
        end

       legend(leERMs,'fontname','times','color','w');
       xlabel('Frequency (Hz)'); ylabel('Magnitude'); set(gca,'XLim',[0 max(hilbertSpectrum(:))],'color', [0.6 0.6 0.6]);
       title('Fourier Spectrum', 'fontsize',12,'fontweight','bold'); 
     
elseif (HilbertS == 1 | FourierS == 1) && aveERMs == 1

    h = axes('Units','Normalized', 'Position',[5 5 95 95].*s+q); 
     
    
    if  HilbertS == 1 && aveERMs == 1

      for j=1:size(modes,1)

        x = ermtimes;
        y = hilbertSpectrum(j,:);
        z = zeros(size(y));
        col =  hilbertAmplitude(j,1:size(hilbertSpectrum,2));  % This is the color, vary with x in this case.
        surface([x;x],[y;y],[z;z],[col;col],'facecol','no','edgecol','interp','linew',1,'LineStyle',':','LineWidth',2);
        hold on
        set(gca, 'xlim', [EEG.xmin*1000 EEG.xmax*1000],'ylim', [0 max(hilbertSpectrum(:))], 'color', [0.6 0.6 0.6]);xlabel('Time (ms)');ylabel('Frequency (Hz)');
        
      end

      c = colorbar; ylabel(c, 'Instantaneous Amplitude')

      title('Hilbert Spectrum', 'fontsize', 12,'fontweight','bold'); 

    else
        for j=1:size(modes,1)
            plot(f,FourierSpectrum(j,1:length(f)),'LineWidth',2);
            hold all
            set(gca, 'color', [0 0 0]); 
        end

        legend(leERMs,'fontname','times','color','w');
        set(gca,'XLim',[0 max(hilbertSpectrum(:))],'color', [0.6 0.6 0.6]);
        xlabel('Frequency (Hz)'); ylabel('Magnitude'); 
        title('Fourier Spectrum', 'fontsize',12,'fontweight','bold'); 

    end

%%%%%%%%%%%%%%%%%%%% Trials  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55    
 
elseif (HilbertS == 1 | FourierS == 1) && trialIMFs == 1   
    close(fig1);
 if HilbertS == 1
     figure('name', ['Hilbert-Huang / Fourier Spectrum - ' IMFname],'units','normalized', 'color', BACKCOLOR );
    for j=1:size(hilbertSpectrum,1)
        
       if size(hilbertSpectrum,1) <=3;
          subplot(1,size(hilbertSpectrum,1),j)
          if length(Freqlimits) == 2
           imagesc(EEG.xmin*1000:EEG.xmax*1000,1:1:size(hilbertSpectrum,3),flipud(imfilter((squeeze(hilbertSpectrum(j,:,:))'),gaus)),[Freqlimits(1) Freqlimits(2)]);
           set(gca,'YTick',[1:1:size(hilbertSpectrum,3)]);
           set(gca,'YDir','normal'); xlabel('Time (ms)');    ylabel('Trials');
            c = colorbar; ylabel(c, 'Instantaneous Frequency')
          else
          imagesc(EEG.xmin*1000:EEG.xmax*1000,1:1:size(hilbertSpectrum,3),flipud(imfilter((squeeze(hilbertSpectrum(j,:,:))'),gaus)));
          set(gca,'YTick',[1:1:size(hilbertSpectrum,3)]);
          set(gca,'YDir','normal');xlabel('Time (ms)');    ylabel('Trials');
           c = colorbar; ylabel(c, 'Instantaneous Frequency')
          end
          
           % delete(findobj(0,'type','axes'))
       else
         subplot(fix(size(hilbertSpectrum,1)/2),3,j)
           if length(Freqlimits) == 2
           imagesc(EEG.xmin*1000:EEG.xmax*1000,1:size(hilbertSpectrum,3),flipud(imfilter((squeeze(hilbertSpectrum(j,:,:))'),gaus)),[Freqlimits(1) Freqlimits(2)]);
           set(gca,'YTick',[1:1:size(hilbertSpectrum,3)]);
           set(gca,'YDir','normal');xlabel('Time (ms)');    ylabel('Trials');
            c = colorbar; ylabel(c, 'Instantaneous Frequency')
           else
            imagesc(EEG.xmin*1000:EEG.xmax*1000,1:size(hilbertSpectrum,3),flipud(imfilter((squeeze(hilbertSpectrum(j,:,:))'),gaus)));
           set(gca,'YTick',[1:1:size(hilbertSpectrum,3)]);
            set(gca,'YDir','normal');xlabel('Time (ms)');    ylabel('Trials');
            c = colorbar; ylabel(c, 'Instantaneous Frequency')
           end
       end
    end
 end
 if FourierS == 1
  figure('name', ['Hilbert-Huang / Fourier Spectrum - ' IMFname],'units','normalized', 'color', BACKCOLOR );
    for j=1:size(FourierSpectrum,1)
        
       if size(FourierSpectrum,1) <=3;
           subplot(1,size(FourierSpectrum,1),j)
         if length(Freqlimits) == 2
           imagesc(Freqlimits(1): Freqlimits(2),1:size(FourierSpectrum,3),flipud(imfilter((squeeze(FourierSpectrum(j,Freqlimits(1):Freqlimits(2),:))'),gaus)));
           set(gca,'YTick',[1:1:size(FourierSpectrum,3)]);
           set(gca,'YDir','normal');  xlabel('Frequency (Hz)');    ylabel('Trials');   
            c = colorbar; ylabel(c, 'Amplitude')
         else
            imagesc(0:max(max(squeeze(hilbertSpectrum(j,:,:)))),1:size(FourierSpectrum,3),flipud(imfilter((squeeze(FourierSpectrum(j,1:length(f),:))'),gaus)));
            set(gca,'YTick',[1:1:size(FourierSpectrum,3)]);
            set(gca,'YDir','normal'); xlabel('Frequency (Hz)');ylabel('Trials');
            c = colorbar; ylabel(c, 'Amplitude')
         end
  
       else
         subplot(fix(size(FourierSpectrum,1)/2),3,j)
          if length(Freqlimits) == 2
           imagesc(Freqlimits(1): Freqlimits(2),1:size(FourierSpectrum,3),flipud(imfilter((squeeze(FourierSpectrum(j,Freqlimits(1):Freqlimits(2),:))'),gaus)));
           set(gca,'YTick',[1:1:size(FourierSpectrum,3)]);
           set(gca,'YDir','normal');   xlabel('Frequency (Hz)'); ylabel('Trials');
            c = colorbar; ylabel(c, 'Amplitude')
          else
              imagesc(0:length(f),1:size(FourierSpectrum,3),flipud(imfilter((squeeze(FourierSpectrum(j,1:length(f),:))'),gaus)));
             set(gca,'YTick',[1:1:size(FourierSpectrum,3)]);
              set(gca,'YDir','normal');   xlabel('Frequency (Hz)');ylabel('Trials');
            c = colorbar; ylabel(c, 'Amplitude')
          end
      end
    end
 end
   

elseif  (HilbertS == 0 & FourierS == 0 & aveERMs == 1) | (HilbertS == 0 & FourierS == 0 & trialIMFs == 1)  | (HilbertS == 0 & FourierS == 0 & trialIMFs == 0 & aveERMs == 0) | (HilbertS == 1 & FourierS == 0 & trialIMFs == 0 & aveERMs == 0)  | (HilbertS == 0 & FourierS == 1 & trialIMFs == 0 & aveERMs == 0)  | (HilbertS == 1 & FourierS == 1 & trialIMFs == 0 & aveERMs == 0)
    
     errordlg2(strvcat('Error: Select the Type of Spectrum or at least one selection is missing!!'), 'Error'); return;
end
   
com = sprintf('pop_HilbertFourierSpectrum( %s, %s, [%s]);', inputname(1), int2str(channum), int2str(ermind));


return;

