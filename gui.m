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

    % Last Modified by GUIDE v2.5 14-Nov-2017 18:06:21

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
        %% %%%TESTING PICK AND PLACE %%%%
        
        
    %%%%%% DELETE THIS --- ITS JUST FOR TESTING PICK AND PLACE %%%
    disp('replace');
   
    
    for player = 1:2
        for i = 1:6
            ui.playGame.replacePiece(player, i);
            ui.blockIndex = ui.blockIndex+1;
        end
    end

    
    

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


    [x, y] = ginput(1);
    M = undistortPoints([x,y], ui.tableParams)
    x = M(1,1);
    y = M(1,2);
    z = 0;
    y =1200 - y;
    if(x>1600) || (y>1200) || (x<0) || (y<0)
        x = NaN;
        y = NaN;
        z = NaN;
    end
    
    pxToMM = 0.659375;
    
    tableXoffsetPx = 800; 
    tableYoffsetPx = 1178;
    
    RobFramey = (x - tableXoffsetPx)*pxToMM;
    RobFramex = (-y + tableYoffsetPx)*pxToMM;    
    
    ui.setPose(1) = RobFramex;
    ui.setPose(2) = RobFramey;
    ui.setPose(3) = 147+12;
    
    
    set(ui.clientGUIData.set_pose_x, 'String', num2str(RobFramex));
    set(ui.clientGUIData.set_pose_y, 'String', num2str(RobFramey));
    set(ui.clientGUIData.set_pose_z, 'String', num2str(187));
end

% --- Executes on button press in choosePoint_conveyor.
function choosePoint_conveyor_Callback(hObject, eventdata, handles)
% hObject    handle to choosePoint_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;

    [x, y] = ginput(1);
    M = undistortPoints([x,y], ui.conveyorParams);
    x = M(1,1);
    y = M(1,2);
    z = 10;
    y =1200 - y;
    if(x>1600) || (y>1200) || (x<0) || (y<0)
        x = NaN;
        y = NaN;
        z = NaN;
    end
    
    conveyorOffsetXPx = 215;
    conveyorOffsetYPx = 683;
    
    pxToMM = 0.659375;
    
    RobFramey = (x - conveyorOffsetXPx)*pxToMM-8;
    RobFramex = (-y + conveyorOffsetYPx)*pxToMM-12;
    RobFramez = 40;
    ui.setPose(1) = RobFramex;
    ui.setPose(2) = RobFramey;
    ui.setPose(3) = RobFramez;
    

    set(ui.clientGUIData.set_pose_x, 'String', num2str(RobFramex));
    set(ui.clientGUIData.set_pose_y, 'String', num2str(RobFramey));
    set(ui.clientGUIData.set_pose_z, 'String', num2str(RobFramez));
end


% --- Executes on button press in jog_x_minus.
function jog_x_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_x_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 2;
    ui.commandQueue = [ui.commandQueue, 3];
    
    
end

% --- Executes on button press in jog_x_plus.
function jog_x_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_x_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 1;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_y_minus.
function jog_y_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_y_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 4;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_y_plus.
function jog_y_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_y_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 3;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_z_minus.
function jog_z_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_z_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 6;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_z_plus.
function jog_z_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_z_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 5;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j1_minus.
function jog_j1_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j1_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 8;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j1_plus.
function jog_j1_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j1_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 7;
    ui.commandQueue = [ui.commandQueue, 3];
    
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


% --- Executes on button press in jog_j2_minus.
function jog_j2_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j2_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 10;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j2_plus.
function jog_j2_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j2_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 9;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j3_minus.
function jog_j3_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j3_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 12;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j3_plus.
function jog_j3_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j3_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 11;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j4_minus.
function jog_j4_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j4_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 14;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j4_plus.
function jog_j4_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j4_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 13;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j5_minus.
function jog_j5_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j5_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 16;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j5_plus.
function jog_j5_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j5_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.commandQueue = [ui.commandQueue, 3];
    ui.setJOG = 15;
end

% --- Executes on button press in jog_j6_minus.
function jog_j6_minus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j6_minus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setJOG = 18;
    ui.commandQueue = [ui.commandQueue, 3];
    
end

% --- Executes on button press in jog_j6_plus.
function jog_j6_plus_Callback(hObject, eventdata, handles)
% hObject    handle to jog_j6_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.commandQueue = [ui.commandQueue, 3];
    ui.setJOG = 17;
end


% --- Executes on button press in motion_joint.
function motion_joint_Callback(hObject, eventdata, handles)
% hObject    handle to motion_joint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setMotionMode = 0;
    ui.commandQueue = [ui.commandQueue, 4];
    
    set(ui.clientGUIData.motion_linear, 'Value', 0);
% Hint: get(hObject,'Value') returns toggle state of motion_joint
end


% --- Executes on button press in motion_linear.
function motion_linear_Callback(hObject, eventdata, handles)
    global ui;
    ui.setMotionMode = 1;
    ui.commandQueue = [ui.commandQueue, 4];
    
    set(ui.clientGUIData.motion_joint, 'Value', 0);
% hObject    handle to motion_linear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of motion_linear
end


% --- Executes on slider movement.
function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.setSpeed = get(hObject,'Value');
    ui.commandQueue = [ui.commandQueue, 5];
    
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end

% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


% --- Executes on button press in start_stop.
function start_stop_Callback(hObject, eventdata, handles)
    global ui;
    ui.setStop = get(hObject,'Value');
    ui.commandQueue = [ui.commandQueue, 6];
% hObject    handle to start_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start_stop
end


% --- Executes on button press in detect_blocks.
function detect_blocks_Callback(hObject, eventdata, handles)

    global ui;
    ui.detectBlocks = get(hObject,'Value');
    disp(ui.detectBlocks);
    if(ui.detectBlocks == 0)
        delete(ui.h_textTable);
        delete(ui.h_textConveyor);
    end
% hObject    handle to detect_blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of detect_blocks
end


% --- Executes on button press in detect_box.
function detect_box_Callback(hObject, eventdata, handles)
% hObject    handle to detect_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ui;
    ui.detectBox = get(hObject,'Value');
    disp(ui.detectBlocks);
    if(ui.detectBox == 0)
        delete(ui.h_textConveyor);
    end
% Hint: get(hObject,'Value') returns toggle state of detect_box
end


% --- Executes on button press in load_conveyor_box.
function load_conveyor_box_Callback(hObject, eventdata, handles)
    
% hObject    handle to load_conveyor_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ui;
    if(ui.conveyorDirection == 1)
        ui.conveyorDirection = 0;
    else
        ui.conveyorDirection = 1;
    end
    ui.commandQueue = [ui.commandQueue, 10];



end

%%
%%Qwirkle CallBacks
% --- Executes on button press in make_qwirkle_move.
function make_qwirkle_move_Callback(hObject, eventdata, handles)
% hObject    handle to make_qwirkle_move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
   % ui.playGame.placePiece(ui.Player,str2num(get(handles.q_piece,'String')), [str2num(get(handles.q_col,'String')),str2num(get(handles.q_row,'String'))]);
    [ui.P1GamePieces,ui.P2GamePieces] = updateGameState(ui.tableRGB);
    guiEnable(handles, 0);
    PieceNum = str2num(get(handles.q_piece,'String'));
    X = str2num(get(handles.q_col,'String'));
    Y = str2num(get(handles.q_row,'String'));
    
    ui.Player = 1;
    if(ui.Player == 1)
        Valid = isMoveValid(ui.P1GamePieces(PieceNum,:),X,Y,ui.Board)
        if ui.emptyboard == 1
           Valid = true;
           ui.emptyboard = 0;
        end
    elseif(ui.Player == 2)
        Valid = isMoveValid(ui.P2GamePieces(PieceNum,:),X,Y,ui.Board)
    end
    
    if Valid == true
        if(ui.Player == 1)
            %Grab the piece
            MovingPiece = ui.P1GamePieces(PieceNum,:);
            ui.P1GamePieces(PieceNum,:) = [0 0];
            %%Place Piece
            ui.Board(X,Y,:) = MovingPiece;
            
            %Robot Action
            ui.playGame.placePiece(ui.Player, PieceNum, [X, Y]);
            ui.playGame.replacePiece(ui.Player,PieceNum);
            
            %Calculate Score
            [TotalScore,~,~] = CalculateMoveScore(ui.Board,MovingPiece,X,Y);
            %Update Score and Action
            ui.P1TotalScore = ui.P1TotalScore + TotalScore;
            ui.P1Action = sprintf('Piece %d to [%d ,%d]',PieceNum,X,Y);
            ui.P2Action = sprintf('Your Turn');
            %%Change Player
            ui.Player = 2;
        elseif(ui.Player == 2)
            %Grab the piece
            MovingPiece = ui.P2GamePieces(PieceNum,:);
            ui.P2GamePieces(PieceNum,:) = [0 0];
            %%Place Piece
            ui.Board(X,Y,:) = MovingPiece;
            
            %Robot Action
            ui.playGame.placePiece(ui.Player, PieceNum, [X, Y]);
            ui.playGame.replacePiece(ui.Player,PieceNum);
            
            %Calculate Score
            [TotalScore,~,~] = CalculateMoveScore(ui.Board,MovingPiece,X,Y);
            %Update Score and Action
            ui.P2TotalScore = ui.P2TotalScore + TotalScore;
            ui.P2Action = sprintf('Piece %d to [%d ,%d]',PieceNum,X,Y);
            ui.P1Action = sprintf('Your Turn');
            %%Change Player
            ui.Player = 1;
        end
 
        Game_Interface;
        %pause(20);
        [ui.P1GamePieces,ui.P2GamePieces] = updateGameState(ui.tableRGB);
        Game_Interface;
        AI = get(handles.ai_enable,'Value');
        if (AI == 1 && ui.Player == 2)
            [PieceNum,X,Y] = QwirkleAI(ui.Board,ui.P2GamePieces);
            if PieceNum == 0
                %SWAP ALL PIECES
                ui.P2GamePieces = zeros(6,2);
                ui.playGame.swapPieces(ui.Player);
            else
                %Grab the piece
                MovingPiece = ui.P2GamePieces(PieceNum,:);
                ui.P2GamePieces(PieceNum,:) = [0 0];
                %%Place Piece
                ui.Board(X,Y,:) = MovingPiece;

                %Robot Action
                ui.playGame.placePiece(ui.Player, PieceNum, [X, Y]);
                ui.playGame.replacePiece(ui.Player,PieceNum);

                %Calculate Score
                [TotalScore,~,~] = CalculateMoveScore(ui.Board,MovingPiece,X,Y);
                %Update Score and Action
                ui.P2TotalScore = ui.P2TotalScore + TotalScore;
                ui.P2Action = sprintf('Piece %d to [%d ,%d]',PieceNum,X,Y);
                ui.P1Action = sprintf('Your Turn');
            
            end
           %%Change Player
           ui.Player = 1;
           Game_Interface;
           %pause(20); 
           [ui.P1GamePieces,ui.P2GamePieces] = updateGameState(ui.tableRGB);
           Game_Interface;
        end
    else
        set(handles.qwirkle_errors,'String','INVALID MOVE');
    end
    
    guiEnable(handles,1);
end


% --- Executes on button press in play_quirkle.
function play_quirkle_Callback(hObject, eventdata, handles)
% hObject    handle to play_quirkle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    ui.Board = zeros(9,9,2);
    ui.Player = 1;
    ui.P1Action = 'Waiting';
    ui.P2Action = 'Waiting';
    ui.P1TotalScore = 0;
    ui.P2TotalScore = 0;
    
    [ui.P1GamePieces,ui.P2GamePieces] = updateGameState(ui.tableRGB);
    ui.emptyboard = 1;
    
    ui.findNewBlocks = 1;
    ui.blockIndex = 1;
    
    %for player = 1:2
    %    for p=1:6
    %        ui.playGame.replacePiece(player, p);
    %        ui.findNewBlocks = 0;
    %        ui.blockIndex = ui.blockIndex +1;
    %    end
    %end
end

% leave empty
function q_col_Callback(hObject, eventdata, handles)
% hObject    handle to q_col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q_col as text
%        str2double(get(hObject,'String')) returns contents of q_col as a double
end

% --- Executes during object creation, after setting all properties.
%leave emepty
function q_col_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q_col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

%leave emepty
function q_row_Callback(hObject, eventdata, handles)
% hObject    handle to q_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q_row as text
%        str2double(get(hObject,'String')) returns contents of q_row as a double
end

% --- Executes during object creation, after setting all properties.
%leave emepty
function q_row_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in swap_piece.
function swap_piece_Callback(hObject, eventdata, handles)
% hObject    handle to swap_piece (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ui;
    guiEnable(handles, 0);
    ui.playGame.swapPieces(ui.Player);   
    pause(20);
    guiEnable(handles,1);
end


function q_piece_Callback(hObject, eventdata, handles)
% hObject    handle to q_piece (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q_piece as text
%        str2double(get(hObject,'String')) returns contents of q_piece as a double
end

% --- Executes during object creation, after setting all properties.
function q_piece_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q_piece (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in clean_table.
function clean_table_Callback(hObject, eventdata, handles)
% hObject    handle to clean_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    guiEnable(handles, 0);
    ui.playGame.cleanTable();
    %pause(20);
    guiEnable(handles,1);
end

% --- Executes on button press in sort_decks.
function sort_decks_Callback(hObject, eventdata, handles)
% hObject    handle to sort_decks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global ui;
    guiEnable(handles, 0);
    ui.playGame.sortDecks();
    guiEnable(handles,1);
end

% --- Executes on button press in pvp.
function pvp_Callback(hObject, eventdata, handles)
% hObject    handle to pvp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of pvp
    global ui;
    ui.commandQueue = [ui.commandQueue, 4];
    set(ui.clientGUIData.ai_enable, 'Value', 0);
end

% --- Executes on button press in ai_enable.
function ai_enable_Callback(hObject, eventdata, handles)
% hObject    handle to ai_enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of ai_enable
    global ui;
    ui.commandQueue = [ui.commandQueue, 4];
    set(ui.clientGUIData.pvp, 'Value', 0);
end

%takes in a 1 to enable the gui, 0 to disable
function guiEnable(handles, enable)
    if(enable)
        set(handles.swap_piece,'Enable','on')
        set(handles.play_quirkle,'Enable','on') 
        set(handles.load_conveyor_box,'Enable','on') 
        set(handles.clean_table,'Enable','on') 
        set(handles.sort_decks,'Enable','on') 
        set(handles.pvp,'Enable','on') 
        set(handles.ai_enable,'Enable','on') 
    else
        set(handles.swap_piece,'Enable','off')
        set(handles.play_quirkle,'Enable','off') 
        set(handles.load_conveyor_box,'Enable','off') 
        set(handles.clean_table,'Enable','off') 
        set(handles.sort_decks,'Enable','off') 
        set(handles.pvp,'Enable','off') 
        set(handles.ai_enable,'Enable','off') 
    end
        
end


% --- Executes on button press in complete_turn.
function complete_turn_Callback(hObject, eventdata, handles)
    global ui;
    if(ui.Player == 1)
        ui.Player = 2;
    else
        ui.Player = 1;
    end
    %ui
% hObject    handle to complete_turn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in pick_up.
function pick_up_Callback(hObject, eventdata, handles)

% hObject    handle to pick_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in place.
function place_Callback(hObject, eventdata, handles)
% hObject    handle to place (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end