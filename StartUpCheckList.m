function varargout = StartUpCheckList(varargin)
% STARTUPCHECKLIST MATLAB code for StartUpCheckList.fig
%      STARTUPCHECKLIST, by itself, creates a new STARTUPCHECKLIST or raises the existing
%      singleton*.
%
%      H = STARTUPCHECKLIST returns the handle to a new STARTUPCHECKLIST or the handle to
%      the existing singleton*.
%
%      STARTUPCHECKLIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STARTUPCHECKLIST.M with the given input arguments.
%
%      STARTUPCHECKLIST('Property','Value',...) creates a new STARTUPCHECKLIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StartUpCheckList_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StartUpCheckList_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StartUpCheckList

% Last Modified by GUIDE v2.5 02-Sep-2017 18:33:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StartUpCheckList_OpeningFcn, ...
                   'gui_OutputFcn',  @StartUpCheckList_OutputFcn, ...
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
end

% --- Executes just before StartUpCheckList is made visible.
function StartUpCheckList_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StartUpCheckList (see VARARGIN)

% Choose default command line output for StartUpCheckList
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StartUpCheckList wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = StartUpCheckList_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global checklist_complete;
checklist_complete = true;
disp('CheckList is TRUE');
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end