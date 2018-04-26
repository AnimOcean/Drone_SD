function varargout = GUIDE_FIG(varargin)
% GUIDE_FIG MATLAB code for GUIDE_FIG.fig
%      GUIDE_FIG, by itself, creates a new GUIDE_FIG or raises the existing
%      singleton*.
%
%      H = GUIDE_FIG returns the handle to a new GUIDE_FIG or the handle to
%      the existing singleton*.
%
%      GUIDE_FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDE_FIG.M with the given input arguments.
%
%      GUIDE_FIG('Property','Value',...) creates a new GUIDE_FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIDE_FIG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIDE_FIG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIDE_FIG

% Last Modified by GUIDE v2.5 19-Apr-2018 14:44:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIDE_FIG_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIDE_FIG_OutputFcn, ...
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


% --- Executes just before GUIDE_FIG is made visible.
function GUIDE_FIG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIDE_FIG (see VARARGIN)

% Choose default command line output for GUIDE_FIG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIDE_FIG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIDE_FIG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%{
clear all
close all
clc
%}
% Read and store all images, also store flipped/reversed images
cdata = flipdim( imread('transformed_stitch.JPG'), 1 );
cdatar = flipdim( cdata, 2 );

cdata2 = flipdim( imread('Top.jpg'), 1 );
cdatar2 = flipdim( cdata2, 2 );

%{
cdata3 = flipdim( imread('Top.jpg'), 1 );
cdatar3 = flipdim( cdata3, 2 );

cdata4 = flipdim( imread('Top.jpg'), 1 );
cdatar4 = flipdim( cdata4, 2 );

cdata5 = flipdim( imread('Top.jpg'), 1 );
cdatar5 = flipdim( cdata5, 2 );
%}

% for final code:
% cdata=south(front)
% cdata2=west(left)
% cdata3=east(right)
% cdata4=north(back)
% cdata5=top

% Pull size for the surfaces from front image for x and z.  Pull size from
% top image for y (depth)
[z1,x1]=size(cdata);
x1=x1/3;
y1=1000;
x1=x1;
y1=y1;
z1=z1;

assignin('base', 'x1', x1)
assignin('base', 'y1', y1)
assignin('base', 'z1', z1)


% Create solid color for bottom surface (gray)
C=[0, 0, 0];

% Create surfaces
% font (south)
surface([0 x1; 0 x1], [0 0; 0 0], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata );
% left
surface([0 0; 0 0], [0 y1; 0 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdatar );
% right
surface([x1 x1; x1 x1], [0 y1; 0 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata );
% back
surface([0 x1; 0 x1], [y1 y1; y1 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdatar );
% top
surface([0 x1; 0 x1], [0 0; y1 y1], [z1 z1; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata2 );
% bottom
surface([0 x1; 0 x1], [0 0; y1 y1], [0 0; 0 0], ...
    C);
%}
% set 3 dimensional view
view(3);

% set figure axis so it doesn't distort images
axis equal
%axis off
% pull up camera toolbar and set preferences so rotation is set by default
cameratoolbar('NoReset')
cameratoolbar('SetMode', 'orbit')







% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Read and store all images, also store flipped/reversed images
cdata = flipdim( imread('transformed_stitchbw.JPG'), 1 );
cdatar = flipdim( cdata, 2 );

cdata2 = flipdim( imread('topbw.jpg'), 1 );
cdatar2 = flipdim( cdata2, 2 );

%drawnow update



%{
cdata3 = flipdim( imread('Top.jpg'), 1 );
cdatar3 = flipdim( cdata3, 2 );

cdata4 = flipdim( imread('Top.jpg'), 1 );
cdatar4 = flipdim( cdata4, 2 );

cdata5 = flipdim( imread('Top.jpg'), 1 );
cdatar5 = flipdim( cdata5, 2 );
%}

% for final code:
% cdata=south(front)
% cdata2=west(left)
% cdata3=east(right)
% cdata4=north(back)
% cdata5=top



% Pull size for the surfaces from front image for x and z.  Pull size from
% top image for y (depth)
[z1,x1]=size(cdata);
x1=x1/3;
y1=1000;
x1=x1;
y1=y1;
z1=z1;



% Create solid color for bottom surface (gray)
C=[0, 0, 0];




% Create surfaces
% font (south)
surface([0 x1; 0 x1], [0 0; 0 0], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata );
% left
surface([0 0; 0 0], [0 y1; 0 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdatar );
% right
surface([x1 x1; x1 x1], [0 y1; 0 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata );
% back
surface([0 x1; 0 x1], [y1 y1; y1 y1], [0 0; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdatar );
% top
surface([0 x1; 0 x1], [0 0; y1 y1], [z1 z1; z1 z1], ...
    'FaceColor', 'texturemap', 'CData', cdata2 );
% bottom
surface([0 x1; 0 x1], [0 0; y1 y1], [0 0; 0 0], ...
    C);
%}
% set 3 dimensional view
view(3);

% set figure axis so it doesn't distort images
axis equal
%axis off
% pull up camera toolbar and set preferences so rotation is set by default
cameratoolbar('NoReset')
cameratoolbar('SetMode', 'orbit')


