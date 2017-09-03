function varargout = gui(varargin)
    % GUI MATLAB code for gui.fig
    %      GUI, by itself, creates a new GUI or raises the existing
    %      singleton*.
    %
    %      H = GUI returns the handle to a new GUI or the handle to
    %      the existing singleton*.
    %
    %      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in GUI.M with the given input arguments.
    %
    %      GUI('Property','Value',...) creates a new GUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before gui_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to gui_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help gui

    % Last Modified by GUIDE v2.5 03-Sep-2017 22:45:59

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @gui_OpeningFcn, ...
                       'gui_OutputFcn',  @gui_OutputFcn, ...
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

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to gui (see VARARGIN)

    % Choose default command line output for gui
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes gui wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end


% --- Executes on button press in button_exit.
function button_exit_Callback(hObject, eventdata, handles)
% hObject    handle to button_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global exit;
    exit = true;
end


% --- Executes on button press in vacuum_toggle.
function vacuum_toggle_Callback(hObject, eventdata, handles)
    global ui;
    ui.setIOs = ui.IOs;
    ui.setIOs(1) = ~ui.IOs(1);
    ui.IOs = ui.setIOs;
    ui.commandQueue = [ui.commandQueue, 1];
% hObject    handle to vacuum_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in solenoid_toggle.
function solenoid_toggle_Callback(hObject, eventdata, handles)
    global ui;
    ui.setIOs = ui.IOs;
    ui.setIOs(2) = ~ui.IOs(2);
    ui.IOs = ui.setIOs;
    ui.commandQueue = [ui.commandQueue, 1];
% hObject    handle to solenoid_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
end

% --- Executes on button press in toggle_conveyor.
function toggle_conveyor_Callback(hObject, eventdata, handles)
    global ui;
    ui.setIOs = ui.IOs;
    ui.setIOs(3) = ~ui.IOs(3);
    ui.IOs = ui.setIOs;
    ui.commandQueue = [ui.commandQueue, 1];
% hObject    handle to toggle_conveyor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_conveyor
end

% --- Executes on button press in toggle_conveyor_dir.
function toggle_conveyor_dir_Callback(hObject, eventdata, handles)
    global ui;
    ui.setIOs = ui.IOs;
    ui.setIOs(4) = ~ui.IOs(4);
    ui.IOs = ui.setIOs;
    ui.commandQueue = [ui.commandQueue, 1];
% hObject    handle to toggle_conveyor_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end



function set_pose_x_Callback(hObject, eventdata, handles)

    global ui;
    ui.setPose(1) = str2double(get(hObject,'String'));
% hObject    handle to set_pose_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of set_pose_x as text
%        str2double(get(hObject,'String')) returns contents of set_pose_x as a double
end

% --- Executes during object creation, after setting all properties.
function set_pose_x_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_pose_x (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function set_pose_y_Callback(hObject, eventdata, handles)
    global ui;
    ui.setPose(2) = str2double(get(hObject,'String'));
% hObject    handle to set_pose_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of set_pose_y as text
%        str2double(get(hObject,'String')) returns contents of set_pose_y as a double
end

% --- Executes during object creation, after setting all properties.
function set_pose_y_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_pose_y (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function set_pose_z_Callback(hObject, eventdata, handles)
    global ui;
    ui.setPose(3) = str2double(get(hObject,'String'));
% hObject    handle to set_pose_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of set_pose_z as text
%        str2double(get(hObject,'String')) returns contents of set_pose_z as a double
end

% --- Executes during object creation, after setting all properties.
function set_pose_z_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_pose_z (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


function set_pose_theta_Callback(hObject, eventdata, handles)
    global ui;
    ui.setPose(4) = str2double(get(hObject,'String'));
% hObject    handle to set_pose_theta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of set_pose_theta as text
%        str2double(get(hObject,'String')) returns contents of set_pose_theta as a double
end

% --- Executes during object creation, after setting all properties.
function set_pose_theta_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to set_pose_theta (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in send_pose.
function send_pose_Callback(hObject, eventdata, handles)
    global ui;
    ui.commandQueue = [ui.commandQueue, 2];
% hObject    handle to send_pose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in connect_tcp.
function connect_tcp_Callback(hObject, eventdata, handles)
% hObject    handle to connect_tcp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.robotTCP.openTCP('127.0.0.1', 1025);
            
    %disable connect button
    if(ui.robotTCP.connected)
        set(handles.connect_tcp,'Enable','off');
        set(handles.connect_tcp,'String','Connected'); 
    end
end


% --- Executes on button press in choosePoint_table.
function choosePoint_table_Callback(hObject, eventdata, handles)
% hObject    handle to choosePoint_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    %figure(handles.camera_table);
    [x, y] = getpts(handles.camera_table);
    ui.setPose(1) = x(end)
    ui.setPose(2) = y(end)
end

% --- Executes on button press in choosePoint_conveyor.
function choosePoint_conveyor_Callback(hObject, eventdata, handles)
    global ui;

    [x, y] = getpts(handles.camera_conveyor);
    ui.setPose(1) = x(end)
    ui.setPose(2) = y(end)
% hObject    handle to choosePoint_conveyor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on selection change in command_history.
function command_history_Callback(hObject, eventdata, handles)
    % hObject    handle to command_history (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns command_history contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from command_history
end

% --- Executes during object creation, after setting all properties.
function command_history_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to command_history (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: listbox controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end
