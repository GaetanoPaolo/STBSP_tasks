function varargout = GUI_BSSCCA(varargin)
% GUI_BSSCCA M-file for GUI_BSSCCA.fig
%      GUI_BSSCCA, by itself, creates a new GUI_BSSCCA or raises the existing
%      singleton*.
%
%      H = GUI_BSSCCA returns the handle to a new GUI_BSSCCA or the handle to
%      the existing singleton*.
%
%      GUI_BSSCCA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_BSSCCA.M with the given input arguments.
%
%      GUI_BSSCCA('Property','Value',...) creates a new GUI_BSSCCA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_BSSCCA_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_BSSCCA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help GUI_BSSCCA

% Last Modified by Borbala Hunyadi v3 14-Feb-2017 11:51

% new feature: can save cleaned-up EEG into EDF.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_BSSCCA_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_BSSCCA_OutputFcn, ...
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


% --- Executes just before GUI_BSSCCA is made visible.
function GUI_BSSCCA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_BSSCCA (see VARARGIN)
tic
fprintf('Start \n')
handles.fs=250;
fs=250;
handles.windowL=10;%windowlength in seconds

% cd C:\clinicalstudy\data\
% load F0148
% cd U:\Anneleen\matlab\dataformat\
% Datamatrix=signal;
% handles.filename='F0148MF';
% handles.filenrs=[1 2 4];
% handles.namescorder='vergult';
% handles.filenr=handles.filenrs(1);
% filenr=handles.filenr;

if (length(varargin) == 4 )& strcmpi(varargin{1},'Datamatrix') & strcmpi(varargin{3},'Delay')
    Datamatrix=varargin{2};
    handles.dd=varargin{4};
    handles.saving=1;
    handles.filename='dummy';
elseif (length(varargin) == 4 )& strcmpi(varargin{1},'DataStructure') & strcmpi(varargin{3},'Delay')
    handles.eegStruct=varargin{2};
    Datamatrix=varargin{2}.data;
    handles.dd=varargin{4};
    handles.saving=1;
    handles.filename='dummy';
elseif (length(varargin) == 2 )& strcmpi(varargin{1},'Datamatrix')
    Datamatrix=varargin{2};
    handles.dd=1;
    handles.saving=1;
    
    handles.filename='dummy';
elseif (length(varargin) == 2 )& strcmpi(varargin{1},'DataStructure')
    handles.eegStruct=varargin{2};
    Datamatrix=varargin{2}.data;
    handles.dd=1;
    handles.saving=1;
    
    handles.filename='dummy';
elseif  (length(varargin) == 1 )& strcmpi(varargin{1},'readEDF')
    
[FileName,PathName] = uigetfile('*.edf','Select an EEG file','MultiSelect','off');
if isequal(FileName,0)
    return
end
if isequal(FileName,0)
    return;
end

handles.eegFile=FileName;
    [eegRaw,header] = readEDF([PathName,FileName]);
    ecg=find(strcmp(header.labels,'ECG'));
    handles.header=header;
    handles.eegStruct.data=cell2mat(eegRaw)'; handles.ecg=handles.eegStruct.data(ecg,:); handles.eegStruct.data(ecg,:)=[];
    handles.eegStruct.srate=header.samplerate(1);
    handles.eegStruct.nbchan=header.channels;
    
    Datamatrix=handles.eegStruct.data;
    handles.dd=1;
    handles.saving=1;
    
    handles.filename='dummy';
else
    errordlg('Not enough input parameters','Not enough input parameters')
end


%filtering van datamatrix (notch+bandpass)
for pgs=1:floor(size(Datamatrix,2)/(handles.fs*handles.windowL))
    samples=handles.fs*handles.windowL;
    datawindow=Datamatrix(:,(pgs-1)*samples+1:pgs*samples);
    [CCAdata,corrlastwith,corrfirstaway]=preproCCAslide(datawindow,handles.dd);
    corrlastplus(pgs)=corrlastwith(1);
end
handles.original=Datamatrix;
handles.current_data=Datamatrix(:,1:250*10);
handles.page_number=1;
pgsize=floor(size(Datamatrix,2)/(handles.fs*handles.windowL));
handles.pgsize=pgsize;
handles.filesc=zeros(1,23);%NEW
handles.filesc(:,1)=-1;
handles.filesc(:,4:22)=-1*ones(1,19);
handles.page_onset=0;
handles.scale=70;
handles.CCAsettings=[[1:pgsize]' ones(pgsize,1)*[70 10 -1 0 0 250] ];
handles.CCAsettings(:,5)=corrlastplus';
handles.dlf=0.3;
handles.dhf=35;
handles.notchflag=1;
handles.pagenrCCAold=0;
handles.flag_CCA=zeros(1,pgsize);
handles.corrlastwith=zeros(1,21);
handles.corrfirstaway=zeros(1,21);
handles.numberaway=0;
handles.reasonons='';
handles.reasonpat='';
handles.reasonloc='';
handles.CCAvalue=1;
handles.secondline=0;
handles.commentstext={};
handles.homedir=pwd;
% Choose default command line output for GUI_BSSCCA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_BSSCCA wait for user response (see UIRESUME)
% uiwait(handles.figure1);
slider_step(1) = 1/(pgsize-1);
slider_step(2) = 1/(pgsize-1);
set(handles.amplitude,'String',strcat(num2str(handles.scale),'uV'));
set(handles.time_slider,'sliderstep',slider_step,'max',pgsize,'min',1,'Value',1);
chsize=21;
slider_step(1) = 1/(chsize-1);
slider_step(2) = 1/(chsize-1);
set(handles.slider_CCA,'sliderstep',slider_step,'max',chsize,'min',1,'Value',1);
set(handles.page,'String',num2str(1));
set(handles.togglebutton1,'String','FP2-G19');
set(handles.togglebutton2,'String','F8-G19');
set(handles.togglebutton3,'String','T4-G19');
set(handles.togglebutton4,'String','T6-G19');
set(handles.togglebutton5,'String','O2-G19');
set(handles.togglebutton6,'String','F4-G19');
set(handles.togglebutton7,'String','C4-G19');
set(handles.togglebutton8,'String','P4-G19');
set(handles.togglebutton9,'String','FZ-G19');
set(handles.togglebutton10,'String','CZ-G19');
set(handles.togglebutton11,'String','PZ-G19');
set(handles.togglebutton12,'String','FP1-G19');
set(handles.togglebutton13,'String','F7-G19');
set(handles.togglebutton14,'String','T3-G19');
set(handles.togglebutton15,'String','T5-G19');
set(handles.togglebutton16,'String','O1-G19');
set(handles.togglebutton17,'String','F3-G19');
set(handles.togglebutton18,'String','C3-G19');
set(handles.togglebutton19,'String','P3-G19');
set(handles.togglebutton20,'String','T2-G19');
set(handles.togglebutton21,'String','T1-G19');

 datacreateplot(handles.original,1,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);
CCAsettings=zeros(pgsize,7);
CCAinfo=['page' 'scale' 'windowL' 'amount components away' 'corrlastwith' 'corrfirstaway' 'fs'];
save(strcat(handles.homedir,'\',handles.filename,'_CCAhulpsettings'),'CCAsettings','CCAinfo')
save(strcat(handles.homedir,'\',handles.filename,'_CCAdefinitesettings'),'CCAsettings','CCAinfo')
% --- Outputs from this function are returned to the command line.
function varargout = GUI_BSSCCA_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on slider movement.
function time_slider_Callback(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%%set all question values/slider back to saved ones
pg = get(handles.time_slider,'Value');
page_number= round(2*pg)/2;
set(hObject,'Value',page_number);
halfpage=1-(page_number==round(page_number));
if halfpage
    set([handles.slider_CCA handles.push_saveCCA],'Enable','off');
    set(handles.nr_last,'String','X');
else
    set([handles.slider_CCA handles.push_saveCCA],'Enable','on');
end

%%pageshift & CCA calculation
handles.page_number=page_number;

%Switch: normal or CCA?
button_state = get(handles.toggle_switch,'Value');
if button_state == get(handles.toggle_switch,'Max')
    % toggle button is pressed=>normal
    set(handles.text3,'String',{'Muscle filter:' 'OFF'})
    set(hObject,'String','Switch N->F')
    handles.current_data=datacreateplot(handles.original,handles.page_number,handles.scale,handles.windowL,0,0,0,handles.fs,[],0);
     datacreateplot(handles.original,handles.page_number,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);
    set(handles.slider_CCA,'Value',0+1);
    set(handles.nr_last,'String',strcat(num2str(0),'/',num2str(21)));
elseif button_state == get(handles.toggle_switch,'Min')%=>CCA
    set(handles.text3,'String',{'Muscle filter:' 'ON'})
    set(hObject,'String','Switch F->N')
    %set EEG to CCAvalue that was saved
    load(strcat(handles.homedir,'\',handles.filename,'_CCAdefinitesettings'))
    handles=plotwithCCA(handles,halfpage, CCAsettings, page_number);
end

set(handles.page,'String',num2str(floor(page_number)));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function time_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in push_min.
function push_min_Callback(hObject, eventdata, handles)
% hObject    handle to push_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_scale=scale_switch(handles.scale,-1);
handles.scale=new_scale;
set(handles.amplitude,'String',strcat(num2str(handles.scale),'uV'));
%no create_data and plot, because data stays the same only scale of
%the figure changes
figure(handles.figure1)
if handles.page_number==round(handles.page_number)%wholepage
     datacreateplot(handles.current_data,1,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);
else %halfpage
     datacreateplot([zeros(21,250*5) handles.current_data],1.5,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);
end
%eegplot(handles.current_data,meas21osg,handles.scale,'b',0);

guidata(hObject,handles);

% --- Executes on button press in push_plus.
function push_plus_Callback(hObject, eventdata, handles)
% hObject    handle to push_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_scale=scale_switch(handles.scale,1);
handles.scale=new_scale;
set(handles.amplitude,'String',strcat(num2str(handles.scale),'uV'));
%no create_data and plot, because data stays the same only scale of
%the figure changes
figure(handles.figure1)
if handles.page_number==round(handles.page_number)%wholepage
     datacreateplot(handles.current_data,1,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);%eegplot(handles.current_data,meas21osg,handles.scale,'b',0);
else %halfpage
     datacreateplot([zeros(21,250*5) handles.current_data],1.5,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);%eegplot(handles.current_data,meas21osg,handles.scale,'b',0);
end

guidata(hObject,handles);

% --- Executes on button press in push_def.
function push_def_Callback(hObject, eventdata, handles)
% hObject    handle to push_def (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scale=70;
set(handles.amplitude,'String',strcat(num2str(handles.scale),'uV'));
%no create_data and plot, because data stays the same only scale of
%the figure changes
figure(handles.figure1)
if handles.page_number==round(handles.page_number)%wholepage
     datacreateplot(handles.current_data,1,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);
else %half page
     datacreateplot([zeros(21,250*5) handles.current_data],1.5,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);
end
%eegplot(handles.current_data,meas21osg,handles.scale,'b',0);


guidata(hObject,handles);

% --- Executes on slider movement.
function slider_CCA_Callback(hObject, eventdata, handles)
% hObject    handle to slider_CCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

CCAval=round(get(hObject,'Value'));%amount of components to eliminate - 1
set(hObject,'Value',CCAval);
handles.CCAvalue=CCAval;

if handles.pagenrCCAold==handles.page_number;%old CCAmatrix can be used
else %new CCAmatrix must be made
    samples=handles.fs*handles.windowL;
    datawindow=handles.original(:,(handles.page_number-1)*samples+1:handles.page_number*samples);
    [handles.CCAdata,handles.corrlastwith,handles.corrfirstaway]=preproCCAslide(datawindow,handles.dd);
    handles.pagenrCCAold=handles.page_number;
end

handles.current_data=handles.CCAdata{CCAval};
figure(handles.figure1)
fullpage=(handles.page_number==floor(handles.page_number));
 datacreateplot(handles.current_data,0,handles.scale,handles.windowL,1,35,0.3,handles.fs,handles.figure1,0);
if handles.page_number==handles.page_onset& handles.page_number==handles.filesc(1,15)
    hold on
    line('XData',[handles.ons handles.ons],'YData',[0 100],'Color','red')
    hold off
end
set(handles.nr_last,'String',strcat(num2str(CCAval-1),'/',num2str(21)));
load(strcat(handles.homedir,'\',handles.filename,'_CCAhulpsettings'))
CCAsettings(handles.page_number,:)=[handles.page_number handles.scale handles.windowL CCAval-1 handles.corrlastwith(CCAval)  handles.corrfirstaway(CCAval) handles.fs];
CCAinfo=['page' 'scale' 'windowL' 'amount components away' 'corrlastwith' 'corrfirstaway' 'fs'];
save(strcat(handles.homedir,'\',handles.filename,'_CCAhulpsettings'),'CCAsettings','CCAinfo','-append')
set(handles.toggle_switch,'String','Switch F->N','Value',0)
set(handles.text3,'String',{'Muscle filter:' 'ON'})

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider_CCA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_CCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in push_saveCCA.
function push_saveCCA_Callback(hObject, eventdata, handles)
% hObject    handle to push_saveCCA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CCAval=handles.CCAvalue;%amount of components to eliminate - 1
load(strcat(handles.homedir,'\',handles.filename,'_CCAdefinitesettings'))

handles.CCAsettings(handles.page_number,:)=[handles.page_number handles.scale handles.windowL CCAval-1 handles.corrlastwith(CCAval)  handles.corrfirstaway(CCAval) handles.fs];
CCAsettings=handles.CCAsettings;
CCAinfo=['page' 'scale' 'windowL' 'amount components away' 'corrlastwith' 'corrfirstaway' 'fs'];
save(strcat(handles.homedir,'\',handles.filename,'_CCAdefinitesettings'),'CCAsettings','CCAinfo','-append')
if round(handles.page_number)==handles.page_number%NEW
    handles.flag_CCA(1,handles.page_number)=1;%NEW
end%NEW

guidata(hObject,handles);

% --- Executes on button press in toggle_switch.
function toggle_switch_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_switch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_switch
button_state = get(hObject,'Value');
if button_state == get(hObject,'Max')
    % toggle button is pressed=>normal
    set(handles.text3,'String',{'Muscle filter:' 'OFF'})
    set(hObject,'String','Switch N->F')
    set(handles.slider_CCA,'Value',0+1);
    set(handles.nr_last,'String',strcat(num2str(0),'/',num2str(21)));
    figure(handles.figure1)
    handles.current_data=datacreateplot(handles.original,handles.page_number,handles.scale,handles.windowL,0,0,0,handles.fs,[],0);
     datacreateplot(handles.original,handles.page_number,handles.scale,handles.windowL,1,35,0.3,handles.fs,handles.figure1,0);
elseif button_state == get(hObject,'Min')%=>CCA
    set(handles.text3,'String',{'Muscle filter:' 'ON'})
    set(hObject,'String','Switch F->N')
    figure(handles.figure1)
    if handles.pagenrCCAold==handles.page_number;%old CCAmatrix can be used+unsaved setting must be used (always for whole pages, else pagenrCCAold==-1)
        CCAval=handles.CCAvalue;
        set(handles.slider_CCA,'Value',CCAval);
        set(handles.nr_last,'String',strcat(num2str(CCAval-1),'/',num2str(21)));
        handles.current_data=handles.CCAdata{CCAval};
         datacreateplot(handles.current_data,1,handles.scale,handles.windowL,1,35,0.3,handles.fs,handles.figure1,0);
    else %new CCAmatrix must be made
        halfpage=1-(handles.page_number==round(handles.page_number));
        load(strcat(handles.homedir,'\',handles.filename,'_CCAdefinitesettings'))
        handles=plotwithCCA(handles,halfpage, CCAsettings, handles.page_number);
    end
end

guidata(hObject,handles);


% --- Executes on button press in minhalfpage.
function minhalfpage_Callback(hObject, eventdata, handles)
% hObject    handle to minhalfpage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
page_number =max(1, get(handles.time_slider,'Value')-1/2);
handles.page_number=page_number;

halfpage=1-(page_number==round(page_number));
if halfpage
    set([handles.slider_CCA handles.push_saveCCA],'Enable','off');
    set(handles.nr_last,'String','X');
else
    set([handles.slider_CCA handles.push_saveCCA],'Enable','on');
end
%Switch: normal or CCA?
button_state = get(handles.toggle_switch,'Value');
if button_state == get(handles.toggle_switch,'Max')
    % toggle button is pressed=>normal
    set(handles.text3,'String',{'Muscle filter:' 'OFF'})
    set(handles.toggle_switch,'String','Switch N->F')
    handles.current_data=datacreateplot(handles.original,page_number,handles.scale,handles.windowL,0,0,0,handles.fs,[],0);
     datacreateplot(handles.original,page_number,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);
    set(handles.slider_CCA,'Value',0+1);
    set(handles.nr_last,'String',strcat(num2str(0),'/',num2str(21)));
elseif button_state == get(handles.toggle_switch,'Min')%=>CCA
    set(handles.text3,'String',{'Muscle filter:' 'ON'})
    set(handles.toggle_switch,'String','Switch F->N')
    %set EEG to CCAvalue that was saved
    load(strcat(handles.homedir,'\',handles.filename,'_CCAdefinitesettings'))
    handles=plotwithCCA(handles,halfpage, CCAsettings, page_number);
end

set(handles.page,'String',num2str(floor(page_number)));
set(handles.time_slider,'Value',page_number);
guidata(hObject,handles);


% --- Executes on button press in plushalfpage.
function plushalfpage_Callback(hObject, eventdata, handles)
% hObject    handle to plushalfpage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
page_number =min(handles.pgsize, get(handles.time_slider,'Value')+1/2);
handles.page_number=page_number;
halfpage=1-(page_number==round(page_number));
if halfpage
    set([handles.slider_CCA handles.push_saveCCA],'Enable','off');
    set(handles.nr_last,'String','X');
else
    set([handles.slider_CCA handles.push_saveCCA],'Enable','on');
end
%Switch: normal or CCA?
button_state = get(handles.toggle_switch,'Value');
if button_state == get(handles.toggle_switch,'Max')
    % toggle button is pressed=>normal
    set(handles.text3,'String',{'Muscle filter:' 'OFF'})
    set(handles.toggle_switch,'String','Switch N->F')
    handles.current_data=datacreateplot(handles.original,page_number,handles.scale,handles.windowL,0,0,0,handles.fs,[],0);
     datacreateplot(handles.original,page_number,handles.scale,handles.windowL,handles.notchflag,handles.dhf,handles.dlf,handles.fs,handles.figure1,0);
    set(handles.slider_CCA,'Value',0+1);
    set(handles.nr_last,'String',strcat(num2str(0),'/',num2str(21)));
elseif button_state == get(handles.toggle_switch,'Min')%=>CCA
    set(handles.text3,'String',{'Muscle filter:' 'ON'})
    set(handles.toggle_switch,'String','Switch F->N')
    %set EEG to CCAvalue that was saved
    load(strcat(handles.homedir,'\',handles.filename,'_CCAdefinitesettings'))
    handles=plotwithCCA(handles,halfpage, CCAsettings, page_number);
end

set(handles.page,'String',num2str(floor(page_number)));
set(handles.time_slider,'Value',page_number);
guidata(hObject,handles);

%---
function handles=plotwithCCA(handles,halfpage, CCAsettings, page_number)
if halfpage %no change in CCA settings possible
    compaway=CCAsettings([floor(page_number) ceil(page_number)],4);
    compaway=(compaway+abs(compaway))/2;%set all negative values to zero
    handles.CCAvalue=compaway+1;
    clear CCAsettings CCAinfo
    samples=handles.fs*handles.windowL;
    pgnr=0;
    while pgnr<2
        datawindow=handles.original(:,(floor(handles.page_number)+pgnr-1)*samples+1:(floor(handles.page_number)+pgnr)*samples);
        if compaway(pgnr+1)>0
            [handles.CCAdata,handles.corrlastwith,handles.corrfirstaway]=preproCCAslide(datawindow,handles.dd);
            handles.current_data(:,pgnr*samples/2+1:(pgnr+1)/2*samples)=handles.CCAdata{compaway(pgnr+1)+1}(:,(1-pgnr)/2*samples+1:(1-pgnr+1)/2*samples);
        else
            handles.current_data(:,pgnr*samples/2+1:(pgnr+1)/2*samples)=datawindow(:,(1-pgnr)/2*samples+1:(1-pgnr+1)/2*samples);
        end
        pgnr=pgnr+1;
    end
    handles.pagenrCCAold=-1;
     datacreateplot([zeros(21,samples/2) handles.current_data],1.5,handles.scale,handles.windowL,1,35,0.3,handles.fs,handles.figure1,0);
else %wholepage
    compaway=CCAsettings(page_number,4);
    compaway=(compaway+abs(compaway))/2;%set all negative values to zero
    handles.CCAvalue=compaway+1;
    clear CCAsettings CCAinfo
    set(handles.slider_CCA,'Value',compaway+1);
    set(handles.nr_last,'String',strcat(num2str(compaway),'/',num2str(21)));
    samples=handles.fs*handles.windowL;
    datawindow=handles.original(:,(handles.page_number-1)*samples+1:handles.page_number*samples);
    if compaway>0
        [handles.CCAdata,handles.corrlastwith,handles.corrfirstaway]=preproCCAslide(datawindow,handles.dd);
        handles.pagenrCCAold=handles.page_number;
        handles.current_data=handles.CCAdata{compaway+1};
         datacreateplot(handles.current_data,1,handles.scale,handles.windowL,1,35,0.3,handles.fs,handles.figure1,0);
    else
        handles.current_data=datawindow;
         datacreateplot(handles.current_data,1,handles.scale,handles.windowL,1,35,0.3,handles.fs,handles.figure1,0);
    end
end


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveCleanEEG_Callback(hObject, eventdata, handles)
% hObject    handle to saveCleanEEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fn, p]=uiputfile([cd,'*.EDF'], 'Specify a filename to save clean EEG');
try
eegStruct=handles.eegStruct;
header=handles.header;
catch
   msgbox('Cannot save EEG, as no EEG structure is specified. Call GUI_BSSCCA with the readEDF option!') 
   return;
end
eegStruct.data(:,((handles.page_number-1)*handles.windowL*handles.fs)+1:handles.page_number*handles.windowL*handles.fs)=handles.CCAdata{handles.CCAvalue};

%%%% 13/07/2017: Warning! The following lines are not stable, and depend on the EDF input format! Probably I had an
%%%% EDF+ file, which which the following 2 lines were working... Now I
%%%% added the 2 if-statements to handle a different example...

eeg=find(strncmpi(handles.header.labels,'EEG',3));
ecg=find(strncmpi(handles.header.labels,'ECG',3));
if isempty(eeg)
eeg=setdiff(1:numel(handles.header.labels),ecg); 
tmp(eeg,:)=eegStruct.data;
end
if ~isempty(ecg)
 tmp(ecg,:)=handles.ecg;
end

SaveEDF([p fn], eegStruct.data', handles.header) ;

