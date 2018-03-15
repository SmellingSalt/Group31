% pop_modPMI() - postAmicaUtility plugin. Shows dependent subspace using
%                diagonalized correlation matrix. Clicking a pixel shows a
%                pair of ICs.

% Author
% Ozgur Baklan.

% Hisotry
% 12/26/2016 Makoto. Help editied.

% Copyright (C) Ozgur Baklan, SCCN, INC, UCSD.
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

function [EEG com] = pop_modPMI(EEG)

if ~isfield(EEG.etc,'amica')
    error('AMICA solution could not be found under EEG.etc');
end
com = '';
%%%%!!!!!!!!%%%%%  Allow epoched data??
if size(EEG.data,3) > 1
    error('Data should not be epoched for calculation of mutual information between IC''s');
end

guititle = 'AMICA - Plot Pairwise Mutual Information of Components Under Different Models';
%defaultModels = ['1:' num2str(EEG.etc.amica.num_models)];


cb_checkbox = ['str = get(gcbo,''tag''); str = [''editModel'' str(14:end)]; ob= findobj(''parent'',gcbf,''tag'',str); if ~get(gcbo,''value''), set(ob,''enable'',''off'');else, set(ob,''enable'',''on'');end;'];
cb_whichDataPoints = ['val = get(gcbo,''value''); if val == 1, set(findobj(''tag'',''smoothingTag''),''enable'',''on'');else, set(findobj(''tag'',''smoothingTag''),''enable'',''off'');end '];

str_cell_for_uilist = {};
geom_for_Models = {};
whichDataPoints = 'Only consider associated data points per model|Consider all data points for each model';
uilist = {{'style' 'text' 'string' 'ICs to calculate'}};
uigeom = {1};
for i = 1:EEG.etc.amica.num_models
    allICs = ['1:' num2str(size(EEG.etc.amica.A(:,:,i),2))];
    str_model = ['Model ' num2str(i)];
    tagCheckbox = ['checkboxModel' num2str(i)];
    tagEdit = ['editModel' num2str(i)];
    newCell = {{'style' 'checkbox' 'string' str_model 'callback' cb_checkbox 'tag' tagCheckbox 'value' fastif(i == 1, 1, 0)} {'style' 'edit' 'string' allICs 'tag' tagEdit 'enable' fastif(i == 1, 'on', 'off')}};
    str_cell_for_uilist = [str_cell_for_uilist newCell];
    geom_for_Models{i} = [1 1];
    uilist{1+(2*(i-1))+1} = newCell{1};
    uilist{2*i+1} = newCell{2};
    uigeom{i+1} = [1 1];
end


restOfuilist = {{'style' 'text' 'string' 'Winning model assignment based on: '} ...
    {'style' 'popupmenu' 'string' whichDataPoints 'callback' cb_whichDataPoints}...
    {'style' 'checkbox' 'string' 'Order components to get block diagonalized matrix' 'value' 1}};
    %{'style' 'text' 'string' 'Smoothing Window in sec.'}...
    %{'style' 'edit' 'string' '2' 'tag' 'smoothingTag'}...
    


uilist = [uilist restOfuilist];

uigeom = [uigeom [1 1] 1];

% 
% uilist = [{{'style' 'text' 'string' 'ICs to calculate'}}...
%     str_cell_for_uilist ...
%     {{'style' 'text' 'string' 'Winning model assignment based on: '} ...
%     {'style' 'popupmenu' 'string' smoothOrNot 'callback' cb_smooth}...
%     {'style' 'text' 'string' 'Smoothing Window in sec.'}...
%     {'style' 'edit' 'string' '2' 'tag' 'smoothingTag'}...
%     {'style' 'checkbox' 'string' 'Order components to get block diagonalized matrix' 'value' 1}}];


%uigeom = {1 geom_for_Models [1 1] [1 1] 1};

result = inputgui(uigeom, uilist, 'pophelp(''pop_modPMI'')', guititle, [], 'normal');
if isempty(result)
    return;
end

models2plot = [];
% which models2plot
j = 1;
for i = 1:2:length(result)-3
    models2plot(j) = result{i};
    j = j + 1;
end

models2plot = find(models2plot);
comps2plot = {};
j = 1;
for i = models2plot
    comps2plot{j} = unique(eval(['[' result{2*i} ']']));
    comps2plot{j} = sort(comps2plot{j});
    j = j + 1;
end
%models2plot = eval(['[' result{1} ']']);

%--------------------------------------
winningModels = [];
if result{end-1} == 2 %consider all data points
    
    calculatingOverAllDataPoints = true;
    
else
    calculatingOverAllDataPoints = false;
%     if result{end-2} == 1 %smoothing
%         %     prompt = {'Enter the smoothing Hanning window size: '};
%         %     name = 'Input for probability smoothing for AMICA';
%         %     numlines = 1;
%         %     defaultanswer = {'2'};
%         %     smoothlength = inputdlg(prompt,name,numlines,defaultanswer);
%         smoothlength = result{end-1};
%         disp('Smoothing..')
%         [~,llt_smooth] = smooth_amica_prob(EEG.srate,EEG.etc.amica.LLt,str2num(smoothlength));
%         winningModels = find_winners(llt_smooth);
%     else
        winningModels = find_winners(EEG.etc.amica.LLt);
%     end
end
order = result{end};

nRows = ceil(sqrt(length(models2plot)));
nCols = ceil(length(models2plot)/nRows);
SIZEBOX = 400;
try, icadefs;
catch
    BACKCOLOR = [.93 .96 1];
end;
nPlot = 1;
j = 1;
mo = {};
for i = models2plot
    
    compAct = (EEG.etc.amica.W(:,:,i)*EEG.etc.amica.S(:,EEG.icachansind))*EEG.data(EEG.icachansind,:);
    compAct = compAct(comps2plot{j},:,:);
    
    
    if calculatingOverAllDataPoints
        tmpData = compAct;
    else
        tmpData = compAct(:,winningModels == i,:);
    end
    
    if ~(size(tmpData,2) == 0 || size(tmpData,3) == 0)
        disp(['Calculating mutual information between components of model ' num2str(i) ' ..']);
        [MI,vMI]= minfo(tmpData);
        MI = MI - diag(diag(MI));
        if order
            disp('Ordering components to show statistical dependency..')
            [mo{i}, ord{i}] = arrminf2(MI);
            %[mo{i}, ord{i}] = arrminfFast(MI,1000);
            ord{i} = comps2plot{j}(ord{i});
            vmo{i} = vMI;
            close;
        else
            mo{i} = MI;
            vmo{i} = vMI;
            ord{i} = comps2plot{j};
        end
        if nPlot == 1
            f = figure;
            pos = get(f,'position');
            set(f,'position',[pos(1) pos(2) SIZEBOX*nCols SIZEBOX*nRows]);
            set(f,'color',BACKCOLOR)
        end
        figure(f);
        ax(nPlot) = subplot(nCols,nRows,nPlot);
        h = imagesc(mo{i});
        title(['Model ' num2str(i)],'fontsize',15);
        set(ax(nPlot),'xtick',1:size(compAct,1));
        set(ax(nPlot),'ytick',1:size(compAct,1));
        xTickLabel = num2str(ord{i}');
        yTickLabel = num2str(ord{i}');
        set(ax(nPlot),'xtickLabel',xTickLabel);
        set(ax(nPlot),'yticklabel',yTickLabel);
        set(ax(nPlot),'Tag',['Model ' num2str(i)]);
        set(h,'ButtonDownFcn',{@findPixelAndTopoplot,EEG,ord,mo})
        nPlot = nPlot + 1;
        j = j + 1;
    else
        disp(['Model ' num2str(i) ' is not the best model for any part of the data. Skipping this model.'])
    end
end

if ~isempty(mo)
EEG.etc.amica.mInfoMatrix = mo;
EEG.etc.amica.mInfoVar = vmo;
EEG.etc.amica.mInforOrders = ord;

lastAxesPos = get(ax(nPlot-1),'Position');
bottomBorder = lastAxesPos(2);
editBoxWidth = 0.05;
editBoxHeight = 0.03;
editBoxPosition = [0.5-editBoxWidth/2 (bottomBorder-editBoxHeight)/2 editBoxWidth editBoxHeight];

uicontrol('Parent',gcf,'style','edit','units','normalized','Position',editBoxPosition,'BackgroundColor',[1 1 1],'Tag','MaskBox',...
    'Callback',{@callback_MaskPMI,EEG,ax});

textPosition1 = [editBoxPosition(1)-0.12 editBoxPosition(2) editBoxPosition(3)*2 editBoxPosition(4) ];
textPosition2 = [editBoxPosition(1)+editBoxPosition(3)+0.01 editBoxPosition(2) editBoxPosition(3)*2 editBoxPosition(4) ];

uicontrol('Parent',gcf, ...
    'Units', 'normalized', ...
    'BackgroundColor',BACKCOLOR, ...
    'Position', textPosition1, ...
    'Style','text', ...
    'string','Masking >')


uicontrol('Parent',gcf, ...
    'Units', 'normalized', ...
    'BackgroundColor',BACKCOLOR, ...
    'Position', textPosition2, ...
    'Style','text', ...
    'string','std')



set(gcf,'Position', [1 1 500 nCols/nRows*400]);
disp('Mutual information matrix and re-ordering of components are copied under EEG.etc.amica');
end

disp('Done')
end

function findPixelAndTopoplot(~,~,EEG,ord,mo)

ax_current = gca;
str = get(ax_current,'Tag');
model = str2num(str(7:end));
ordering = ord{model};
mo_model = mo{model};
point = get(ax_current,'currentPoint');
x = round(point(1,1));
y = round(point(1,2));
ic1 = ordering(y);
ic2 = ordering(x);
figure;
if ic1 == ic2
    topoplot(EEG.etc.amica.A(:,ic1,model),EEG.chanlocs(EEG.icachansind));
else
    subplot(1,2,1); topoplot(EEG.etc.amica.A(:,ic1,model),EEG.chanlocs(EEG.icachansind)); title(['IC ' num2str(ic1)],'Fontsize',12);
    subplot(1,2,2); topoplot(EEG.etc.amica.A(:,ic2,model),EEG.chanlocs(EEG.icachansind)); title(['IC ' num2str(ic2)],'Fontsize',12);
    mInfoStr = ['Mutual Information between IC ' num2str(ic1) ' and IC ' num2str(ic2) ' under Model ' num2str(model) ' is ' num2str(mo_model(x,y))];
    text(-2,-1,mInfoStr);
end
end

function callback_MaskPMI(~,~,EEG,ax)
figh = gcbf;
obj = findobj('parent',figh,'Tag','MaskBox'); val = get(obj,'string'); val = str2num(val);

if ~isempty(val)
    disp('Masking..');
    
    for i = 1:size(EEG.etc.amica.mInfoMatrix,2)
        EEG.etc.amica.mInfoMasked{i} = [];
        
        
        if ~isempty(EEG.etc.amica.mInfoMatrix{i})
            offDiagInd = vec(~eye(size(EEG.etc.amica.mInfoMatrix{i},1)));
            stdOfOffDiagonals = std(EEG.etc.amica.mInfoMatrix{i}(offDiagInd));
        
            MImsk = EEG.etc.amica.mInfoMatrix{i} .* (EEG.etc.amica.mInfoMatrix{i} > val*stdOfOffDiagonals);
            EEG.etc.amica.mInfoMasked{i} = MImsk;
        end
    end
    ALLEEG = evalin('base','ALLEEG');
    CURRENTSET = evalin('base','CURRENTSET');
    [ALLEEG,EEG,CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
    assignin('base','ALLEEG',ALLEEG);
    assignin('base','CURRENTSET',CURRENTSET);
    assignin('base','EEG',EEG);
    disp('Masking Complete.');
    
end


disp('Updating figure..')
for i = 1:length(ax)
    plotObj = get(ax(i),'children');
    str = get(ax(i),'Tag');
    model = str2num(str(7:end));
    if ~isempty(val)
        set(plotObj,'Cdata',EEG.etc.amica.mInfoMasked{model});
    else
        set(plotObj,'Cdata',EEG.etc.amica.mInfoMatrix{model});
    end
end
disp('Done')

%evalin('base','eeglab(''redraw'');');
end




