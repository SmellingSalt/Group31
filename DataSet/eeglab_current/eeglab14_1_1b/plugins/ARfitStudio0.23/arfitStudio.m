function varargout = arfitStudio(varargin)
% arfitStudio MATLAB code for arfitStudio.fig
%      arfitStudio, by itself, creates a new arfitStudio or raises the existing
%      singleton*.
%
%      H = arfitStudio returns the handle to a new arfitStudio or the handle to
%      the existing singleton*.
%
%      arfitStudio('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in arfitStudio.M with the given input arguments.
%
%      arfitStudio('Property','Value',...) creates a new arfitStudio or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before arfitStudio_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to arfitStudio_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% 12/14/2015 ver 0.15 by Makoto. round(selectedEventLatency) after downsampling, it was not integer
% 05/22/2015 ver 0.14 by Makoto. Changed figure Name.
% 01/29/2015 ver 0.13 by Makoto. Show SOA and model order. set(handles.restoreOriginalData, 'Enable', 'on', 'Value', 0)
% 01/25/2015 ver 0.12 by Makoto. Debugged with Matlab 2013a
% 01/24/2015 ver 0.11 by Makoto. Unified to set(handle...) for compatibility (Thanks Michael Borich)
% 01/23/2015 ver 0.10 by Makoto. Created

% Edit the above text to modify the response to help arfitStudio

% Last Modified by GUIDE v2.5 28-Mar-2017 15:19:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @arfitStudio_OpeningFcn, ...
                   'gui_OutputFcn',  @arfitStudio_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before arfitStudio is made visible.
function arfitStudio_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to arfitStudio (see VARARGIN)

set(gcf, 'Name', 'ARfit Studio');

% Choose default command line output for arfitStudio
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes arfitStudio wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% check mcolon installation %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mcolonPath = which('mcolon');
if isempty(mcolonPath);
    % mcolon_install
    pathToHere = mfilename('fullpath');
    pathToMcolon = [pathToHere(1:end-11) 'external'];
    addpath(genpath(pathToMcolon));
    disp('Path to mcolon.m set')
end
set(handles.restoreOriginalData, 'Enable', 'off')


% --- Outputs from this function are returned to the command line.
function varargout = arfitStudio_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function enterCorrectionWindow_Callback(hObject, eventdata, handles)
% hObject    handle to enterCorrectionWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterCorrectionWindow as text
%        str2double(get(hObject,'String')) returns contents of enterCorrectionWindow as a double

% refresh all windows
if ishandle(get(handles.enterCorrectionWindow,'UserData'))
    delete(get(handles.enterCorrectionWindow,'UserData'))
end
if ishandle(get(handles.enterBlendingLength, 'UserData'))
    delete(get(handles.enterBlendingLength, 'UserData'))
end
if ishandle(get(handles.enterLearningLength, 'UserData'))
    delete(get(handles.enterLearningLength, 'UserData'))
end

% check if the input box is empty
userInput = str2num(get(handles.enterCorrectionWindow, 'String'));
if isempty(userInput)
    return
end

srate = evalin('base','EEG.srate');
maskLatency = userInput(1):1000/srate:userInput(2);
ylim = get(handles.erpPlot,'ylim');
env1 = repmat(ylim(1), [length(maskLatency),1]);
env2 = repmat(ylim(2), [length(maskLatency),1]);
X = [maskLatency,fliplr(maskLatency)];
Y = [env1',fliplr(env2')];

% if ~ishandle(get(handles.enterCorrectionWindow, 'UserData')) % this UserData stores the fill object handle
%     set(handles.enterCorrectionWindow,'UserData',[])
% end
hold on
maskHandle = fill(X,Y,[1 0 0], 'Edgecolor', [0.7 0.7 0.7]);
alpha(0.3)
set(handles.enterCorrectionWindow, 'UserData', maskHandle);
hold off
% update the blending and learning
enterBlendingLength_Callback(hObject, eventdata, handles)
enterLearningLength_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function enterCorrectionWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterCorrectionWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function enterBlendingLength_Callback(hObject, eventdata, handles)
% hObject    handle to enterBlendingLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterBlendingLength as text
%        str2double(get(hObject,'String')) returns contents of enterBlendingLength as a double

% if mask object is present, clear it
if ishandle(get(handles.enterBlendingLength, 'UserData'))
    delete(get(handles.enterBlendingLength, 'UserData'))
end

% if the input box is empty, return
userInput = str2num(get(handles.enterBlendingLength, 'String'));
if isempty(userInput)
    return
end

% if correctionWindow has user input
if isempty(str2num(get(handles.enterCorrectionWindow, 'String')));
    error('Enter correction window first.')
end

srate = evalin('base','EEG.srate');
mainMaskUpperBound = max(get(get(handles.enterCorrectionWindow,'UserData'), 'XData'));
blendingLatency    = mainMaskUpperBound:1000/srate:mainMaskUpperBound+userInput;
ylim = get(handles.erpPlot,'ylim');
env1 = repmat(ylim(1), [length(blendingLatency),1]);
env2 = repmat(ylim(2), [length(blendingLatency),1]);
X = [blendingLatency,fliplr(blendingLatency)];
Y = [env1',fliplr(env2')];

hold on
blendingHandle = fill(X,Y,[1 0 0], 'Edgecolor', [0.7 0.7 0.7]);
alpha(blendingHandle, 0.1)
set(handles.enterBlendingLength, 'UserData', blendingHandle);
hold off

% --- Executes during object creation, after setting all properties.
function enterBlendingLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterBlendingLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function enterLearningLength_Callback(hObject, eventdata, handles)
% hObject    handle to enterLearningLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterLearningLength as text
%        str2double(get(hObject,'String')) returns contents of enterLearningLength as a double

% if mask object is present, clear it
if ishandle(get(handles.enterLearningLength, 'UserData'))
    delete(get(handles.enterLearningLength, 'UserData'))
end

% if the input box is empty, return
userInput = str2num(get(handles.enterLearningLength, 'String'));
if isempty(userInput)
    return
end

% if correctionWindow has user input
if isempty(str2num(get(handles.enterCorrectionWindow, 'String')));
    error('Enter correction window first.')
end

srate = evalin('base','EEG.srate');
mainMaskLowerBound = min(get(get(handles.enterCorrectionWindow,'UserData'), 'XData'));
learningLatency    = mainMaskLowerBound-userInput:1000/srate:mainMaskLowerBound;

ylim = get(handles.erpPlot,'ylim');
env1 = repmat(ylim(1), [length(learningLatency ),1]);
env2 = repmat(ylim(2), [length(learningLatency ),1]);
X = [learningLatency ,fliplr(learningLatency )];
Y = [env1',fliplr(env2')];

hold on
learningHandle = fill(X,Y,[0 1 0], 'Edgecolor', [0.7 0.7 0.7]);
alpha(learningHandle, 0.2)
set(handles.enterLearningLength, 'UserData', learningHandle);
hold off


% --- Executes during object creation, after setting all properties.
function enterLearningLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterLearningLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in eventMarkerList.
function eventMarkerList_Callback(hObject, eventdata, handles)
% hObject    handle to eventMarkerList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns eventMarkerList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eventMarkerList

drawPlot(hObject, eventdata, handles)
enterCorrectionWindow_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function eventMarkerList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventMarkerList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

EEG.event = evalin('base','EEG.event');
if isempty(EEG.event)
    error('Load continuous EEG dataset with events.')
end
set(hObject, 'String', unique({EEG.event.type}));
set(hObject, 'Max', length(get(hObject, 'String')));

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function enterEpochLatency_Callback(hObject, eventdata, handles)
% hObject    handle to enterEpochLatency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterEpochLatency as text
%        str2double(get(hObject,'String')) returns contents of enterEpochLatency as a double

drawPlot(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function enterEpochLatency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterEpochLatency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'String', '-100 100'); % default value

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function enterAmpLimit_Callback(hObject, eventdata, handles)
% hObject    handle to enterAmpLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterAmpLimit as text
%        str2double(get(hObject,'String')) returns contents of enterAmpLimit as a double

userInput = str2num(get(hObject,'String')); %#ok<*ST2NM>
if isempty(userInput)
    drawPlot(hObject, eventdata, handles)
else
    ylim([userInput(1)*1.05 userInput(2)*1.05]);
end

enterCorrectionWindow_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function enterAmpLimit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enterAmpLimit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'String', '')

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function drawPlot(hObject, eventdata, handles)
EEG = evalin('base', 'EEG');
listIdx = get(handles.eventMarkerList, 'Value');
allMarker = get(handles.eventMarkerList, 'String');
selectedMarker = allMarker(listIdx)';
allEvent = {EEG.event.type};
selectedEventIdx = find(ismember(allEvent,selectedMarker));
selectedEventLatency = cell2mat({EEG.event(selectedEventIdx).latency}');

if length(listIdx)==1
    listSOA = diff(selectedEventLatency)*1000/EEG.srate;
    tmpString = sprintf('Mean SOA %d ms (SD %d, Range %d-%d)', round(mean(listSOA)), round(std(listSOA)), round(min(listSOA)), round(max(listSOA)));
    set(handles.displaySOA, 'String', tmpString, 'Enable', 'on')
else
    set(handles.displaySOA, 'String', 'Not available for Multiple selections', 'Enable', 'off')
end

epochBoundary = str2num(get(handles.enterEpochLatency, 'String'));
epochStartInFrame = round(epochBoundary(1)/1000*EEG.srate); % frame should be integer
epochEndInFrame   = round(epochBoundary(2)/1000*EEG.srate); % frame should be integer
epochLatencyInMillisecond = (epochStartInFrame:epochEndInFrame)*1000/EEG.srate;
windowStart = round(selectedEventLatency)+epochStartInFrame; % frame should be integer
windowEnd   = round(selectedEventLatency)+epochEndInFrame;   % frame should be integer
includeLatencyIdx = mcolon(windowStart,windowEnd);
continuousData = EEG.data(:,includeLatencyIdx);
epochData = reshape(continuousData, [size(EEG.data,1), length(epochStartInFrame:epochEndInFrame), length(selectedEventIdx)]);
if epochBoundary(1)<0
    plotLatency = epochBoundary(1):1000/EEG.srate:epochBoundary(2);
    baselineLatency = find(plotLatency<0);
    baselineCorrect = bsxfun(@minus, epochData, median(epochData(:,baselineLatency,:),2)); %#ok<*FNDSB>
else
    baselineCorrect = bsxfun(@minus, epochData, median(epochData,2));
end
medianData = median(baselineCorrect,3);
plot(handles.erpPlot, epochLatencyInMillisecond, medianData')
hold on
xlim(epochBoundary)
if isempty(get(handles.enterAmpLimit, 'String'))
    ampLowerBound = floor(min(medianData(:)));
    ampUpperBound = ceil(max(medianData(:))); 
    ylim([ampLowerBound*1.05 ampUpperBound*1.05]);
    set(handles.enterAmpLimit,'String', num2str([ampLowerBound ampUpperBound]))
else
    userInput = str2num(get(handles.enterAmpLimit,'String'));
    ylim([userInput(1)*1.05 userInput(2)*1.05]);
end
plot(handles.erpPlot, xlim, [0 0], 'Color',[.6 .6 .6])
plot(handles.erpPlot, [0 0], ylim, 'LineStyle','--', 'Color',[.6 .6 .6])
hold off

xlabel('Latency (ms)');
ylabel('Amplitude (uV)');
set(handles.erpPlot, 'box', 'off');
set(findall(gca,'-property','FontSize'),'FontSize',13)

enterCorrectionWindow_Callback(hObject, eventdata, handles)


% --- Executes on button press in runARFIT.
function runARFIT_Callback(hObject, eventdata, handles)
% hObject    handle to runARFIT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% prepare epochedData
EEG = evalin('base', 'EEG');
listIdx = get(handles.eventMarkerList, 'Value');
allMarker = get(handles.eventMarkerList, 'String');
selectedMarker = allMarker(listIdx)';

allEvent = {EEG.event.type};
selectedEventIdx = find(ismember(allEvent,selectedMarker));
selectedEventLatency = cell2mat({EEG.event(selectedEventIdx).latency}');
epochStartInMillisecond = min(get(get(handles.enterLearningLength,'UserData'),'XData'));
if isempty(get(handles.enterBlendingLength,'String'))
    epochEndInMillisecond = max(get(get(handles.enterCorrectionWindow,'UserData'),'XData'));
else
    epochEndInMillisecond = max(get(get(handles.enterBlendingLength,'UserData'),'XData'));
end
epochInMillisecond = epochStartInMillisecond:1000/EEG.srate:epochEndInMillisecond;
startFrame = round(epochInMillisecond(1)/(1000/EEG.srate));
endFrame   = round(epochInMillisecond(end)/(1000/EEG.srate));
allEpochStartInFrame = selectedEventLatency+startFrame;
allEpochEndInFrame   = selectedEventLatency+endFrame-1; % -1 is to absorb the width of selectedEventLatency
includeLatencyIdx = mcolon(allEpochStartInFrame,allEpochEndInFrame);
continuousData = EEG.data(:,includeLatencyIdx);
epochedData = reshape(continuousData, [size(EEG.data,1), endFrame-startFrame, length(selectedEventIdx)]);

% prepare correctionWindow and blendingLength
correctionStartInFrame = round(min(get(get(handles.enterCorrectionWindow, 'UserData'),'XData'))/(1000/EEG.srate));
if isempty(get(handles.enterBlendingLength,'String'))
    epochEndInFrame = round(max(get(get(handles.enterCorrectionWindow, 'UserData'),'XData'))/(1000/EEG.srate));
    startEndIdx = [correctionStartInFrame epochEndInFrame]-round(epochStartInMillisecond/(1000/EEG.srate)); % subtract epoch(1) to obtain the frame idx
    blendingLength = 0;
else
    blendingEndInFrame = round(max(get(get(handles.enterBlendingLength,'UserData'),'XData'))/(1000/EEG.srate));
    startEndIdx = [correctionStartInFrame blendingEndInFrame]-round(epochStartInMillisecond/(1000/EEG.srate)); % subtract epoch(1) to obtain the frame idx
    correctionEndInFrame = round(max(get(get(handles.enterCorrectionWindow,'UserData'),'XData'))/(1000/EEG.srate));
    blendingLength = blendingEndInFrame-correctionEndInFrame; % the last n frames of the correctionWindow will be used for blending
end

% run arfit2interpolate
processedData = arfit2interpolate(epochedData, startEndIdx, blendingLength);

% % if detrend
% for n = 1:size(processedData)
%     beforeDetrend = squeeze(processedData(n,startEndIdx(1):startEndIdx(2),:));
%     meanStore     = beforeDetrend-detrend(beforeDetrend,'constant');
%     afterDetrend  = detrend(beforeDetrend)+meanStore;
%     processedData(n,startEndIdx(1):startEndIdx(2),:) = afterDetrend;
% end

% put back to the continuous data
originalData = EEG.data;
assignin('base', 'originalData', originalData);
% clear originalData
correctedData = EEG.data;
correctedData(:,includeLatencyIdx) = processedData(:,:);

assignin('base', 'correctedData', correctedData);
EEG.data = correctedData;
assignin('base', 'EEG', EEG)
clear correctedData

drawPlot(hObject, eventdata, handles)
set(handles.restoreOriginalData, 'Enable', 'on', 'Value', 0)

% --- Executes on button press in restoreOriginalData.
function restoreOriginalData_Callback(hObject, eventdata, handles)
% hObject    handle to restoreOriginalData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of restoreOriginalData
if any(get(hObject,'Value'))
    EEG = evalin('base', 'EEG');
    originalData = evalin('base', 'originalData');
    EEG.data = originalData;
    assignin('base', 'EEG', EEG);
    drawPlot(hObject, eventdata, handles)
else
    EEG = evalin('base', 'EEG');
    correctedData = evalin('base', 'correctedData');
    EEG.data = correctedData;
    assignin('base', 'EEG', EEG);
    drawPlot(hObject, eventdata, handles)
end
