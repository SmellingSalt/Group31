function varargout = gui_weighting_matrix(varargin)
% GUI_WEIGHTING_MATRIX M-file for gui_weighting_matrix.fig
%      GUI_WEIGHTING_MATRIX, by itself, creates a new GUI_WEIGHTING_MATRIX or raises the existing
%      singleton*.
%
%      H = GUI_WEIGHTING_MATRIX returns the handle to a new GUI_WEIGHTING_MATRIX or the handle to
%      the existing singleton*.
%
%      GUI_WEIGHTING_MATRIX('CALLBACK',hObject,eventData,handles,...) calls
%      the local
%      function named CALLBACK in GUI_WEIGHTING_MATRIX.M with the given input arguments.
%
%      GUI_WEIGHTING_MATRIX('Property','Value',...) creates a new
%      GUI_WEIGHTING_MATRIX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_weighting_matrix_OpeningFunction gets
%      called.  An
%      unrecognized property name or invalid value makes property
%      application
%      stop.  All inputs are passed to gui_weighting_matrix_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright (C) 2009 The Bergen fMRI Group
% 
% Bergen fMRI Group, Department of Biological and Medical Psychology,
% University of Bergen, Norway
% 
% Written by Emanuel Neto, 2009
% netoemanuel@gmail.com
% 
% Last Modified on 04-Nov-2009 14:30:11
%
% Bug fix loading files in Linux
% Information pop-up Message Boxes were included
% Step 1 - Option that allow users to associate 1 Marker to 1 artifact onset or 1 Marker to each slices of the artifact.


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_weighting_matrix_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_weighting_matrix_OutputFcn, ...
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


% -------------------------------------------------------------------
% ------------------ Start of Weighting Matrix Gui ------------------
% -------------------------------------------------------------------
function gui_weighting_matrix_OpeningFcn(hObject, eventdata, handles, varargin)
global method_type
method_type = 1;
guidata(hObject, handles);
set(handles.methodType_buttongroup,'SelectionChangeFcn',@methodType_buttongroup_SelectionChangeFcn);
set(handles.scan_method,'SelectionChangeFcn',@scan_method_SelectionChangeFcn);
set(handles.Baseline_panel,'SelectionChangeFcn',@Baseline_panel_SelectionChangeFcn);
% set(handles.Artifact_Range_Selection,'SelectionChangeFcn',@Artifact_Range_Selection_SelectionChangeFcn);
set(handles.figure1,'CloseRequestFcn',@closeGUI);

guidata(hObject, handles);
% Choose default command line output for gui_weighting_matrix
handles.output = hObject;
% Update handles structure
Goto_0_Callback(hObject, eventdata, handles);
guidata(hObject, handles);
% UIWAIT makes gui_weighting_matrix wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% -------------------------------------------------------------------
% ------------------- End of Weighting Matrix Gui -------------------
% -------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = gui_weighting_matrix_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;



% -------------------------------------------------------------------
% ---------------------- Cancel & Exit Button -----------------------
% -------------------------------------------------------------------
function cancel_btt_Callback(hObject, eventdata, handles)
% Close some variables?
str = get(handles.cancel_btt,'String');
switch str 
    case 'Finish' 
        delete(gcf)
    case 'Exit'
        delete(gcf)
    otherwise
        closeGUI()
end
function closeGUI(src,evnt)
%src is the handle of the object generating the callback (the source of the
%event)
%evnt is the The event data structure (can be empty for some callbacks)
selection = questdlg('Do you want to close Artifact Corretion Plugin?',...
                 'Close Request Function',...
                 'Yes','No','Yes');
    switch selection,
       case 'Yes',
        delete(gcf)
       case 'No'
         return
    end

%         ------------- End of Cancel and Exit -------------


% ###################################################################
% ################# Interface for Markers Detection #################
% ###################################################################

function Goto_0_Callback(hObject, eventdata, handles)
global EEG log_string
global cmatrix_methodtype weighting_matrix
cmatrix_methodtype = [];
weighting_matrix = [];
% Update Logtext_box
set(handles.log_text,'String','Please choose method.');
% Hide last page
    % Boxes
    set(handles.methodType_buttongroup,'Visible','Off');
%     set(handles.rp_parameters,'Visible','Off');
    set(handles.Weighting_matrix_vizualiz,'Visible','Off');
    % Buttons
    set(handles.Calculate,'Visible','Off');
    set(handles.Reset_1,'Visible','Off');
    set(handles.Goto_0,'Visible','Off');
    set(handles.Back_1_btt,'Visible','On');
    set(handles.Back_1_btt,'Enable','Off');    
% Show interface to define Artifacts Detection Method
    % Interface
    set(handles.axes3Panel,'Visible','On');
%     set(handles.EEG_Information,'Visible','On');
    set(handles.scan_method,'Visible','On');
%     set(handles.control_panel,'Visible','On');
%     zoom off;
%     datacursormode off;
    % Buttons
%     set(handles.Next_2,'Visible', 'On');
    set(handles.Detect_artifacts_btt,'Visible', 'On');
%     set(handles.Detect_artifacts_btt,'Visible', 'On');
    set(handles.Next_1,'Visible', 'On');

% Load and Update DataSet_Info
try 
    log_string = ['           The Bergen EEG&fMRI Toolbox',10,'fMRI Artifacts Removal Plugin for EEGLAB - Ver.1.0',10,10];
    log_string = [log_string, 'Date and Time: ', num2str(datestr(now)),10];
    log_string = [log_string, EEG.comments, 10];
    log_string = [log_string, 'Number of channels: ', num2str(EEG.nbchan), 10];
    log_string = [log_string, 'Sampling rate: ', num2str(EEG.srate), 10,10];
      [x,y] = size(EEG.data);
%     EEG_Success_Load(handles);
%     set(handles.chanlocs_2,'String',int2str(x)); %Channels
%     set(handles.data_2,'String',int2str(y)); %Frames Epoch
%     set(handles.srate,'String',int2str(EEG.srate)); %Sample Rate
%     set(handles.EEG_min,'String',int2str(EEG.xmin)); %Sample Rate
%     set(handles.EEG_max,'String',int2str(EEG.xmax)); %Sample Rate
    
% Load and Update Drop-down boxes for methods
    % Markers
    try
        i=1;
        repeated = 0;
        type_events{1} = EEG.event(1).type;
        for a=1:length(EEG.event)
            for b=1:length(type_events)
                if strcmp(type_events(b), EEG.event(a).type)
                    repeated = 1;
                    break
                else repeated = 0; end
            end
            if repeated == 0
                i=i+1;
                type_events{i} = EEG.event(a).type;
            end
        end
        set(handles.Selected_marker_drop,'String',type_events);
    catch
        
    end
    % Channels 
    channel = get(handles.EEG_ch_ref_drop,'String');
    if length(channel) <= 4
        channels_list{1} = channel;
        n = EEG.nbchan;
        for i=2:n+1
            channels_list{i} = num2str(i-1);
            channel_list{i-1} = num2str(i-1);
            try 
                channels_list{i} = [channels_list{i} ': ' sprintf(EEG.chanlocs(1,i-1).labels)];
                channel_list{i-1} = [num2str(i-1)  ': ' sprintf(EEG.chanlocs(1,i-1).labels)];
            end
        end
        set(handles.EEG_ch_ref_drop,'String',channels_list);
        set(handles.EEG_personal_channel,'String',channel_list);
    end

catch
%     EEG_Fail_Load(handles);
    warndlg('Cannot read EEG Dataset. Make sure that an dataset is correctly loaded.','Data Set Info','modal');
end


%        ------------- End of Loading Interface -------------

% -------------------------------------------------------------------
% -------------- Internal Functions to refresh Interface ------------
% -------------------------------------------------------------------

% Choice of Artifact Detection Method
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function scan_method_SelectionChangeFcn(hObject, eventdata);
handles = guidata(hObject); 
global sync_type Peak_references
set(handles.cancel_btt,'String','Cancel');
switch get(eventdata.NewValue,'Tag')     % Get Tag of selected object
    case 'use_markers'
      set(handles.Next_1,'enable','off');
      %set(handles.Selected_marker_drop,'value','1');
      set(handles.Selected_marker_drop,'enable','on');
      set(handles.marker_per_onset,'Enable','On');
%       set(handles.marker_per_slice,'Enable','On');
      if sync_type == 2
         set(handles.axes3Panel,'visible','off');
      end
      sync_type = 1;              % Internal Variable for Use Markers
      set(handles.log_text,'String','Select the Marker form fMRI recording.');
      set(handles.Selected_marker_drop,'Enable','On');
      set(handles.TR_scan_txt,'Enable','Off');
      set(handles.EEG_ch_ref_txt,'Enable','Off');
      set(handles.EEG_ch_ref_drop,'Enable','Off');
      set(handles.fmri_TR,'Enable','Off');
      set(handles.gradient_trigger_txt,'Enable','Off');
      set(handles.gradient_trigger_drop,'Enable','Off');
      set(handles.Percentage_dropmenu,'Enable','Off');
      set(handles.gradient_trigger_value,'Enable','Off');
      set(handles.Detect_artifacts_btt,'Enable','Off');
      set(handles.preview_channel_btt,'Enable','Off');
      set(handles.Selected_marker_drop,'Value',1);
    case 'artifact_correction'
      set(handles.marker_per_onset,'Enable','Off');
      set(handles.marker_per_slice,'Enable','Off');
      set(handles.axes3Panel,'visible','off');
      set(handles.Next_1,'enable','off');
      sync_type = 2;                % Internal Variable for custom_sync
      set(handles.log_text,'String','Select the parameters and click "Read fMRI volumes onset".');
      set(handles.TR_scan_txt,'Enable','On');
      set(handles.fmri_TR,'Enable','On');
      set(handles.EEG_ch_ref_txt,'Enable','On');
      set(handles.EEG_ch_ref_drop,'Enable','On');
      set(handles.gradient_trigger_txt,'Enable','On');
      set(handles.gradient_trigger_drop,'Enable','On');
      set(handles.Percentage_dropmenu,'Enable','On');
      set(handles.gradient_trigger_value,'Enable','On');
      if get(handles.EEG_ch_ref_drop,'Value') > 1
          set(handles.preview_channel_btt,'Enable','On');
      end
      set(handles.Selected_marker_drop,'Enable','Off');
      set(handles.Detect_artifacts_btt,'Enable', 'On');
    otherwise
       % Code for when there is no match.
end
guidata(hObject, handles);


% --- Executes on button press in marker_per_onset.
function marker_per_onset_Callback(hObject, eventdata, handles)
      set(handles.marker_per_slice,'Value',0);
% --- Executes on button press in marker_per_slice.
function marker_per_slice_Callback(hObject, eventdata, handles)
      set(handles.marker_per_onset,'Value',0);

% Plot and Show Markers on Axes
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function plot_chan_markers(handles)
global EEG
% global sync_type
global Peak_references
global ch 
% global thres
set(handles.axes3Panel,'visible','on');
set(handles.axes3,'Visible','on');
% set(handles.Zoom_btt,'Visible','on');
% set(handles.DataCursor_btt,'Visible','on');
axes(handles.axes3);
hold off;
TR = Peak_references(2) - Peak_references(1);
start_point = fix(Peak_references(1) - TR/3);
end_point = fix(Peak_references(7) + TR);
plot(EEG.data(ch,start_point:end_point));
min_graph = min(EEG.data(ch,:));
max_graph = max(EEG.data(ch,:));
hold on;
plot(Peak_references(1:7)-start_point,0,'r+','linewidth',2);
% zoom off;
% pan off;
% datacursormode off;
pace = (end_point-start_point)/7;
x = [start_point:pace:end_point];
set(gca,'FontSize',7);
set(gca, 'XTick', [0 pace pace*2 pace*3 pace*4 pace*5 pace*6 pace*7]);
set(gca,'XTickLabel', x/EEG.srate*1000);
ylabel('EEG amplitude in [µV]:');
xlabel('Time in [ms]');
hold off;



function success_markers_detection(handles)
    % Buttons
%     set(handles.Detect_artifacts_btt,'Enable','On');
    set(handles.TR_txt,'Enable','On');
    set(handles.ch_txt,'Enable','On');
    set(handles.grad_txt,'Enable','On');
    set(handles.artifacts_txt,'Enable','On');
    set(handles.first_artifact_txt,'Enable','On');
    set(handles.last_artifact_txt,'Enable','On');
    % Markers Summary Panel
    set(handles.Next_1,'Enable','On');
%     set(handles.plot_chan_markers,'Enable','On');
    set(handles.log_text,'String','Markers have been found. Click "Accept" to proceed.');
function fail_markers_detection(handles)
    % Buttons
    set(handles.Next_1,'Enable','Off');
%     set(handles.plot_chan_markers,'Enable','Off');
    set(handles.log_text,'String','Markers not Found! Please review your parameters.');
    % Markers Summary Panel
    set(handles.TR_txt,'Enable','Off');
    set(handles.ch_txt,'Enable','Off');
    set(handles.grad_txt,'Enable','Off');
    set(handles.artifacts_txt,'Enable','Off');
    set(handles.first_artifact_txt,'Enable','Off');
    set(handles.last_artifact_txt,'Enable','Off');
    set(handles.axes3Panel,'visible','off');
    


    
%       ------------- End of Internal Functions -------------
       
% -------------------------------------------------------------------
% ------------- Evaluation of Markers Method Parameters -------------
% -------------------------------------------------------------------

% Selection of Marker from recording: Drop-Box
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Selected_marker_drop_Callback(hObject, eventdata, handles)
DetectArtifacts_Btt_Callback(hObject, eventdata, handles);

% Set TR for Manual detection
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function fmri_TR_Callback(hObject, eventdata, handles)
%Protejer o campo e verificar que é colocado um valor superior a 100ms

% Choice Gradient Trigger: Drop-Box
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function gradient_trigger_drop_Callback(hObject, eventdata, handles)
val = get(handles.gradient_trigger_drop,'Value');
switch val
    case 1 % Set Auto
        set(handles.gradient_trigger_value,'Visible','Off');
        set(handles.Percentage_dropmenu,'Visible','Off');
        set(handles.gradient_trigger_txt,'Value',0);
    case 2 % Set Percentage
        set(handles.gradient_trigger_value,'Visible','Off');
        set(handles.Percentage_dropmenu,'Visible','On');
        val = get(handles.Percentage_dropmenu,'Value');
        set(handles.gradient_trigger_txt,'Value',100-val);
    case 3 % Set Specify
        set(handles.Percentage_dropmenu,'Visible','Off');
        set(handles.gradient_trigger_value,'visible','On');
        val = str2num(get(handles.gradient_trigger_value,'String'));
        set(handles.gradient_trigger_txt,'Value',val);
    otherwise
end

% Percentage Gradient: Drop-Box
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Percentage_dropmenu_Callback(hObject, eventdata, handles)
val = get(handles.Percentage_dropmenu,'Value');
set(handles.gradient_trigger_txt,'Value',100-val);

% Specify Gradient Trigger: Drop-Box
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function gradient_trigger_value_Callback(hObject, eventdata, handles)
% val = str2num(get(handles.gradient_trigger_value,'String'));
% set(handles.gradient_trigger_txt,'Value',val);

% Select Channel: Drop-Box
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function EEG_ch_ref_drop_Callback(hObject, eventdata, handles)
global ch
ch = get(handles.EEG_ch_ref_drop,'Value');
if ch == 1
    set(handles.preview_channel_btt,'Enable','Off');
else 
      ch = ch - 1;
      set(handles.preview_channel_btt,'Enable','On');
end



%           ------------- End of Evaluation -------------

   
% -------------------------------------------------------------------
% -------------- Buttons of Markers Detection interface -------------
% -------------------------------------------------------------------

% Button Preview Gradient Channel 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function preview_channel_btt_Callback(hObject, eventdata, handles)
global EEG
global ch 
set(handles.axes3Panel,'visible','on');
set(handles.axes3,'Visible','on');
axes(handles.axes3);
total = length(EEG.data(ch,:));
starter = fix(total/2);
ender = fix(starter + total*0.025);
plot(diff(EEG.data(ch,starter:ender)));
pace = (ender-starter)/7;
x = [starter:pace:ender];
set(gca,'FontSize',7);
set(gca, 'XTick', [0 pace pace*2 pace*3 pace*4 pace*5 pace*6 pace*7]);
set(gca,'XTickLabel', x/EEG.srate*1000);
ylabel('Gradient of EEG data in [µV]:');
xlabel('Time in [ms]');
hold off;

% Button to show Info about Markers 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function info_markers_btt_Callback(hObject, eventdata, handles)
set(handles.axes3Panel,'visible','on');
set(handles.axes3,'Visible','on');
axes(handles.axes3);
try
    info_image = imread('Markers_info.jpg');
    imshow(info_image);
catch
    set(handles.axes3Panel,'visible','off');
    errordlg2('Could not find "Markers_info.jpg" file. Info figure was not loaded.', 'Error loading file', 'modal');
end

set(gca,'FontSize',7);
% zoom off;
datacursormode off;
hold off;


% Button to Execute Detection of Markers according to Method 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function DetectArtifacts_Btt_Callback(hObject, eventdata, handles)
global EEG
global sync_type
global Peak_references
global ch
global thres
set(handles.markers_detection_summary_panel,'visible','on');
set(handles.log_text,'String','Calculating time references for fMRI volumes...');
pause(0.001);
Peak_references=[];
try
    if sync_type == 1 % Use Markers Method
        Markerselected = get(handles.Selected_marker_drop,'Value');
        MarkerString = get(handles.Selected_marker_drop,'String');
        Marker = MarkerString(Markerselected);    
        Peak_references = UseMarker(EEG, Marker);
		if length(Peak_references) < 2
        bad_message = ['Cannot use selected Marker. It has not enough references.', 10,...
            'Tips:',10,...
            '      a) Choose a different Marker;', 10,...
            '                  or', 10,...
            '      b) Choose Manual detection;',10,' '];
        
           fail_markers_detection(handles);
        else
            command = ['[ Peak_references ] = UseMarker( EEG, ''' cell2mat(Marker) ''' );'];
            EEG.history = [ EEG.history 10 command ];
            if ch > 0
                % Use last determined channel
            else
                ch = DetectChannel(EEG); 
                command = ['[channel] = DetectChannel( EEG );'];
                EEG.history = [ EEG.history 10 command ];
            end
        end
        
        
    else % User Artifact Detection Method
        bad_message = ['Markers not Found! Please review your parameters.', 10,...
            'Tips:',10,...
            '     a) Choose a channel and use "Preview" to estimate you parameters;', 10,...
            '     b) Try to introduce an approximate TR (on continuous recording you need to be more accurated);', 10,...
            '     c) Make sure all artifacts are complete;',10,' '];
%         Take care of imputs
%         TR imput
        fMRI_TR = str2num(get(handles.fmri_TR,'String'));
        if isempty(fMRI_TR)
            fMRI_TR = 0;
        end
        ch = get(handles.EEG_ch_ref_drop,'Value');
        if ch == 1 %AutoChannel
            channel = DetectChannel(EEG);
            command = ['[ channel ] = DetectChannel(EEG);'];
            EEG.history = [ EEG.history 10 command ];
        else
            channel =  ch - 1;
        end
        % Trigger gradient
        val = get(handles.gradient_trigger_drop,'Value');
        if val == 1
            grad_trigger = 0;
            percent_trigger = 0; % Auto
        else
            if val == 2 % Percentage Trigger
                grad_trigger = 0;
                percent_trigger = get(handles.gradient_trigger_txt,'Value');
            else % User specify Trigger
                grad_trigger = str2num(get(handles.gradient_trigger_value,'String'));
                percent_trigger = 0;
            end
        end
    
        % Execute artifacts volume detection
        set(handles.Detect_artifacts_btt,'Enable','Off');
        [Peak_references, thres, real_TR, ch] = DetectMarkers(EEG, fMRI_TR, grad_trigger, percent_trigger, channel);
        
        command = ['[Peak_references, thres, real_TR, ch] = DetectMarkers( EEG, ', num2str(fMRI_TR), ', ', num2str(grad_trigger), ', ', num2str(percent_trigger), ', channel );'];
        EEG.history = [ EEG.history 10 command ];
        set(handles.Detect_artifacts_btt,'enable','on');
    end
    set(handles.EEG_personal_channel,'value',ch);
    guidata(hObject, handles);
    plot_chan_markers(handles);
    set(handles.axes3Panel,'Visible','On');
    success_markers_detection(handles);
        
    % Update Markers Summary panel
    % Calculus
    tot_peaks = length(Peak_references);
    real_TR = (Peak_references(2)-Peak_references(1))/EEG.srate*1000;
    % Text boxes
    set(handles.TR_txt,'String',num2str(round(real_TR)));
    set(handles.ch_txt,'String',num2str(ch));
    set(handles.artifacts_txt,'String',num2str(tot_peaks));
    set(handles.first_artifact_txt,'String',num2str(round(Peak_references(1)/EEG.srate*1000)));
    set(handles.last_artifact_txt,'String',num2str(round(Peak_references(tot_peaks)/EEG.srate*1000)));
    if sync_type == 1 % Use Markers Method
        set(handles.grad_txt,'String','-');
    else % User Markers Detection Method
        set(handles.grad_txt,'String',num2str(round(thres)));
    end
catch
    fail_markers_detection(handles);
    warndlg2(bad_message,'Markers Detection');
    if sync_type == 1
    else
        set(handles.Detect_artifacts_btt,'enable','on');
    end
    info_markers_btt_Callback(hObject, eventdata, handles)
end
%     zoom off;
    datacursormode off;


%             ------------- End of Buttons -------------

% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% |||||||||||| Goes back to Markers Detection Interface |||||||||||||
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
function Back_1_btt_Callback(hObject, eventdata, handles)
global sync_type
zoom = 0;
% Hide Interface of Artifacts
        %Buttons
        set(handles.Back_1_btt,'Enable','Off'); 
        set(handles.Next_2_btt,'Visible','Off'); 
        %Interface
        set(handles.artifact_range_Panel,'Visible','Off');
        set(handles.Artifacts_Summary_Panel,'visible','Off');
        set(handles.markers_detection_summary_panel,'Visible','Off');
        set(handles.axes3Panel,'Visible','Off'); 
        set(handles.EEG_personal_channel,'Visible','Off');
        set(handles.EEG_personal_channel_txt,'Visible','Off');
% Show Interface of Markers
        set(handles.TopText,'string','Step 1/6 - fMRI Volume onsets detection');
        set(handles.log_text,'String','Markers have been found. Click "Accept" to proceed.');
        %buttons
        set(handles.Next_1,'Visible','On');
        %Panels
        set(handles.scan_method,'Visible','On');
        pause(0.01);
        set(handles.markers_detection_summary_panel,'visible','On');
        pause(0.1);
        plot_chan_markers(handles);
        set(handles.axes3Panel,'Visible','On');        
        
        
% ###################################################################
% ################ Interface for Artifacts Settings #################
% ###################################################################
function Next_1_Callback(hObject, eventdata, handles)
global Peak_references
% Hide Markers Interface
        set(handles.scan_method,'Visible','Off');
        set(handles.markers_detection_summary_panel,'visible','Off');
        set(handles.axes3Panel,'Visible','Off'); 
        % buttons
        set(handles.Next_1,'Visible','Off');
%         set(handles.Detect_artifacts_btt,'visible','Off');
% Show Artifacts Interface
        % Interface
        set(handles.TopText,'string','Step 2/6 - Artifact Duration Parameters');        
        set(handles.log_text,'String','Set the Artifact Onset and Offset and click "Accept" to proceed.');
        set(handles.artifact_range_Panel,'Visible','On');
        pause(0.1);        
        set(handles.Artifacts_Summary_Panel,'visible','on');
        pause(0.01);
        % Graphic
        UpdateArtifact(handles);
        refreshArtifactPlot(handles);
        set(handles.EEG_personal_channel,'Visible','on');
        set(handles.EEG_personal_channel_txt,'Visible','on');
        % Buttons
        set(handles.Back_1_btt,'Enable', 'On');
        set(handles.Next_2_btt,'Visible','On');
%         ------------- End of Loading Interface -------------



% -------------------------------------------------------------------
% ------------------ Evaluate Onset & Offset values -----------------
% -------------------------------------------------------------------
% Check Onset values from user imput
function onset_value_box_Callback(hObject, eventdata, handles)
UpdateArtifact(handles);
refreshArtifactPlot(handles);
% Check Offset values from user imput
function offset_value_box_Callback(hObject, eventdata, handles)
UpdateArtifact(handles);
refreshArtifactPlot(handles);



% -------------------------------------------------------------------
% ------------------ Buttons of Artifacts Interface -----------------
% -------------------------------------------------------------------


% Chooice of continuous recording
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function continuous_recording_Callback(hObject, eventdata, handles)
global EEG Peak_references
global onset_value offset_value
TR = Peak_references(2)-Peak_references(1);
onset_value = 0;
offset_value = TR;
set(handles.onset_value_box,'String',num2str(round(onset_value/EEG.srate*1000)));
set(handles.offset_value_box,'String',num2str(round(offset_value/EEG.srate*1000)));
set(handles.Next_2_btt,'Enable','On');
if get(handles.continuous_recording,'Value') == 0
    set(handles.continuous_recording,'Value',1);
end
refreshArtifactSummary(handles);
refreshArtifactPlot(handles);
set(handles.especific_onset_offset,'Value',0);
set(handles.onset_value_box,'Enable','Off');
set(handles.Plus_onset,'Enable','Off');
set(handles.Minus_onset,'Enable','Off');
set(handles.UseDataCursor_Onset_btt,'Enable','Off');
set(handles.offset_value_box,'Enable','Off');
set(handles.Plus_offset,'Enable','Off');
set(handles.Minus_offset,'Enable','Off');
set(handles.UseDataCursor_Offset_btt,'Enable','Off');
set(handles.zoom_onset_btt,'Enable','Off');
set(handles.zoom_offset_btt,'Enable','Off');
set(handles.ShowArtifact_btt,'Enable','Off');


% Chooice of specific onset & offset values
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function especific_onset_offset_Callback(hObject, eventdata, handles)
set(handles.Next_2_btt,'Enable','On');
if get(handles.especific_onset_offset,'Value') == 0
    set(handles.especific_onset_offset,'Value',1);
end
set(handles.continuous_recording,'Value',0);
set(handles.onset_value_box,'Enable','On');
set(handles.Plus_onset,'Enable','On');
set(handles.Minus_onset,'Enable','On');
set(handles.UseDataCursor_Onset_btt,'Enable','On');
set(handles.offset_value_box,'Enable','On');
set(handles.Plus_offset,'Enable','On');
set(handles.Minus_offset,'Enable','On');
set(handles.UseDataCursor_Offset_btt,'Enable','On');
set(handles.zoom_onset_btt,'Enable','On');
set(handles.zoom_offset_btt,'Enable','On');
set(handles.ShowArtifact_btt,'Enable','On');




% Onset Plus/Minus: Buttons
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Plus_onset_Callback(hObject, eventdata, handles)
    global onset_value EEG offset_value
    global zoom
    actual = (str2num(get(handles.onset_value_box,'String')))*EEG.srate/1000;
    if isempty(actual)
        onset_value = 0;
    end
    onset_value = onset_value + 1*(EEG.srate/1000);
    set(handles.onset_value_box,'String',num2str(round(onset_value/EEG.srate*1000)));
    if onset_value > offset_value
        offset_value = offset_value + 1*(EEG.srate/1000);
        set(handles.offset_value_box,'String',num2str(round(offset_value/EEG.srate*1000)));
    end
    if zoom==1
        zoom_onset_btt_Callback(hObject, eventdata, handles);
    else
        refreshArtifactPlot(handles);
    end
    refreshArtifactSummary(handles);
    
    % --- Executes on button press in minusOnset.
function Minus_onset_Callback(hObject, eventdata, handles)
    global onset_value EEG offset_value Peak_references
    global zoom
    TR = Peak_references(2)-Peak_references(1);
    actual = (str2num(get(handles.onset_value_box,'String')))*EEG.srate/1000;
    if isempty(actual)
        onset_value = 0;
    end
    onset_value = actual - 1*(EEG.srate/1000);
    if (offset_value - onset_value) > TR
        offset_value = offset_value-1*(EEG.srate/1000);
        set(handles.offset_value_box,'String',num2str(round(offset_value/EEG.srate*1000)));
    end
    set(handles.onset_value_box,'String',num2str(round(onset_value/EEG.srate*1000)));
    if zoom==1
        zoom_onset_btt_Callback(hObject, eventdata, handles);
    else
        refreshArtifactPlot(handles);
    end
    refreshArtifactSummary(handles);

    
    
% Offset Plus/Minus: Buttons
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Plus_offset_Callback(hObject, eventdata, handles)
    global onset_value EEG offset_value Peak_references
    global zoom
    TR = Peak_references(2)-Peak_references(1);
    actual = (str2num(get(handles.offset_value_box,'String')))*EEG.srate/1000;
    if isempty(actual)
        offset_value = 0;
    end
    offset_value = actual + 1*(EEG.srate/1000);
    if (offset_value - onset_value) > TR
        onset_value = onset_value+1*(EEG.srate/1000);
        set(handles.onset_value_box,'String',num2str(round(onset_value/EEG.srate*1000)));
    end
    set(handles.offset_value_box,'String',num2str(round(offset_value/EEG.srate*1000)));
    if zoom ==1
        zoom_offset_btt_Callback(hObject, eventdata, handles);
    else
        refreshArtifactPlot(handles);
    end
    refreshArtifactSummary(handles);
    
    % --- Executes on button press in Minus_offset.
function Minus_offset_Callback(hObject, eventdata, handles)
    global offset_value EEG onset_value
    global zoom
    actual = (str2num(get(handles.offset_value_box,'String')))*EEG.srate/1000;
    if isempty(actual)
        offset_value = 0;
    end
    if offset_value <= onset_value
        onset_value = onset_value - 1*(EEG.srate/1000);
        set(handles.onset_value_box,'String',num2str(round(onset_value/EEG.srate*1000)));
    end
    offset_value = actual - 1*(EEG.srate/1000);
    set(handles.offset_value_box,'String',num2str(round(offset_value/EEG.srate*1000)));
    if zoom == 1
        zoom_offset_btt_Callback(hObject, eventdata, handles);
    else
        refreshArtifactPlot(handles);
    end
    refreshArtifactSummary(handles);

    
    
% Use Onset/Offset Data Cursor: Button
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function UseDataCursor_Onset_btt_Callback(hObject, eventdata, handles)
    global Peak_references EEG
    global onset_value offset_value start_point
	dcm_obj = datacursormode;
    initref = Peak_references(2)-start_point;
    coordinates_info = getCursorInfo(dcm_obj);
    if isempty(coordinates_info)
        datacursormode on;
        set(handles.UseDataCursor_Offset_btt,'Enable','Off');
        set(handles.UseDataCursor_Onset_btt,'String','Done');
        set(handles.ShowArtifact_btt,'string','Cancel');
        set(handles.Next_2_btt,'Enable','off');
    else
        TR = Peak_references(2)-Peak_references(1); 
        try
            x = coordinates_info.Position(1);
            if (x-initref) >= offset_value && abs(offset_value) > abs(onset_value )
                onset_value = round(x-initref-TR);
            else
                onset_value = round(x-initref);
            end
            set(handles.onset_value_box,'String',num2str(round(onset_value/EEG.srate*1000)));
        catch
            errordlg2('A Point must be selected. Tip: Use Zoom tool to accurate selected point and then button "Use Selected Point".');
        end
        ShowArtifact_btt_Callback(hObject, eventdata, handles);
        datacursormode off;
        set(handles.UseDataCursor_Onset_btt,'String','Select Point form graph');
        set(handles.UseDataCursor_Offset_btt,'Enable','On');
        set(handles.Next_2_btt,'Enable','on');
    end
    
function UseDataCursor_Offset_btt_Callback(hObject, eventdata, handles)
global Peak_references EEG
global onset_value offset_value start_point
dcm_obj = datacursormode;
initref = Peak_references(2)-start_point;
coordinates_info = getCursorInfo(dcm_obj);
if isempty(coordinates_info)
    datacursormode on;
    set(handles.UseDataCursor_Onset_btt,'Enable','Off');
    set(handles.UseDataCursor_Offset_btt,'String','Done');
    set(handles.ShowArtifact_btt,'string','Cancel');
    set(handles.Next_2_btt,'Enable','off');
else
    try
        TR = Peak_references(2)-Peak_references(1);
        x = coordinates_info.Position(1);
        if (x-initref) <= onset_value
            offset_value = round(x-initref+TR);
        else
            offset_value = round(x-initref);
        end
        set(handles.offset_value_box,'String',num2str(round(offset_value/EEG.srate*1000)));
    catch
        errordlg2('A Point must be selected. Tip: Use Zoom tool to accurate selected point and then button "Use Selected Point".');
    end
    ShowArtifact_btt_Callback(hObject, eventdata, handles);
    datacursormode off;
    set(handles.UseDataCursor_Offset_btt,'String','Select Point form graph');
    set(handles.UseDataCursor_Onset_btt,'Enable','On');
    set(handles.Next_2_btt,'Enable','on');
end



% Function to be called when onset and offset are changed
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function UpdateArtifact(handles)
global EEG Peak_references
global ch 
global onset_value offset_value
% tr = Peak_references(3)-Peak_references(2);
onset_value = (str2num(get(handles.onset_value_box,'string'))*EEG.srate/1000); %Protect data format
offset_value = (str2num(get(handles.offset_value_box,'string'))*EEG.srate/1000); %Protect data format
if isempty(onset_value)
    onset_value = 0;
    set(handles.onset_Start_txt,'value',0);
end
if isempty(offset_value)
    offset_value = 0;
    set(handles.offset_Start_txt,'value',0);
end
set(handles.onset_Start_txt,'value',round(onset_value/EEG.srate*1000)); % Object with onset_value to be used by Apply
set(handles.offset_Start_txt,'value',round(offset_value/EEG.srate*1000)); % Object with offset_value to be used by Apply
% set(handles.EEG_Information,'Visible','On');
refreshArtifactSummary(handles);
% set(handles.Zoom_btt,'enable','on');


% Function to refresh buttons and plot
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function ShowArtifact_btt_Callback(hObject, eventdata, handles)
UpdateArtifact(handles);
refreshArtifactPlot(handles);
command = get(handles.ShowArtifact_btt,'String');
if length(command) < 10
    cancel_datacursormode(handles);
end


% Function to change the current channel view
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function EEG_personal_channel_Callback(hObject, eventdata, handles)
global ch
ch = get(handles.EEG_personal_channel,'Value');
UpdateArtifact(handles);
if get(handles.cancel_btt,'string') == 'Finish'
    plot_result(handles);
    axes(handles.axes3);
else
    refreshArtifactPlot(handles);
end



%              ------------- End of Buttons -------------

% -------------------------------------------------------------------
% -------------------- Artifact Summary and Ploting -----------------
% -------------------------------------------------------------------

% Update Artifact Summary panel
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function refreshArtifactSummary(handles)
global EEG
global Peak_references
global ch 
global onset_value offset_value
global start_point
duration = offset_value - onset_value;
TR = Peak_references(3)-Peak_references(2);
silent_gap = round((TR - duration)/EEG.srate*1000);
set(handles.repet_rate_tr_txt,'String',num2str(round(TR/EEG.srate*1000)));
set(handles.artifact_onset_txt,'String',num2str(round(onset_value/EEG.srate*1000)));
set(handles.artifact_offset_txt,'String',num2str(round(offset_value/EEG.srate*1000)));
% silent_gap = (round(silent_gap/EEG.srate*1000));
set(handles.artifact_silent_gap_txt,'String',num2str(silent_gap));
if silent_gap < 0
    set(handles.artifact_silent_gap_txt,'ForegroundColor','Red');
else
    set(handles.artifact_silent_gap_txt,'ForegroundColor','Black');
end
set(handles.artifact_duration_txt,'String',num2str(round(duration/EEG.srate*1000)));
set(handles.artifact_average_power_txt,'String','-');

% Plot Full Artifact
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function refreshArtifactPlot(handles)
global EEG
global Peak_references
global ch 
global onset_value offset_value
global start_point
global zoom
zoom = 0;
set(handles.axes3Panel,'visible','on');
axes(handles.axes3);
hold off;
TR = Peak_references(3) - Peak_references(2);
start_point = ceil(Peak_references(2) - TR/6);
end_point = ceil(Peak_references(3) + TR/10);
plot(EEG.data(ch,start_point:end_point));
hold on;
artifact_marker1 = Peak_references(2)-start_point;
artifact_marker2 = Peak_references(3)-start_point; 
artifact_begin = artifact_marker1 + onset_value;
artifact_end = artifact_marker1 + offset_value;
min_graph = min(EEG.data(ch,start_point:end_point))-100;
max_graph = max(EEG.data(ch,start_point:end_point))+100;
% if abs(max_graph) > abs(min_graph)
%     min_graph = - max_graph;
% else
%     max_graph = - min_graph;
% end
% xlim = get(gca,'XLim',[0 (end_point-start_point)]);
ylim = [min_graph max_graph];
set(gca,'YLim', [min_graph max_graph]);
plot(artifact_marker1,0,[artifact_marker1,artifact_marker1],[ylim(1),ylim(2)],'+:k','linewidth',2.5); % 1st marker
dat = plot(artifact_marker2,0,[artifact_marker2,artifact_marker2],[ylim(1),ylim(2)],'+:k','linewidth',2.5); % 2nd marker
init_leg = plot(artifact_begin,0,[artifact_begin,artifact_begin],[ylim(1),ylim(2)],'>:','linewidth',2); % principal start
if (Peak_references(3)+onset_value) <= end_point
    plot(artifact_begin+TR,0,[artifact_begin+TR,artifact_begin+TR],[ylim(1),ylim(2)],'>:'); % secondary start
end
end_leg = plot(artifact_end,0,[artifact_end,artifact_end],[ylim(1),ylim(2)],'<:r','linewidth',2);
previous_ending = (Peak_references(1)+offset_value)-start_point;
if (Peak_references(1)+offset_value) >= start_point
    plot(previous_ending ,0,[previous_ending ,previous_ending ],[ylim(1),ylim(2)],'<:r'); % secondary end
end
durat = plot([artifact_begin,artifact_end],[ylim(1)*0.9,ylim(1)*0.9],'m','linewidth',1.3);
plot([artifact_begin,artifact_end],[ylim(2)*0.9,ylim(2)*0.9],'m','linewidth',1.3);
legend([dat(1),dat(2),init_leg(2),end_leg(2), durat], 'Channel data','Markers','Artifact Start','Artifact End','Artifact duration','Location', 'North');
a = -(Peak_references(2)-start_point);
b = end_point-start_point+a;
pace = (end_point-start_point)/7;
x=[a 0 b];
set(gca,'FontSize',7);
set(gca, 'XTick', [0 -a b-a]);
set(gca,'XTickLabel', x/EEG.srate*1000);
ylabel('Threshold in [µV]:');
xlabel('Time in [ms]');
hold off;

function cancel_datacursormode(handles)
datacursormode off;
set(handles.Next_2_btt,'Enable','on');
set(handles.ShowArtifact_btt,'string','Show Artifact');
set(handles.UseDataCursor_Onset_btt,'String','Select Point form graph');
set(handles.UseDataCursor_Onset_btt,'Enable','On');
set(handles.UseDataCursor_Offset_btt,'String','Select Point form graph');
set(handles.UseDataCursor_Offset_btt,'Enable','On');

% Plot zoom_onset
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function zoom_onset_btt_Callback(hObject, eventdata, handles)
global EEG
global Peak_references
global ch 
global onset_value offset_value
global start_point
global zoom
zoom =1;
TR = Peak_references(2) - Peak_references(1);
set(handles.axes3Panel,'visible','on');
axes(handles.axes3);
hold off;
start_point = ceil(Peak_references(2) + onset_value - TR/10);%(EEG.srate/300));
end_point = ceil(Peak_references(2) + onset_value + TR/10);%/(EEG.srate/300));
plot(EEG.data(ch,start_point:end_point));
hold on;
artifact_marker1 = Peak_references(2)-start_point; 
artifact_begin = artifact_marker1 + onset_value;
min_graph = min(EEG.data(ch,fix(Peak_references(1)):fix(Peak_references(2))))-100;
max_graph = max(EEG.data(ch,fix(Peak_references(1)):fix(Peak_references(2))))+100;
% if (max_graph - min_graph) > 0
%     min_graph = - max_graph;
% else
%     max_graph = - min_graph;
% end
ylim = [min_graph max_graph];
set(gca,'YLim', [min_graph max_graph]);
plot(artifact_begin,0,[artifact_begin,artifact_begin],[ylim(1),ylim(2)],'>:','linewidth',2);
%Plot Markers if they appear
if Peak_references(2) > start_point && Peak_references(2) < end_point 
    plot(artifact_marker1,0,[artifact_marker1,artifact_marker1],[ylim(1),ylim(2)],'+:k');
end
%Plot Offsets if they appear
offset1 = (Peak_references(1)+offset_value);
if offset1 > start_point && offset1 < end_point
    previous_offset = offset1-start_point;
    plot(previous_offset,0,[previous_offset,previous_offset],[ylim(1),ylim(2)],'<:r');
end
offset2 = (Peak_references(2)+offset_value);
if offset2 > start_point && offset2 < end_point
    previous_offset = offset2-start_point;
    plot(previous_offset,0,[previous_offset,previous_offset],[ylim(1),ylim(2)],'<:r','linewidth',2);
end
a = -(Peak_references(2)-start_point);
b = end_point-start_point+a;
pace = (end_point-start_point)/7;
x=[a 0 b];
set(gca,'FontSize',7);
set(gca, 'XTick', []);
set(gca,'XTickLabel', x/EEG.srate*1000);
ylabel('Threshold in [µV]:');
xlabel('Time in [ms]');


hold off;
refreshArtifactSummary(handles);

% Plot zoom_offset
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function zoom_offset_btt_Callback(hObject, eventdata, handles)
global EEG
global Peak_references
global ch 
global onset_value offset_value
global start_point
global zoom
zoom =1;
TR = Peak_references(2) - Peak_references(1);
set(handles.axes3Panel,'visible','on');
axes(handles.axes3);
hold off;
start_point = ceil(Peak_references(2) + offset_value - TR/10);%(EEG.srate/300));
end_point = ceil(Peak_references(2) + offset_value + TR/10);%(EEG.srate/300));
plot(EEG.data(ch,start_point:end_point));
hold on;
artifact_marker1 = Peak_references(2)-start_point;
artifact_marker2 = Peak_references(3)-start_point;
artifact_end = artifact_marker1 + offset_value;
min_graph = min(EEG.data(ch,fix(Peak_references(1)):fix(Peak_references(2))))-100;
max_graph = max(EEG.data(ch,fix(Peak_references(1)):fix(Peak_references(2))))+100;
% if (max_graph - min_graph) > 0
%     min_graph = - max_graph;
% else
%     max_graph = - min_graph;
% end
ylim = [min_graph max_graph];
set(gca,'YLim', [min_graph max_graph]);
plot(artifact_end,0,[artifact_end,artifact_end],[ylim(1),ylim(2)],'<:r','linewidth',2);
onset2 = (Peak_references(2)+onset_value);
if onset2 > start_point && onset2 < end_point
    previous_onset = onset2-start_point;
    plot(previous_onset,0,[previous_onset,previous_onset],[ylim(1),ylim(2)],'>:','linewidth',2);
end
onset3 = (Peak_references(3)+onset_value);
if onset3 > start_point && onset3 < end_point
    next_onset = onset3-start_point;
    plot(next_onset,0,[next_onset,next_onset],[ylim(1),ylim(2)],'>:');
end
%Plot Markers if they appear
if Peak_references(2) > start_point && Peak_references(2) < end_point 
    plot(artifact_marker1,0,[artifact_marker1,artifact_marker1],[ylim(1),ylim(2)],'+:k');
end
if Peak_references(3) > start_point && Peak_references(3) < end_point 
    plot(artifact_marker2,0,[artifact_marker2,artifact_marker2],[ylim(1),ylim(2)],'+:k');
end
a = -(Peak_references(2)-start_point);
b = end_point-start_point+a;
pace = (end_point-start_point)/7;
x=[a 0 b];
set(gca,'FontSize',7);
set(gca, 'XTick', []);
set(gca,'XTickLabel', x/EEG.srate*1000);
ylabel('Threshold in [µV]:');
xlabel('Time in [ms]');
hold off;
refreshArtifactSummary(handles);


%       ------------- End of Refresh and Plots -------------


% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% ||||||||||| Goes back to Artifact Parameters Interface ||||||||||||
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
function Back_2_btt_Callback(hObject, eventdata, handles)
global zoom
zoom =0;
% Hide Baseline Interface
    % Buttons
    set(handles.Back_2_btt,'Visible','Off');
    set(handles.Next_3_btt,'Visible','Off');
    % Interface
    set(handles.Baseline_panel,'Visible','off');
% Show Artifacts Interface
    set(handles.TopText,'string','Step 2/6 - Artifact Duration Parameters');        
    set(handles.log_text,'String','Set the Artifact Onset and Offset and click "Accept" to proceed.');       
    set(handles.artifact_range_Panel,'Visible','On');
    pause(0.1);        
    set(handles.Artifacts_Summary_Panel,'visible','on');
    pause(0.01);
    pause(0.01);
    % Buttons
    set(handles.Back_1_btt,'Visible', 'On');
    set(handles.Next_2_btt,'Visible','On');
    % Graphic
    refreshArtifactPlot(handles);


    


% ###################################################################
% ################## Baseline Correction Interface ##################
% ###################################################################
function Next_2_btt_Callback(hObject, eventdata, handles)
global EEG
global Peak_references
global onset_value offset_value
global cmatrix_methodtype weighting_matrix
TR = Peak_references(2)-Peak_references(1);
duration = offset_value - onset_value;
silent_gap = (TR - duration)/EEG.srate*1000;
silent_gap = (round(silent_gap/EEG.srate*1000));
if (silent_gap) < 0
    warndlg2(['The Artifact duration is bigger then the Repetition Rate [TR]. This generates a negative Silent Gap. Please review you parameters.',10,...
        'Tips:', 10,...
        '    a) Check if you are typing the number for Start and End of Artifact volume location correctly;',10,...
        '    b) Check if the imputs are in milliseconds;', 10,...
        '    c) The imputs values are relative to the first marker, so please consider positive values for "after the marker" and negative values for "before marker";',10,...
        '    d) Use the dropbox (on top of the graphic) to view the markers on different channels;',10,...
        '    e) Try to go to previouse step and redifine the Markers references;',10,' '],'Artifact parameters');
else
    command = ['Artifact_onset = ', num2str(onset_value),'; ' ,'Artifact_offset = ', num2str(offset_value),';'];
    EEG.history = [ EEG.history 10 command ];
    zoom =0;
% Hide Artifact Interface
    set(handles.artifact_range_Panel,'Visible','Off');
    set(handles.Artifacts_Summary_Panel,'visible','Off');
    set(handles.axes3Panel,'Visible','Off');        
    %buttons
    set(handles.Back_1_btt,'Visible','Off');
    set(handles.Next_2_btt,'Visible','Off');
% Show Baseline Correction Interface
    % Buttons
    set(handles.Next_3_btt,'Visible','On');
    set(handles.Back_2_btt,'Visible','on');
    % Interface
    set(handles.TopText,'string','Step 3/6 - Baseline Correction');
    set(handles.log_text,'String','Please choose the baseline correction parameters and click "Accept" to proceed.');
    set(handles.Baseline_panel,'Visible','on');
    Baseline_panel_SelectionChangeFcn(hObject, eventdata, handles);
end
%         ------------- End of Loading Interface -------------



% Baseline Methods: variable "baseline_method"
% 0 - No method
% 1 - Based on value
% 2 - Average of precedent silent gap
% 3 - Average of time interval
        
% --------------------------------------------------------------------
function Baseline_panel_SelectionChangeFcn(hObject, eventdata, handles)
global baseline_method Peak_references onset_value offset_value
handles = guidata(hObject);
try
    switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'baseline_noChoice'
        set(handles.Next_3_btt,'Enable','On');
        baseline_method = 0;
        % Disable Baseline_Time
        set(allchild(handles.BaselineT_Shifting_options_panel),'enable','off');
        set(allchild(handles.BaselineT_panel),'enable','off');
        
    case 'baselineT'
        set(handles.Next_3_btt,'Enable','On');
        set(allchild(handles.BaselineT_panel),'enable','on');
        if baseline_method == 0
            baseline_method = get(handles.baselineT_especific_value,'value');
        end
        if baseline_method == 1
            baselineT_especific_value_Callback(hObject, eventdata, handles);
        elseif baseline_method == 2
            baselineT_precedent_silentgap_Callback(hObject, eventdata, handles);
        else
            BaselineT_interval_avg_Callback(hObject, eventdata, handles);
        end
        set(allchild(handles.BaselineT_Shifting_options_panel),'enable','on');
    end
catch
%    baseline_method = 0;
    if baseline_method > 0
    else
        set(allchild(handles.BaselineT_Shifting_options_panel),'enable','off');
        set(allchild(handles.BaselineT_panel),'enable','off');
    end
end
    
    if get(handles.baselineT,'value') == 1
        TR = Peak_references(2)-Peak_references(1);
        duration = offset_value - onset_value;
        if (abs(duration) - TR) == 0
            set(handles.baselineT_precedent_silentgap,'Enable','off');
            set(handles.baselineT_especific_value,'Enable','on');
            if get(handles.baselineT_precedent_silentgap,'value') == 1
                baseline_method = 1;
                set(handles.baselineT_especific_value,'value',1);
            end
        else
            set(handles.baselineT_especific_value,'Enable','off');
            set(handles.baselineT_precedent_silentgap,'Enable','on');
            if get(handles.baselineT_especific_value,'value') == 1
                baseline_method = 2;
                set(handles.baselineT_precedent_silentgap,'value',1);
            end
        end
    end

    
% Check imputs for method 3 (Interval range)
% --------------------------------------------------------------------
% From
function start_baseline_ref_Callback(hObject, eventdata, handles)
number_to_test = get(handles.start_baseline_ref,'string');
number_to_test = str2num(number_to_test);
if isempty(number_to_test)
    set(handles.start_baseline_ref,'String','0');
end
% To
function end_baseline_ref_Callback(hObject, eventdata, handles)
number_to_test = get(handles.end_baseline_ref,'string');
number_to_test = str2num(number_to_test);
if isempty(number_to_test)
    set(handles.end_baseline_ref,'String','0');
end



% Change interface routines    
% --------------------------------------------------------------------
% BaselineT_especific_value.
function baselineT_especific_value_Callback(hObject, eventdata, handles)
global baseline_method
baseline_method = 1;
set(handles.baselineT_especific_value,'Value',1);
set(handles.start_baseline_btt,'Enable', 'Off');
set(handles.start_baseline_ref,'Enable', 'Off');
set(handles.end_baseline_btt,'Enable', 'Off');
set(handles.end_baseline_ref,'Enable', 'Off');
% BaselineT_precedent_silentgap.
function baselineT_precedent_silentgap_Callback(hObject, eventdata, handles)
global baseline_method
baseline_method = 2;
set(handles.baselineT_precedent_silentgap,'Value',1);
set(handles.start_baseline_btt,'Enable', 'Off');
set(handles.start_baseline_ref,'Enable', 'Off');
set(handles.end_baseline_btt,'Enable', 'Off');
set(handles.end_baseline_ref,'Enable', 'Off');
% BaselineT_interval_avg.
function BaselineT_interval_avg_Callback(hObject, eventdata, handles)
global baseline_method
baseline_method = 3;
set(handles.BaselineT_interval_avg,'Value',1);
set(handles.start_baseline_btt,'Enable', 'Inactive');
set(handles.start_baseline_ref,'Enable', 'On');
set(handles.end_baseline_btt,'Enable', 'Inactive');
set(handles.end_baseline_ref,'Enable', 'On');
amplitude_start = get(handles.start_baseline_ref,'String');
amplitude_end = get(handles.end_baseline_ref,'String');
amplitude = str2num(amplitude_start) - str2num(amplitude_end);
if isempty(amplitude)
    amplitude = 'Imput missing';
else
end




% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% ||||||||||| Goes back to Baseline Correction Interface ||||||||||||
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
function Back_3_btt_Callback(hObject, eventdata, handles)
% Hide Correction Matrix Interface
    % Interface
    set(handles.methodType_buttongroup,'Visible','Off');
    set(handles.Weighting_matrix_vizualiz,'Visible','Off');      
    % Buttons
    set(handles.Back_3_btt,'Visible','Off');
    set(handles.Next_4_btt,'Visible','Off');
    set(handles.Reset_1,'Visible','Off');
    set(handles.Calculate,'Visible','Off');
% Show Baseline Correction Interface
    % Buttons
    set(handles.Back_2_btt,'Visible','On');
    set(handles.Next_3_btt,'Visible','On');
    % Interface
    set(handles.TopText,'String','Step 3/6 - Baseline Correction');
    set(handles.log_text,'String','Please choose the baseline correction parameters and click "Accept" to proceed.');
    set(handles.Baseline_panel,'Visible','On');


        
% ###################################################################
% ################## Weighting Matrix Correction ####################
% ###################################################################
function Next_3_btt_Callback(hObject, eventdata, handles)
global cmatrix_methodtype weighting_matrix baseline_method
% Hide Baseline Correction interface
    % Interface
    set(handles.Baseline_panel,'Visible','off');
    % Buttons
    set(handles.Back_2_btt,'Visible','Off');
    set(handles.Next_3_btt,'Visible','Off');
% Show Weighting Matrix Interface
    % Interface
    set(handles.methodType_buttongroup,'Visible','On');
    set(handles.TopText,'string','Step 4/6 - Estimate Correction Matrix for Artifact Correction');
    set(handles.log_text,'String','Choose the Correction Matrix Method and Click "Calculate" to proceed.');      
    % Buttons
    set(handles.Back_3_btt,'Visible','on');
    if isempty(cmatrix_methodtype)
        set(handles.Calculate,'Visible','On');
    else
    if cmatrix_methodtype == 3 || cmatrix_methodtype == 5
        set(handles.Weighting_matrix_vizualiz,'Visible','Off'); 
        set(handles.Weighting_matrix_vizualiz,'visible','off');
    elseif isempty(weighting_matrix)
    else
        set(handles.Weighting_matrix_vizualiz,'visible','on');                    
    end
    if cmatrix_methodtype == 3 || cmatrix_methodtype == 4
        set(handles.Calculate,'Visible','Off');
        set(handles.Next_4_btt,'Visible','on');
    else
        set(handles.Calculate,'Visible','On');
    end
end


    
% -------------------------------------------------------------------
% ---------------------- Method Choice W.Matrix ---------------------
% -------------------------------------------------------------------
function methodType_buttongroup_SelectionChangeFcn(hObject, eventdata)
%retrieve GUI data, i.e. the handles structure
global cmatrix_methodtype Peak_references weighting_matrix
global k
handles = guidata(hObject); 
set(handles.log_text,'String','Choose the Correction Matrix Method and Click "Calculate" to proceed.');
set(handles.Calculate,'Enable','On');
% set(handles.cancel_btt,'Value',1);    
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'rp_info_radio'
      %execute this code when rp_info_radio is selected
      cmatrix_methodtype=1; % Internal Variable for method_type
      set(handles.Weighting_matrix_vizualiz,'visible','off');
      set(handles.crosscorr_panel,'visible','Off');      
      set(handles.Head_movement_data, 'Visible', 'on');
      set(handles.uipanel2,'Visible', 'on');
      set(handles.LoadFile_btt,'Visible', 'on');
      set(handles.FileNamePath, 'Visible', 'on');
      set(handles.Stat_file, 'Visible', 'on');
      set(handles.text1, 'Visible', 'on');
      set(handles.text7, 'Visible', 'on');
      set(handles.text4, 'Visible', 'on');
      set(handles.threshold_1, 'Visible', 'on');
      set(handles.Stat_Tresh, 'Visible', 'on');
      set(handles.Calculate,'Visible','On');
      set(handles.Next_4_btt,'visible','Off');
      set(handles.load_mat_file_panel,'visible','Off');
      set(handles.rp_parameters,'Visible','On');
      set(handles.save_weighting_matrix,'Visible','On');
      set(handles.save_weighting_matrix,'Enable','Off');
      
      
    case 'moving_average_radio'
      %execute this code when moving_average_radio is selected
      cmatrix_methodtype=2; % Internal Variable for method_type
      set(handles.Weighting_matrix_vizualiz,'visible','off');
      set(handles.rp_parameters,'Visible','On');
      set(handles.Head_movement_data, 'Visible', 'off');
      set(handles.crosscorr_panel,'visible','Off');      
      set(handles.uipanel2, 'Visible', 'off');
      set(handles.LoadFile_btt, 'Visible', 'off');
      set(handles.FileNamePath, 'Visible', 'off');
      set(handles.Stat_file, 'Visible', 'off');
      set(handles.text1, 'Visible', 'off');
      set(handles.text7, 'Visible', 'off');
      set(handles.text4, 'Visible', 'off');
      set(handles.threshold_1, 'Visible', 'off');
      set(handles.Stat_Tresh, 'Visible', 'off');
      set(handles.Calculate,'Visible','On');
      set(handles.Next_4_btt,'visible','Off');
      set(handles.load_mat_file_panel,'visible','Off');
      set(handles.save_weighting_matrix,'Visible','On');
      set(handles.save_weighting_matrix,'Enable','Off');
      
      
    case 'all_artifacts_radio'
        cmatrix_methodtype = 3;
        set(handles.rp_parameters,'Visible','Off');
        set(handles.crosscorr_panel,'visible','Off');
        set(handles.load_mat_file_panel,'visible','Off');
        set(handles.Weighting_matrix_vizualiz,'visible','off');
        set(handles.Calculate,'Visible','Off');
        set(handles.Back_3_btt,'Visible','on');
        k = length(Peak_references);
        weighting_matrix = ones( k, k);
        set(handles.Reset_1,'Visible','Off');
        set(handles.Next_4_btt,'visible','On');
        set(handles.Next_4_btt,'Enable','On');
        set(handles.save_weighting_matrix,'Visible','Off');
        set(handles.save_weighting_matrix,'Enable','Off');
        
    case 'custom_correctionM_radio'
        cmatrix_methodtype = 4;
        set(handles.rp_parameters,'Visible','Off');
        set(handles.Calculate,'Visible','Off');
        set(handles.crosscorr_panel,'visible','Off');
        set(handles.Next_4_btt,'visible','On');
        set(handles.load_mat_file_panel,'visible','On');
        set(handles.Weighting_matrix_vizualiz,'visible','off');
        set(handles.Calculate,'Visible','Off');
        set(handles.Back_3_btt,'Visible','On');
        set(handles.Reset_1,'Visible','Off');
        set(handles.Next_4_btt,'Enable','Off');
        set(handles.Next_4_btt,'visible','On');
        set(handles.save_weighting_matrix,'Visible','Off');
        set(handles.save_weighting_matrix,'Enable','Off');

    case 'crosscorrelation'
        cmatrix_methodtype = 5;
        set(handles.rp_parameters,'Visible','Off');
        set(handles.load_mat_file_panel,'visible','Off');
        set(handles.Weighting_matrix_vizualiz,'visible','off');
        set(handles.Calculate,'Visible','On');
        set(handles.Back_3_btt,'Visible','on');
        k = length(Peak_references);
        weighting_matrix = ones( k, k);
        set(handles.crosscorr_panel,'visible','On');
        set(handles.Reset_1,'Visible','Off');
        set(handles.Next_4_btt,'visible','Off');
        set(handles.save_weighting_matrix,'Visible','Off');
        set(handles.save_weighting_matrix,'Enable','Off');        
      
    otherwise
       % Code for when there is no match.
end
guidata(hObject, handles);

%         ------------- End of Choosing Method -------------



% -------------------------------------------------------------------
% ----------------- Buttons of Correction Interface -----------------
% -------------------------------------------------------------------

% LoadFile: .txt file.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function LoadFile_btt_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile('*.txt');
    if isequal(filename,0) | isequal(pathname,0)
       set(handles.log_text,'String','File not loaded.');
       set(handles.Stat_file,'String','*');
    else
       file = fullfile(pathname,filename);
       set(handles.FileNamePath,'BackgroundColor','white');
       set(handles.FileNamePath,'String',file);
       set(handles.Head_movement_data,'Value',1);
       set(handles.Stat_file,'String','');
    end
    try 
        [a,b,c,d,e,g] = textread([pathname,filename]);
    catch
        warndlg2('Invalid file. File must have dimention [ n x 6 ]');
    end



% LoadFile: .mat file.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function load_mat_file_btt_Callback(hObject, eventdata, handles)
global EEG Peak_references weighting_matrix k
[filename, pathname] = uigetfile('*.mat');
    if isequal(filename,0) | isequal(pathname,0)
       set(handles.log_text,'String','File not loaded.');
       set(handles.FileNamePath2,'Value',0);
    else
       file = fullfile(pathname,filename);
       set(handles.FileNamePath2,'BackgroundColor','white');
       set(handles.FileNamePath2,'String',file);
       set(handles.FileNamePath2,'Value',1);
       set(handles.Stat_file,'String','');
    end
    try 
        Struct_mat = load(file, 'weighting_matrix');
        [a, b] = size(Struct_mat.weighting_matrix);
        if a == b && a >= length(Peak_references)
            weighting_matrix = Struct_mat.weighting_matrix;
            set(handles.Next_4_btt,'Enable','On');
            command = ['temp = open(''', [pathname, filename],''');, weighting_matrix = temp.weighting_matrix;, clear temp;'];
            EEG.history = [ EEG.history 10 command ];
            % Plot Weighting Matrix data on axes
            set(handles.axes1,'visible','off');
            axes(handles.axes1);
            plot(1,1);
            set(handles.axes1,'Visible','off');
            axes(handles.axes2);
            imagesc(weighting_matrix);
            colormap(gray);
            set(gca,'FontSize',8);
            set(handles.Weighting_matrix_vizualiz,'Visible','On'); % Show result of weighting matrix
            k=0;
            for i=1 : length(weighting_matrix)
                if weighting_matrix(i) == 1
                    k=k+1;
                end
            end
            k=(k-1)*2;
        else
            warndlg2(['Invalid dimmention for weighting_matrix variable. ', 10,...
                'File must contain a [ n x n ] matrix.']);
            set(handles.Weighting_matrix_vizualiz,'Visible','Off'); % Hide result of weighting matrix
            set(handles.FileNamePath2,'String','Please load a *.mat file');
            set(handles.Next_4_btt,'Enable','Off');
            set(handles.log_text,'String','Verify the Correction Matrix and click "Accept" to proceed with the artifacts correction.');
        end
    catch
        warndlg2(['No file was loaded. Please choose only Matlab files (*.mat)',10,...
            'File must contain a variable named as "weighting_matrix".',10,...
            'Variable must be a matrix with dimention [ n x n ]',10,...
            '(n is the number of artifact volumes)']);
        set(handles.FileNamePath2,'String','Please load a *.mat file');
        set(handles.Next_4_btt,'Enable','Off');
        set(handles.log_text,'String','Verify the Correction Matrix and click "Accept" to proceed with the artifacts correction.');
    end

    
    
    
% Calculate weighting Matrix: Button
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Calculate_Callback(hObject, eventdata, handles)
% set(handles.cancel_btt,'String','Cancel');
global EEG
global cmatrix_methodtype
global weighting_matrix mov_struct
global Peak_references
global k onset_value offset_value
global limit_adc_correlation
complete = 0;
fmri_weighting_matrix = length(weighting_matrix);

% Correction Matrix methods
% 1-RP_INFO 
% 2-MOVING AVERAGE 
% 3-All artifacts volumes 
% 4-Custom matrix

switch cmatrix_methodtype 
    case 1 % 1-RP_INFO
  % Get Tag of selected object
      if get(handles.Head_movement_data,'Value') == 0
          set(handles.Stat_file,'String','Missing');
      else
          rp_file = get(handles.FileNamePath,'String');
          complete = complete + 1;
      end
      %Protejer os campos de serem string
      n_fMRI = length(Peak_references);
      threshold = get(handles.threshold_1,'Value');
      if get(handles.threshold_1,'Value') == 0
          set(handles.Stat_Tresh,'String','Missing');
      else
          complete = complete + 1;
      end
      k = get(handles.artifacts,'Value');            
      if k == 0
         set(handles.Stat_NArt,'String','Missing');
      else
         complete = complete + 1; 
      end
      if complete == 3
        try
            if (n_fMRI - fmri_weighting_matrix ) >= 0;
                % Execute Calculus of Weighting Matrix
                % [motiondata_struct,weighting_matrix] = m_rp_info('example01.txt',300,0.5,25);
                [motiondata_struct,weighting_matrix] = m_rp_info(rp_file,n_fMRI,threshold,k);
                command = ['[motiondata_struct,weighting_matrix] = m_rp_info( ''', rp_file, ''', ', num2str(n_fMRI), ', ', num2str(threshold), ', ', num2str(k),' );'];
                EEG.history = [ EEG.history 10 command ];
                % Plot Weighting Matrix data on axes
                mov_struct = motiondata_struct;
                set(handles.axes1,'visible','on');
                axes(handles.axes1);
                plot(motiondata_struct.both_not_normed,'k');
                xlim([0 n_fMRI]);
                set(gca,'FontSize',8);
                axes(handles.axes2);
                imagesc(weighting_matrix);
                colormap(gray);
                set(gca,'FontSize',8);
                set(handles.Weighting_matrix_vizualiz,'Visible','On'); % Show result of weighting matrix
                lock_corretionMatrix_param(handles);
                set(handles.save_weighting_matrix,'Enable','On');
        
            else
                errordlg2('Weighting Matrix Error: The loaded Realignment Parameter file contains more fMRI volumes then the artifact detection in step 1 has found. Please Load a different file.','Weighting Matrix');
                set(handles.save_weighting_matrix,'Enable','Off');
            end
        catch
            errordlg2([10,'Weighting Matrix calculation error:',10,...
              'Tips:',10,...
              '     a) Try to use different number of artifacts;',10,...
              '     b) Try to reduce threshold;',10,...
              '     c) Make sure you loaded the correct file;',10,...
              '     d) Try to use different method;',10,' '],'Weighting Matrix');
          set(handles.save_weighting_matrix,'Enable','Off');
        end
      else
          warndlg2('Cannot proceed! Method parameters are missing.','Weighting Matrix');
          set(handles.save_weighting_matrix,'Enable','Off');
      end

    case 2 % 2-MOVING AVERAGE
      n_fMRI = length(Peak_references);
      k = get(handles.artifacts,'Value');            
      if k == 0
         set(handles.Stat_NArt,'String','Missing');
      else
         complete = complete + 1; 
      end
      if complete == 1 
        try
            weighting_matrix = m_moving_average(n_fMRI,k);
            command = ['[ weighting_matrix ] = m_moving_average( ', num2str(n_fMRI), ', ', num2str(k),' );'];
            EEG.history = [ EEG.history 10 command ];
            % Plot Weighting Matrix data on axes
            set(handles.axes1,'visible','off');
            axes(handles.axes1);
            plot(1,1);
            set(handles.axes1,'Visible','off');
            axes(handles.axes2);
            imagesc(weighting_matrix);
            colormap(gray);
            set(gca,'FontSize',8);
            set(handles.Weighting_matrix_vizualiz,'Visible','On'); % Show result of weighting matrix
            lock_corretionMatrix_param(handles);
            set(handles.save_weighting_matrix,'Enable','On');
        catch
          errordlg2([10,'Weighting Matrix calculation error:',10,...
              'Tips:',10,...
              '     a) Try to use different number of artifacts;',10,...
              '     b) Try to use different method;'],10,' ','Weighting Matrix');
          set(handles.save_weighting_matrix,'Enable','Off');
        end
      else
          warndlg2('Cannot proceed! Method parameters are missing.','Weighting Matrix');
          set(handles.save_weighting_matrix,'Enable','Off');
      end

    case 3 % 3-All artifacts volumes

    case 4 % 4-Custom matrix
        
    case 5 % 5-Adapted template correction
        n_fMRI = length(Peak_references);
        if get(handles.auto_cc,'value') == 1
            k = 25;
            complete = 1; 
        else
            k = str2num(get(handles.cc_n_artifacts_value,'string'));        
            if k <= n_fMRI
                complete = 1;
            end
        end
        if complete == 1
            if get(handles.limit_correlation_checkbox,'value') == 1
                limit = limit_adc_correlation;
                [ weighting_matrix ] = m_cc_correction(EEG, k, Peak_references, limit, onset_value, offset_value);                
            else
                limit = 0;
                [ weighting_matrix ] = m_cc_correction(EEG, k, Peak_references, limit, onset_value, offset_value);
            end
%         command = ['[motiondata_struct,weighting_matrix] = m_rp_info( ''', rp_file, ''', ', num2str(n_fMRI), ', ', num2str(threshold), ', ', num2str(k),' );'];
%         EEG.history = [ EEG.history 10 command ];
            % Plot Weighting Matrix data on axes
            set(handles.axes1,'visible','on');
            axes(handles.axes1);
%                 plot(motiondata_struct.both_not_normed,'k');
%                 xlim([0 n_fMRI]);
%                 set(gca,'FontSize',8);
            axes(handles.axes2);
            imagesc(weighting_matrix);
            colormap(gray);
            set(gca,'FontSize',8);
            set(handles.Weighting_matrix_vizualiz,'Visible','On'); % Show result of weighting matrix
            lock_corretionMatrix_param(handles);
            set(handles.save_weighting_matrix,'Enable','On');
        else
              warndlg2('Cannot proceed! Method parameters are missing.','Weighting Matrix');
              set(handles.save_weighting_matrix,'Enable','Off');
        end
end


% Lock Imput fields and refresh buttons state
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function lock_corretionMatrix_param(handles)
set(handles.rp_info_radio,'Enable','inactive');
set(handles.moving_average_radio,'Enable','inactive');
set(handles.all_artifacts_radio,'Enable','inactive');
set(handles.custom_correctionM_radio,'Enable','inactive');
set(handles.auto_cc,'Enable','inactive');
set(handles.specify_n_artifacts,'Enable','inactive');
set(handles.cc_n_artifacts_value,'Enable','inactive');
set(handles.artifacts,'Enable','inactive');
set(handles.threshold_1,'Enable','inactive');
set(handles.file_radiobtt,'Enable','inactive');
set(handles.LoadFile_btt,'Enable','inactive');
set(handles.Calculate,'Visible','Off');
set(handles.Back_3_btt,'Visible','Off');
set(handles.Reset_1,'Visible','On');
set(handles.Reset_1,'Enable','On');
set(handles.Next_4_btt,'visible','On');
set(handles.Next_4_btt,'Enable','On');
set(handles.log_text,'String','Verify the Correction Matrix result and click "Accept" to proceed with the artifacts correction.');


% Reset Matrix parameters: Button
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Reset_1_Callback(hObject, eventdata, handles)
set(handles.Next_4_btt,'visible','Off');
set(handles.log_text,'String','Imput parameters and click "Calculate" to proceed');
% reactivate method radioButtons
set(handles.rp_info_radio,'Enable','On');
set(handles.moving_average_radio,'Enable','On');
set(handles.all_artifacts_radio,'Enable','On');
set(handles.custom_correctionM_radio,'Enable','On');
set(handles.save_weighting_matrix,'Enable','Off');
set(handles.Back_3_btt,'Visible','On');
% Reactivate buttons and rp_info parameters
set(handles.Calculate,'Visible','On');
set(handles.Reset_1,'Enable','Off');
set(handles.Reset_1,'Visible','Off');
set(handles.artifacts,'Enable','On');
set(handles.threshold_1,'Enable','On');
set(handles.LoadFile_btt,'Enable','On');
set(handles.file_radiobtt,'Enable','On');
set(handles.auto_cc,'Enable','On');
set(handles.specify_n_artifacts,'Enable','On');
set(handles.cc_n_artifacts_value,'Enable','On');




% Button to save the Weighting Matrix
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function save_weighting_matrix_Callback(hObject, eventdata, handles)
global weighting_matrix
[filename, pathname] = uiputfile('*.mat', 'Save Weighting Matrix');
    if isequal(filename,0) | isequal(pathname,0)
       set(handles.log_text,'String','File was not saved.');
       set(handles.FileNamePath2,'Value',0);
    else
       file_to_save = fullfile(pathname,filename);
       save(file_to_save, 'weighting_matrix')
       set(handles.log_text,'String','File was saved.');
    end

    

%            ------------- End of Buttons -------------

% -------------------------------------------------------------------
% -----------------  Evaluation of Matrix Parameters ----------------
% -------------------------------------------------------------------

% Evaluation of N_Artifacts.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function artifacts_Callback(hObject, eventdata, handles)
global Peak_references
max = length(Peak_references);
validate_num = str2double(get(handles.artifacts,'string'));
if isnan(validate_num) || validate_num < 1 || validate_num >= max
    set(handles.artifacts,'String','');
    set(handles.artifacts,'Value',0);
    set(handles.Stat_NArt,'String','*');
    set(handles.log_text,'String','Number of Artifacts must be between 1 and total number of Markers found at step 1.');
else
    set(handles.Stat_NArt,'String','');
    set(handles.artifacts,'Value',validate_num)
end

% Evaluation of Threshold movement.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function threshold_1_Callback(hObject, eventdata, handles)
validate_num = str2double(get(handles.threshold_1,'string'));
try
    if isnan(validate_num) || validate_num <= 0 || validate_num >= 10
        set(handles.threshold_1,'String','');
        set(handles.threshold_1,'Value',0);
        set(handles.Stat_Tresh,'String','*');
        set(handles.log_text,'String','Treshold value must be between 0 and 1');
    else    
        object_string='Stat_Tresh';
        set(handles.Stat_Tresh,'String','');
        set(handles.threshold_1,'Value',validate_num);
    end
catch
    set(handles.threshold_1,'String','');
    set(handles.threshold_1,'Value',0);
    set(handles.Stat_Tresh,'String','*');
    set(handles.log_text,'String','Treshold value must be between 0 and 1');
end
    

%            ------------- End Evaluation -------------




% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% |||||||||||| Goes back to Correction Matrix Interface |||||||||||||
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
function Back_4_btt_Callback(hObject, eventdata, handles)
global cmatrix_methodtype
reset_definitions_summary_panel(handles);
% Hide Filtering Options Interface
    % Interface
    set(handles.filtering_panel,'visible','off');
    % Buttons
    set(handles.Back_4_btt,'Visible','Off');
    set(handles.Next_5_btt,'Visible', 'Off');
% Show Correction Interface interface
    % Interface
    set(handles.TopText,'string','Step 4/6 - Estimate Correction Matrix for Artifact Correction');
    set(handles.log_text,'String','Choose the Correction Matrix Method and Click "Calculate" to proceed.');      
    set(handles.methodType_buttongroup,'visible','on');
    if cmatrix_methodtype == 3 || cmatrix_methodtype == 5
        set(handles.Weighting_matrix_vizualiz,'Visible','Off');        
        set(handles.Back_3_btt,'Visible','On');
    elseif cmatrix_methodtype == 4 
            set(handles.Back_3_btt,'Visible','On');
            set(handles.Weighting_matrix_vizualiz,'visible','on');
    else
        set(handles.Weighting_matrix_vizualiz,'visible','on');
        set(handles.Reset_1,'Visible','On');
    end
    % Buttons
    set(handles.Next_4_btt,'visible','On');
    
function reset_definitions_summary_panel(handles);
% Step 1
set(handles.Markers_method,'String', '-');
set(handles.Markers_TR,'String', '-');
set(handles.Markers_count,'String','-');
set(handles.start_of_fmri,'String', '-');
set(handles.end_of_fmri,'String','-');

% Step 2
set(handles.fmri_method,'String','-');
set(handles.fmri_duration,'String', '-');
set(handles.fmri_silentgap,'String', '-');
set(handles.onset_txt,'String', '-');
set(handles.offset_txt,'String', '-');

% Step 3
set(handles.Baseline_method_txt,'String','-');
set(handles.baseline_start_ref_info_txt,'String','Start of baseline reference [ms]:');
set(handles.baseline_end_ref_info_txt,'String','End of baseline reference [ms]:');
set(handles.baseline_start_ref_txt,'String', '-');
set(handles.baseline_end_ref_txt,'String','-');
set(handles.baseline_otherdata_shifting_txt,'string','-');

% Step 4
set(handles.cmatrix_method,'String', '-');
set(handles.cmatrix_volumes,'String', '-');
set(handles.cmatrix_artifacts,'String', '-');
set(handles.simul_volumesignored,'String','-');

% Step 5
set(handles.current_sample_rate,'String', '-');
set(handles.new_sample_rate_txt,'String', '-');
set(handles.filter_data_txt,'String', '-');


% Simulation_panel
set(handles.n_channels_txt,'String', '-');
set(handles.overwrite_dataset_txt,'String','-');
set(handles.simul_time,'String', '-');





% ###################################################################
% ################### Filtering Options Interface ###################
% ###################################################################
function Next_4_btt_Callback(hObject, eventdata, handles)
global EEG
% Hide wheighting matrix interface
    % Interface
    set(handles.current_samplerate_txt,'String',num2str(EEG.srate));
    set(handles.Weighting_matrix_vizualiz,'visible','off');
    set(handles.methodType_buttongroup,'visible','off');
    % Buttons
    set(handles.Reset_1,'Visible','Off');
    set(handles.Back_3_btt,'Visible','Off');
    set(handles.Next_4_btt,'Visible', 'off');

% Show Filtering Options interface
    set(handles.TopText,'String','Step 5/6 - Filtering Options');
    set(handles.log_text,'String','Choose the filtering options parameters.');
    set(handles.filtering_panel,'Visible','on');
    % Buttons
    set(handles.Next_5_btt,'visible','On');
    set(handles.Back_4_btt,'Visible','On');


    
% Resampling dataset
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function resample_checkbox_Callback(hObject, eventdata, handles)
option = get(handles.resample_checkbox,'value');
if option == 1
    set(allchild(handles.resample_panel),'enable','on');
else
    set(allchild(handles.resample_panel),'enable','off');
end

function resample_rate_txt_Callback(hObject, eventdata, handles)


% Filtering dataset
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function apply_filter_checkbox_Callback(hObject, eventdata, handles)
option = get(handles.apply_filter_checkbox,'value');
if option == 1
    set(allchild(handles.filter_panel),'enable','on');
else
    set(allchild(handles.filter_panel),'enable','off');
end


function filter_start_freq_Callback(hObject, eventdata, handles)

function filter_end_freq_Callback(hObject, eventdata, handles)



    
 % ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% ||||||||||||||||| Goes back to Filtering Options ||||||||||||||||||
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
function Back_5_btt_Callback(hObject, eventdata, handles)
global cmatrix_methodtype
reset_definitions_summary_panel(handles);
%Hide final resume interface
    set(handles.Back_5_btt,'Visible','Off');
    set(handles.Next_5_btt,'Visible','Off');
    set(handles.Apply_changes_btt,'Visible', 'off');
    set(handles.final_resume_panel,'visible','off');
% Show Filtering options interface
    set(handles.TopText,'String','Step 5/6 - Filtering Options');
    set(handles.log_text,'String','Choose the filtering options parameters.');
    set(handles.filtering_panel,'Visible','on');
    % Buttons
    set(handles.Next_5_btt,'visible','On');
    set(handles.Back_4_btt,'Visible','On');
    
    
    
% ###################################################################
% ############## Review Parameters and Apply Interface ##############
% ###################################################################
function Next_5_btt_Callback(hObject, eventdata, handles)
global EEG
global weighting_matrix 
global Peak_references
global onset_value offset_value
global simulation
% Hide Filtering options interface
    % Interface
    set(handles.filtering_panel,'visible','off');
    % Buttons
    set(handles.Back_4_btt,'Visible','Off');
    set(handles.Next_5_btt,'Visible', 'Off');

% Show final resume interface
    set(handles.log_text,'String','Please wait while parameters are evaluated...');
    set(handles.Back_5_btt,'Visible','On');
    set(handles.final_resume_panel,'visible','on');
    set(handles.TopText,'String','Step 6/6 - Review your settings & Apply Correction');
    set(handles.Apply_changes_btt,'Visible', 'on');
    set(handles.Apply_changes_btt,'Enable', 'off');
    set(handles.simul_time,'String','Calculating...');
    pause(1);

    simulation = SimulateCorrection(EEG, weighting_matrix, Peak_references, onset_value, offset_value);
    if simulation == 0;
        errordlg2([10, 'Simulation failed. Error found', 10,...
            'Possible causes:',10,...
            '   a) Some artifacts volumes are not complete or/and may require cuting dataset edges;',10,...
            '   b) The dataset does not contain the same number of complete artifacts refered in the file you loaded at step 4;',10,' '], 'Simulation Failed');
        set(handles.simul_volumesignored,'String','ERROR');
        set(handles.simul_time,'String','Incomplete');
        set(handles.log_text,'String','Please go back and redefine parameters.');
    else
        Update_definitions_summary(handles);
        set(handles.log_text,'String','Done! Review all settings and click "Apply" to remove the artifacts.');
        set(handles.Apply_changes_btt,'Enable', 'on');
    end

   
 
% Show final summary panel
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
function Update_definitions_summary(handles)
global EEG log_string
global sync_type cmatrix_methodtype baseline_method
global Peak_references weighting_matrix
global onset_value offset_value
global simulation
global k
fmri_weighting_matrix = length(weighting_matrix);
TR = Peak_references(2)-Peak_references(1);


%Step1
    log_string = [log_string, '------',10,...
                              'Step 1 - Volumes onset detection (Markers)',10];
    if sync_type == 1
        Markerselected = get(handles.Selected_marker_drop,'Value');
        MarkerString = get(handles.Selected_marker_drop,'String');
        Marker = MarkerString(Markerselected);
                Mark=get(handles.Selected_marker_drop,'string');
                Indic=get(handles.Selected_marker_drop,'value');
                sync_type_str = ['Marker ', Mark(Indic)];
        set(handles.Markers_method,'String',['Use Marker ''' cell2mat(Marker) '''']);
        log_string = [log_string, 'Method: Use Marker from recording (''' cell2mat(Marker) ''')',10];
    end
    if sync_type == 2
        sync_type_str = 'Marker';
        set(handles.Markers_method,'String',sync_type_str);
        log_string = [log_string, 'Method: Use manual detection',10];
    end
    n_peaks = length(Peak_references);
    val_TR = Peak_references(2)-Peak_references(1);
    set(handles.Markers_TR,'String',num2str(val_TR/EEG.srate*1000));
    log_string = [log_string, 'Repetition rate [ms]: ', num2str(val_TR/EEG.srate*1000),10];
    log_string = [log_string, 'Referenced channel: ', get(handles.ch_txt,'string'),10];
    log_string = [log_string, 'Gradient Threshold [µV]: ', get(handles.grad_txt,'string'),10];
    set(handles.Markers_count,'String',num2str(n_peaks));
    log_string = [log_string, 'Total Markers found: ', num2str(n_peaks),10];
    
    start_of_fmri = Peak_references(1)/EEG.srate;
    start_of_fmri_txt = start_of_fmri/60;
    minuts = fix(start_of_fmri_txt);
    seconds = fix((start_of_fmri_txt-minuts)*60);
    if seconds < 10
        start_of_fmri_txt = [int2str(minuts), 'm', '0',int2str(seconds),'s'];
    else
        start_of_fmri_txt = [int2str(minuts), 'm', int2str(seconds),'s'];
    end
    set(handles.start_of_fmri,'String',start_of_fmri_txt);
    log_string = [log_string, 'Begining of fMRI recording [ms]: ', start_of_fmri_txt,10];

    end_fmri_position = (Peak_references(n_peaks)+val_TR)/EEG.srate;
    end_fmri_position_txt = end_fmri_position/60;
    minuts = fix(end_fmri_position_txt);
    seconds = fix((end_fmri_position_txt-minuts)*60);
    if seconds < 10
        end_fmri_position_txt = [int2str(minuts), 'm', '0',int2str(seconds),'s'];
    else
        end_fmri_position_txt = [int2str(minuts), 'm', int2str(seconds),'s'];
    end
    set(handles.end_of_fmri,'String',end_fmri_position_txt);
    log_string = [log_string, 'End of fMRI recording [ms]: ', end_fmri_position_txt,10];    
    
    

%Step 2
    log_string = [log_string, '------',10,10,...
                              '------',10,...
                              'Step 2 - Artifact Duration Parameters',10];
    if get(handles.especific_onset_offset,'value') == 1
        set(handles.fmri_method,'String','Manual selection');
        log_string = [log_string, 'Method: Manual selection',10];    
    else
        set(handles.fmri_method,'String','Auto select');
        log_string = [log_string, 'Method: Auto select',10];            
    end
    artifact_dur = offset_value - onset_value;
    artifact_duration_txt = num2str(artifact_dur/EEG.srate*1000);
    set(handles.fmri_duration,'String',artifact_duration_txt);
    log_string = [log_string, 'Artifact Volume duration [ms]: ', artifact_duration_txt,10];            

    silent = val_TR - artifact_dur;
    silent_txt = num2str(silent/EEG.srate*1000);
    set(handles.fmri_silentgap,'String',silent_txt);
    log_string = [log_string, 'Silent gap duration [ms]: ', silent_txt,10]; 

    onset_txt = num2str(onset_value/EEG.srate*1000);
    set(handles.onset_txt,'String',onset_txt);
    log_string = [log_string, 'Artifact start relative to marker [ms]: ', onset_txt,10]; 

    offset_txt = num2str(offset_value/EEG.srate*1000);
    set(handles.offset_txt,'String',offset_txt);
    log_string = [log_string, 'Artifact end relative to marker [ms]: ', offset_txt,10]; 
%     set(handles.incomplete_fmri_volumes,'String','Not found');
    

% Baseline Methods: variable "baseline_method"
% 0 - No method
% 1 - Based on whole artifact avergage
% 2 - Based on the average of precedent silent gap
% 3 - Based on the average of time interval

%Step 3
log_string = [log_string, '------',10,10,...
                          '------',10,...
                          'Step 3 - Baseline Correction Method',10];
switch baseline_method
    case 0 
        set(handles.Baseline_method_txt,'String', 'None');
        log_string = [log_string, 'Baseline method: None',10];         
        set(handles.baseline_start_ref_txt,'String','-');
    otherwise
        set(handles.baseline_start_ref_txt,'String','Yes');
        set(handles.baseline_end_ref_txt,'String','Yes');
        % Take all Artifact
        if baseline_method == 1 
            set(handles.Baseline_method_txt,'String', 'Average of all artifact');
            log_string = [log_string, 'Baseline method: Average of all artifact',10];                     
            set(handles.baseline_start_ref_info_txt,'String','Baseline value:');
            set(handles.baseline_end_ref_info_txt,'String','Data to be shifted:');            
            set(handles.baseline_start_ref_txt,'String','0');
            set(handles.baseline_end_ref_txt,'String','Artifact volumes');
            log_string = [log_string, 'Baseline amplitude value [µV]: 0',10];                     
        end
        
        % Take precedent silentgap
        if baseline_method == 2 
            set(handles.Baseline_method_txt,'String', 'Average of precedent silent gap');
            log_string = [log_string, 'Baseline method: Average of precedent silent gap',10];                     
            set(handles.baseline_end_ref_txt,'String', 'No');
            base_start = get(handles.artifact_offset_txt,'string');
            base_end = get(handles.artifact_onset_txt,'string');
            base_start = str2num(base_start)*EEG.srate/1000-TR;
            set(handles.baseline_start_ref_txt,'String',num2str(base_start/EEG.srate*1000));
            set(handles.baseline_end_ref_txt,'String',base_end);
            log_string = [log_string, 'Baseline amplitude value [µV]: Variable',10];                                 
        end
        
        % Take time intervale for average
        if baseline_method == 3 
            set(handles.Baseline_method_txt,'String', 'Average of time interval');
            log_string = [log_string, 'Baseline method: Average of time interval',10];                     
            set(handles.baseline_start_ref_txt,'String',get(handles.start_baseline_ref,'String'));
            set(handles.baseline_end_ref_txt,'String',get(handles.end_baseline_ref,'String'));
            log_string = [log_string, 'Baseline amplitude value [µV]: Variable',10];                     
        end
        
        % Advanced Options:
        % Shift other data
        if get(handles.Shift_non_corrected_data,'value') == 1
            set(handles.baseline_otherdata_shifting_txt,'string','Yes');
            answer = 'Yes';
        else
            set(handles.baseline_otherdata_shifting_txt,'string','No');
            answer = 'No';            
        end
        log_string = [log_string, 'Shift non corrected data to baseline: ', answer,10];                                 
end


    
%Step 4
log_string = [log_string, '------',10,10,...
                          '------',10,...
                          'Step 4 - Correction Matrix Method',10];
    if cmatrix_methodtype == 1
        cmatrix_str = 'RP-Informed';
        log_string = [log_string, 'Method: RP-Informed',10];
        log_string = [log_string, 'Loaded file: ',get(handles.FileNamePath,'String'),10];
        log_string = [log_string, 'Threshold: ',get(handles.threshold_1,'String'),10];
    end
    if cmatrix_methodtype == 2
        cmatrix_str  = 'Moving average';
        log_string = [log_string, 'Method: Moving average',10];
    end
    if cmatrix_methodtype == 3
        cmatrix_str  = 'All artifacts';
        log_string = [log_string, 'Method: All artifacts',10];
    end
    if cmatrix_methodtype == 4
        cmatrix_str  = 'Loaded matrix';
        log_string = [log_string, 'Method: Loaded matrix',10];
        log_string = [log_string, 'Loaded file: ',get(handles.FileNamePath2,'String'),10];        
        log_string = [log_string, 'Number of volumes considered for correction (per channel): ',get(handles.cmatrix_artifacts,'string'),10];
    end
    if cmatrix_methodtype == 5
        cmatrix_str  = 'Data driven from cross correlation';
        log_string = [log_string, 'Method: Data driven from cross correlation',10];
        log_string = [log_string, 'Number of best volumes considered for the artifacts template (per channel): ',num2str(k),10];
    end
    w_matrix_size = size(weighting_matrix);
    log_string = [log_string, 'Dimention of Correction Matrix: [',num2str(w_matrix_size), ']',10];    
    set(handles.cmatrix_method,'String',cmatrix_str);
    set(handles.cmatrix_artifacts,'String',num2str(k));
    log_string = [log_string, 'Number of volumes constituting template: ',num2str(k),10];    
    set(handles.cmatrix_volumes,'String',num2str(fmri_weighting_matrix));
    discharged = n_peaks-fmri_weighting_matrix;
    set(handles.simul_volumesignored,'String',num2str(discharged));
    log_string = [log_string, 'Total volumes ignored: ',num2str(discharged),10];

%Step 5
log_string = [log_string, '------',10,10,...
                          '------',10,...
                          'Step 5 - Filtering Options',10];
                      
    set(handles.current_sample_rate,'string',num2str(EEG.srate));
    if get(handles.resample_checkbox,'value') == 1
        new_sample = get(handles.resample_rate_txt,'String');
        set(handles.new_sample_rate_txt,'string',new_sample);
        log_string = [log_string, 'Resample data: ', new_sample,10];
    else
        log_string = [log_string, 'Resample data: No',10];
    end
    if get(handles.apply_filter_checkbox,'value') == 1
        filter_start_freq_txt = get(handles.filter_start_freq,'string');
        filter_end_freq_txt = get(handles.filter_end_freq,'string');
        filter_txt = ['[ ',filter_start_freq_txt, 'Hz - ', filter_end_freq_txt, 'Hz ]'];
        set(handles.filter_data_txt,'string',filter_txt);
        log_string = [log_string, 'Apply pass-band filter: ', filter_txt,10];
    else
        log_string = [log_string, 'Apply pass-band filter: No',10];
    end

%Step 6
    set(handles.n_channels_txt,'String',num2str(length(EEG.chanlocs)));
    
    modifyed_data = artifact_dur*fmri_weighting_matrix/EEG.srate;
    percentage_overwrite = num2str((modifyed_data/(length(EEG.data(1,:))/EEG.srate))*100);
    if str2num(percentage_overwrite) == 0
        set(handles.overwrite_dataset_txt,'String', '0 %');
    else
        set(handles.overwrite_dataset_txt,'String', [percentage_overwrite(1:4), '%']);
    end
    duration_min = simulation*length(EEG.chanlocs)/60;
    minuts = fix(duration_min);
    seconds = fix((duration_min-minuts)*60);
    if seconds < 10
        expect_time= [int2str(minuts), 'm', '0',int2str(seconds),'s'];
    else
        expect_time= [int2str(minuts), 'm', int2str(seconds),'s'];
    end
    set(handles.simul_time,'String',expect_time);
    
    log_string = [log_string, '------',10];

    
    

% ###################################################################
% ############# Apply Removing & Final resume interface #############
% ###################################################################
% Remove Artifacts from EEG.dataset
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function Apply_changes_btt_Callback(hObject, eventdata, handles)
global EEG 
global Peak_references weighting_matrix 
global onset_value offset_value
global baseline_method
global cmatrix_methodtype
global k
selection = questdlg2([10, 'Are you sure you want to Apply the Correction?', 10, 'This will overwrite your current EEG Dataset!',10,' '],...
                 'Apply Correction to Dataset',...
                 'Yes','No','No');
    switch selection,
       case 'Yes',
           % Correction EEG dataset (CorrectionMatrix)
           try

                ref_start = 0;
                ref_end = 0;
% Run Baseline Correction
                fprintf(['Applying Baseline correction...']);
                if get(handles.baselineT,'value') == 1
                    if get(handles.Shift_non_corrected_data,'value') ==1
                       extra_data = 1;
                    else
                        extra_data = 0;
                    end
                    switch baseline_method
                        case 1 % whole artifact
                            [ EEG ] = BaselineCorrect(EEG, Peak_references, weighting_matrix, baseline_method, onset_value, offset_value, 0, 0, extra_data);
                        case 2 % previous silent gaps
                            TR = Peak_references(2)-Peak_references(1);
                            ref_start = offset_value+1 - TR;
                            ref_end = onset_value-1;
                            [ EEG ] = BaselineCorrect(EEG, Peak_references, weighting_matrix, baseline_method, onset_value, offset_value, ref_start, ref_end, extra_data);
                        case 3 % time interval reference
                            ref_start = str2num(get(handles.start_baseline_ref,'string'));
                            ref_end = str2num(get(handles.end_baseline_ref,'string'));
                            [ EEG ] = BaselineCorrect(EEG, Peak_references, weighting_matrix, baseline_method, onset_value, offset_value, ref_start, ref_end, extra_data);
                    end
                        set(handles.baseline_success,'string','Success');
                        fprintf(['Done!',10]);  
                end
                
                command = ['[ EEG ] = BaselineCorrect( EEG, Peak_references, weighting_matrix, ', num2str(baseline_method),', Artifact_onset, Artifact_offset, ', num2str(ref_start),', ', num2str(ref_end),', ', num2str(extra_data),' );'];
                EEG.history = [ EEG.history 10 command ];
            
% Run Artifact Removal
                error = 0;
                fprintf(['Removing Artifacts...']); 
                message = '';
                [ EEG, message ] = CorrectionMatrix(EEG, weighting_matrix, Peak_references, onset_value, offset_value);
                command = ['EEG = CorrectionMatrix( EEG, weighting_matrix, Peak_references, Artifact_onset, Artifact_offset);'];
                EEG.history = [ EEG.history 10 command ];
                if length(message) > 1
                    error = 1;
                    set(handles.artifact_removal_success,'string','Failed');
                    fprintf(['Failed!',10]);
                else
                    set(handles.artifact_removal_success,'string','Success');
                    fprintf(['Done!',10]);
                end

% Run Resampling
                if error == 1
                else
                    if get(handles.resample_checkbox,'value') == 1
                        fprintf(['Resampling...']);                    
                        h = waitbar(50,'Resampling data: Please wait...');
                        hw=findobj(h,'Type','Patch');
                        set(hw,'EdgeColor',[0.5 0.5 0.5],'FaceColor',[0.5 0.5 0.5]);
                        resample = str2num(get(handles.resample_rate_txt,'string'));
                        EEG = pop_resample(EEG, resample);
                        set(handles.resample_success,'string','Success');
                        command = ['EEG = pop_resample( EEG, ', num2str(resample), ' );'];
                        EEG.history = [ EEG.history 10 command ];
                        close(h);
                        fprintf(['Done!',10]);
                    end
                end
                

% Run Pass-band Filtering
                if error == 1
                else
                    if get(handles.apply_filter_checkbox,'value') == 1
                        fprintf(['Filtering data...']);  
                        h = waitbar(20,'Filtering data: Low-Pass Filter');
                        hw=findobj(h,'Type','Patch');
                        set(hw,'EdgeColor',[0.5 0.5 0.5],'FaceColor',[0.5 0.5 0.5]);
                        low_edge = str2num(get(handles.filter_start_freq,'string'));
                        high_edge = str2num(get(handles.filter_end_freq,'string'));
                   % Low pass Filter
                        EEG = pop_iirfilt( EEG, 0, high_edge, [], [0]);
                        command = ['EEG = pop_iirfilt( EEG, 0, ', num2str(high_edge), ' , [], [0]);'];
                        EEG.history = [ EEG.history 10 command ];
                        fprintf(['Low-pass filter applyed.; ',10]);
                   % High pass Filter
                        waitbar(0.5,h,'Filtering data: High-Pass Filter');
                        EEG = pop_iirfilt( EEG, low_edge, 0, [], [0]);
                        command = ['EEG = pop_iirfilt( EEG, ', num2str(low_edge), ', 0, [], [0]);']
                        EEG.history = [ EEG.history 10 command ]; 
                        set(handles.filtering_success,'string','Success');
                        fprintf(['High-pass filter applyed.',10]);                    
                        close(h);
                    end
                end
                
% Update Interface (Reports)
            set(handles.final_resume_panel,'visible','off');
            set(handles.Report_log_panel,'visible','on');
            set(handles.Back_5_btt,'visible','off');
            set(handles.Apply_changes_btt,'visible','off');
            set(handles.cancel_btt,'String','Finish');
            set(handles.log_text,'String','EEG dataset was overwrited. Process concluded!');
            set(handles.TopText,'String','Processes concluded - Report log');
            set(handles.axes3Panel,'visible','on');
            plot_result(handles);
            fprintf(['All corrections have been executed.',10]);                 

% In case of error occured
           catch
                warndlg2('Correction process could not be concluded.','Correction of dataset');
                fprintf(['Failed.',10]); 
                fprintf(['Error processing the Correction.',10]);
           end
           
       case 'No' % Abort Apply
         return
    end

        
% Button to save Log file.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
function Save_log_file_Callback(hObject, eventdata, handles)
global log_string EEG
sugest_name = [['Berg_ArtRem_Log_',EEG.comments(16:end)],'.txt'];
[filename, pathname] = uiputfile(sugest_name, 'Save Log file');
    if isequal(filename,0) | isequal(pathname,0)
       set(handles.log_text,'String','File was not saved.');
       set(handles.FileNamePath2,'Value',0);
    else
        if get(handles.append_history_commands,'value') == 1
            log_string = [log_string, 10, 10,...
                '---------------------', 10,...
                'EEG.History Commands:', 10, EEG.history];
        end
        file_to_save = fullfile(pathname,filename);
        file_id = fopen(file_to_save,'w');
        fprintf(file_id,' %s \n', log_string);
        fclose(file_id);
        set(handles.log_text,'String','Log file was successfuly saved.');
    end


% Plot entire channels on last interface (after Correctionnnel.
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
function plot_result(handles)
global EEG ch
axes(handles.axes3);
plot(EEG.data(ch,:));
x =  get(gca, 'XTick');
set(gca,'XTickLabel', x/EEG.srate*1000);
ylabel('Threshold in [µV]:');
xlabel('Time in [ms]');






function cc_n_artifacts_value_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function cc_n_artifacts_value_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in auto_cc.
function auto_cc_Callback(hObject, eventdata, handles)
set(handles.specify_n_artifacts,'value',0);
set(handles.cc_n_artifacts_value,'enable','off');
% cc_n_artifacts_value

% --- Executes on button press in specify_n_artifacts.
function specify_n_artifacts_Callback(hObject, eventdata, handles)
set(handles.auto_cc,'value',0);
set(handles.cc_n_artifacts_value,'enable','on');




% --- Executes on button press in limit_correlation_checkbox.
function limit_correlation_checkbox_Callback(hObject, eventdata, handles)
global limit_adc_correlation
if get(handles.limit_correlation_checkbox,'value') == 1
    set(handles.ADC_correlation_drop,'Enable','on');
    if isempty(limit_adc_correlation)
        limit_adc_correlation = 100 - get(handles.ADC_correlation_drop,'value');
    end
else
    set(handles.ADC_correlation_drop,'Enable','off');
end

% --- Executes on selection change in ADC_correlation_drop.
function ADC_correlation_drop_Callback(hObject, eventdata, handles)
global limit_adc_correlation
limit_adc_correlation = 100 - get(handles.ADC_correlation_drop,'value');




% ###################################################################
% ############### Information Buttons Pop-up Messages ###############
% ###################################################################

% Step 1 - Marquers Detection
function s01m01_Callback(hObject, eventdata, handles)
help_msg( 's01m01' );
function s01m02_Callback(hObject, eventdata, handles)
help_msg( 's01m02' );

% Step 2 - Artifact Onset & Offset
function msg_s02m01_Callback(hObject, eventdata, handles)
help_msg( 's02m01' );
function msg_s02m02_Callback(hObject, eventdata, handles)
help_msg( 's02m02' );

% Step 3 - Baseline Correction
function s03m01_Callback(hObject, eventdata, handles)
help_msg( 's03m01' );
function s03m02_Callback(hObject, eventdata, handles)
help_msg( 's03m02' );
function s03m03_Callback(hObject, eventdata, handles)
help_msg( 's03m03' );
function s03m04_Callback(hObject, eventdata, handles)
help_msg( 's03m04' );

% Step 4 - Correction Methods
function s04m01_Callback(hObject, eventdata, handles)
help_msg( 's04m01' );
function s04m02_Callback(hObject, eventdata, handles)
help_msg( 's04m02' );
function s04m03_Callback(hObject, eventdata, handles)
help_msg( 's04m03' );
function s04m04_Callback(hObject, eventdata, handles)
help_msg( 's04m04' );
function s04m05_Callback(hObject, eventdata, handles)
help_msg( 's04m05' );

% Step 5 - Filtering Option
function s05m01_Callback(hObject, eventdata, handles)
help_msg( 's05m01' );
function s05m02_Callback(hObject, eventdata, handles)
help_msg( 's05m02' );

% Step 6 - Resume
function s06m01_Callback(hObject, eventdata, handles)
help_msg( 's06m01' );





