function varargout = qwirklegui(varargin)
% QWIRKLEGUI MATLAB code for qwirklegui.fig
%      QWIRKLEGUI, by itself, creates a new QWIRKLEGUI or raises the existing
%      singleton*.
%
%      H = QWIRKLEGUI returns the handle to a new QWIRKLEGUI or the handle to
%      the existing singleton*.
%
%      QWIRKLEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QWIRKLEGUI.M with the given input arguments.
%
%      QWIRKLEGUI('Property','Value',...) creates a new QWIRKLEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before qwirklegui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to qwirklegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help qwirklegui

% Last Modified by GUIDE v2.5 07-Nov-2017 19:11:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @qwirklegui_OpeningFcn, ...
                   'gui_OutputFcn',  @qwirklegui_OutputFcn, ...
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


% --- Executes just before qwirklegui is made visible.
function qwirklegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to qwirklegui (see VARARGIN)

% Choose default command line output for qwirklegui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes qwirklegui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = qwirklegui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load_Conveyor.
function Load_Conveyor_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Conveyor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in PlayQwirkle.
function PlayQwirkle_Callback(hObject, eventdata, handles)
% hObject    handle to PlayQwirkle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
QwirkleClient;
