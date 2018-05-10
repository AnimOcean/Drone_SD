function varargout = FinalGui(varargin)
% FINALGUI MATLAB code for FinalGui.fig
%      FINALGUI, by itself, creates a new FINALGUI or raises the existing
%      singleton*.
%
%      H = FINALGUI returns the handle to a new FINALGUI or the handle to
%      the existing singleton*.
%
%      FINALGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALGUI.M with the given input arguments.
%
%      FINALGUI('Property','Value',...) creates a new FINALGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FinalGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FinalGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FinalGui

% Last Modified by GUIDE v2.5 10-May-2018 15:08:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FinalGui_OpeningFcn, ...
                   'gui_OutputFcn',  @FinalGui_OutputFcn, ...
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


% --- Executes just before FinalGui is made visible.
function FinalGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FinalGui (see VARARGIN)

% Choose default command line output for FinalGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FinalGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FinalGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ProgramConfiguration.
function ProgramConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to ProgramConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in GenerateModel.
function GenerateModel_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SelectArea.
function SelectArea_Callback(hObject, eventdata, handles)
% hObject    handle to SelectArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RGB.
function RGB_Callback(hObject, eventdata, handles)
% hObject    handle to RGB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RGB


% --- Executes on button press in UnalteredIR.
function UnalteredIR_Callback(hObject, eventdata, handles)
% hObject    handle to UnalteredIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UnalteredIR


% --- Executes on button press in HotspotIR.
function HotspotIR_Callback(hObject, eventdata, handles)
% hObject    handle to HotspotIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HotspotIR


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in SingleWall.
function SingleWall_Callback(hObject, eventdata, handles)
% hObject    handle to SingleWall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SingleWall


% --- Executes on selection change in BuildingSide.
function BuildingSide_Callback(hObject, eventdata, handles)
% hObject    handle to BuildingSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BuildingSide contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BuildingSide


% --- Executes during object creation, after setting all properties.
function BuildingSide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BuildingSide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
% hObject    handle to Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in EmmisivityMenu.
function EmmisivityMenu_Callback(hObject, eventdata, handles)
% hObject    handle to EmmisivityMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns EmmisivityMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EmmisivityMenu


% --- Executes during object creation, after setting all properties.
function EmmisivityMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EmmisivityMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
