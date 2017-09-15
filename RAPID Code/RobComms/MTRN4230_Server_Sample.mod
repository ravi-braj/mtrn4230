MODULE MTRN4230_Server_Sample   
!      Module Function: This is the primary communications module for the RobComms Task. It establishes and maintains a TCP connection with the
!      MATLAB client running a Stop and Wait protocol. RobComms waits to receive a command ID packet which is a 1 byte char. All lower case 
!      command IDs are requests for information about the robot, whilst all upper case command IDs are attempts to output to the robot.
!      The commandIDs are below:
!
!      MATLAB Requests: 'c' = Request Close Connection, 'x' = Request Safety IO States, 
!                       'p' = Request Pose (position and joints), 'i' Request IO states
!
!      MATLAB Commands: 'P' = Move robot to position, 'I' = Write to IO states, 'S' = Write to motion speed, 
!                       'M' = Write to motion mode, 'G' = Write to pause state, 'J' = Jog a given axis!  
!
!      MATLAB requests are processed locally in this module and are always given by a lower case character. MATLAB commands require
!      an output to be executed in robot studio and are given by an upper case character. For motion or IO commands, a persistent
!      command variable will be set in the RobComms task, then read and executed in the RobControl task.
!
!      Output commands are dealt with using the following process: 
!      (1) RobComms receives command and proceeds to read appropriate amount of bytes
!      (2) MATLAB sends expected amount of bytes
!      (3) RobotComms unpacks the data and sets a control_ID. This informs the RobControl task what routine it needs to execute
!      
!      Input commands are dealt with by RobComms using the following process:
!      (1) RobComms receives command and packs appropriate amount of bytes
!      (2) MATLAB waits to receive expected amount of bytes 
!      (3) MATLAB unpacks data and updates the GUI
!
!      To conclude any command ID process, MATLAB will expect a 1 byte error state response. This informs the program of whether 
!      anything is wrong with the data or state and also acknowledges that the command has been executed on the Robot Studio side. 
!      RobComms will proceed to wait until another command ID is sent from MATAB and the process repeats until the connection is closed.
!
!      Last Modified: 15/09/2017
!      Author: Daniel Castillo
!      Status: Working
	
    ! The socket connected to the client.
    VAR socketdev client_socket;
    
    ! The host and port that we will be listening for a connection on.
    !CONST string host := "192.168.125.1";  ! Robot IP Address for live communication
    CONST string host := "127.0.0.1";   ! Local Host IP for virtual communication
    CONST num port := 1025; ! Arbitrary port ID, needs to be the same as MATLAB
    
    ! Data stores (persistent across tasks) (not directly compatible with UnpackRawBytes so use tmpf, tmpb to update variables)
    !jog command ID 
    PERS byte jog_input := 0; ! +x=1,-x=2,+y=3,-y=4,+z=5,-z=6,+j1=7,-j1=8,+j2=9,-j2=10,+j3=11,-j3=12,+j4=13,-j4=14,+j5=15,-j5=16,+j6=17,-j6=18

    ! IO Variables
    ! DO10_1 = VacPower, DO10_2 = VacSolenoid, DO10_3 = ConveyorPower, DO10_4 = ConveyorDirection, DI10_1 = ConveyorState
    ! VEN = PressToEnable, VES = EmergenccyStop, VGS = LightCurtain, VMAN = ManualMode, VMB = MotorOnButton, VML = MotorOnLight
    PERS byte write_io{4} := [0,0,0,0];   ! DO10_1, DO10_2, DO10_3, DO10_4 (off = 0, on = 1)
    PERS byte read_io{5} := [0,0,0,0,0];    ! DO10_1, DO10_2, DO10_3, DO10_4, DI10_1 (off = 0, on = 1)
    PERS byte read_switches{6} := [1,0,1,0,0,1];    ! VEN, VES, VGS, VMAN, VMB, VML (off = 0, on = 1)
    
    ! Pose state output variables
    PERS pos write_position := [502.514,-210.215,-156.781]; ! x,y,z translational pose input from MATLAB
    PERS jointtarget write_joints := [[0,0,0,0,0,0],[0,0,0,0,0,0]]; ! j1,j2,j3,j4,j5,j6 joint pose from MATLAB
    
    ! Pose state input variables
    PERS pos read_position := [0.103378,-439.194,624.907]; ! x,y,z translational pose tracker sending to MATLAB
    PERS jointtarget read_joints := [[-89.9865,0.0511017,-0.0169613,-0.000687638,2.02099,-0.0265471],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];    ! j1,j2,j3,j4,j5,j6 pose tracker sending to MATLAB
    
    ! Motion control variables
    PERS speeddata speed := [100,500,5000,1000];       ! v_tcp, v_ori, v_leax, v_reax (MATLAB sets v_tcp)
    PERS byte mode := 1;          ! mode = 0 (execute joint motion); mode = 1 (execute linear motion)
    PERS byte pause := 0;         ! pause = 0 (motion enabled), pause = 1 (motion halted)
    
    ! Communication variables
    PERS byte errorMsg{1} := [0];   ! Error flag sent to MATLAB when a command is successfully executed (TCP acknowledgement)
    PERS byte command := 1; ! MATLAB output command ID (Move to position = 0, Write to IOs = 1, Jog a given axis = 2) 
    PERS bool quit := FALSE; ! Main loop exit flag
    
    PROC main()
        ! Function: This is the main communication loop which manages the TCP link between Robot Studio and MATLAB. It will connect once 
        ! after initialising the persistant variables and then will begin the Stop and Wait communication stragedy. It will continue
        ! to read and execute commands from MATLAB until a close connection signal is received upon which it closes the TCP link.
        !
        ! Inputs: None  Outputs: None
        ! Note: Set Program Pointer to this routine
        ! Last Modified: 14/09/2017
        ! Author: Daniel Castillo
        ! Status: Working
        
        ! RawBytes buffer for data manipulation and placeholder variables
        VAR rawbytes raw_data; ! For capturing data stream
        VAR num tmpf := 0;  ! For updating floats
        VAR byte tmpb := 0; ! For updating bytes
        
        ! Message requests and replies
        VAR byte requestMsg{1}; 
        
        ! Initialise/reset persistent variables (which save from last session)
        errorMsg{1} := 0;
        jog_input := 0;
        write_io := [0,0,0,0];
        read_io := [0,0,0,0,0];
        read_switches := [0,0,0,0,0,0];
        write_position := [0,0,0];
        write_joints := [[0,0,0,0,0,0],[0,0,0,0,0,0]];
        read_position := [0,0,0];
        read_joints := [[0,0,0,0,0,0],[0,0,0,0,0,0]];
        speed := v100;       
        mode := 1;          
        pause := 0;
        command := 0;
        quit := FALSE;
        
        ! Establish connection to MATLAB (Blocking until connection achieved)
        ListenForAndAcceptConnection;
        
        ! Receive a new request from the client.
        SocketReceive client_socket \Data:=requestMsg \ReadNoOfBytes:=1;    ! 1 byte character ID
        
        WHILE TRUE DO     ! Keep server alive until close command recieved
            ClearRawBytes raw_data;
            
            IF requestMsg{1} = StrToByte("c" \Char) THEN   ! Client requesting to close connection
            
                quit := TRUE; ! End communication loop
                
            ELSEIF requestMsg{1} = StrToByte("x" \Char) THEN   ! Client requested e-stops and switches data
                
                ! Read all switches and update state variables
                read_switches{1} := VEN;
                read_switches{2} := VES;
                read_switches{3} := VGS;
                read_switches{4} := VMAN;
                read_switches{5} := VMB;
                read_switches{6} := VML;
                
                ! Pack data into raw_data
                FOR i FROM 1 TO Dim(read_switches,1) DO
                    PackRawBytes read_switches{i}, raw_data, (RawBytesLen(raw_data)+1) \hex1;
                ENDFOR
                
                ! Send raw_data to MATLAB
                SocketSend client_socket \RawData:=raw_data;
                
                ! Send error status
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;

            ELSEIF requestMsg{1} = StrToByte("p" \Char) THEN   ! Client requested pose data

                ! Read joint angles and end effector position and update state variables
                read_position := CPos (\Tool:=tSCup);
                read_joints := CJointT (\TaskRef:=RobControlId);

                ! Pack position data into raw_data
                PackRawBytes read_position.x, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_position.y, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_position.z, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                
                ! Pack joint data into raw_data
                PackRawBytes read_joints.robax.rax_1, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_2, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_3, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_4, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_5, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_6, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                
                ! Send raw_data to MATLAB
                SocketSend client_socket \RawData:=raw_data;
                
                ! Send error status
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;   
                
            ELSEIF requestMsg{1} = StrToByte("i" \Char) THEN   ! Client requested io_state data
                
                ! Read IO states and update IO state array
                read_io{1} := DOutput (DO10_1);
                read_io{2} := DOutput (DO10_2);
                read_io{3} := DOutput (DO10_3);
                read_io{4} := DOutput (DO10_4);
                read_io{5} := DInput (DI10_1);
            
                ! Pack data into raw_data
                FOR i FROM 1 TO Dim(read_io,1) DO
                    PackRawBytes read_io{i}, raw_data, (RawBytesLen(raw_data)+1) \hex1;
                ENDFOR
        
                ! Send raw_data to MATLAB
                SocketSend client_socket \RawData:=raw_data;
                
                ! Send error status
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;
            
            ELSEIF requestMsg{1} = StrToByte("P" \Char) THEN   ! Client wants to set pose
                
                ! Wait to for MATLAB to send position
                SocketReceive client_socket \RawData:=raw_data;
                
                ! Unpack data into state variables
                UnpackRawBytes raw_data, 1, tmpf \Float4;  ! 4 bytes per value
                write_position.x := tmpf;
                UnpackRawBytes raw_data, 5, tmpf \Float4;  ! 4 bytes per value
                write_position.y := tmpf;
                UnpackRawBytes raw_data, 9, tmpf \Float4;  ! 4 bytes per value
                write_position.z := tmpf;
                
                ! Stop and clear current motion buffer
                StopMove;
                ClearPath;
                
                ! Set command for move to new position
                command := 1;
                
                ! Send error status
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;
                
            ELSEIF requestMsg{1} = StrToByte("I" \Char) THEN   ! Client wants to set io_state

                ! Wait to for MATLAB to send IO states
                SocketReceive client_socket \RawData:=raw_data;
                
                ! Unpack data into state variables
                FOR i FROM 1 TO Dim(write_io,1) DO
                    UnpackRawBytes raw_data, i, tmpb \Hex1;   ! 1 byte per value
                    write_io{i} := tmpb;
                ENDFOR
                
                ! Set command for set IO states
                command := 2;
                
                ! Send error status
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;
            
            ELSEIF requestMsg{1} = StrToByte("S" \Char) THEN   ! Client wants to set speed

                ! Wait to for MATLAB to send new Speed
                SocketReceive client_socket \RawData:=raw_data;   
                
                ! Unpack data into speed variable
                UnpackRawBytes raw_data, 1, tmpf \Float4;  ! 4 bytes per value
                speed.v_tcp := tmpf;
                
                ! Send error status
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;
                
            ELSEIF requestMsg{1} = StrToByte("M" \Char) THEN   ! Client wants to set motion mode

                ! Wait to for MATLAB to send new motion mode
                SocketReceive client_socket \RawData:=raw_data;
                
                ! Unpack data into motion mode variable
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per value
                mode := tmpb;
                
                ! Send error status
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    
                
            ELSEIF requestMsg{1} = StrToByte("G" \Char) THEN   ! Client wants to set pause state

                ! Wait to for MATLAB to send new pause state (This is switching on MATLAB side)
                SocketReceive client_socket \RawData:=raw_data;
                
                ! Unpack data into pause variable
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per value
                pause := tmpb;
                
                ! Check pause variable and apply to motion
                IF pause = 1 THEN
                    StopMove;   ! Halt all motion
                ELSE
                    StartMove;  ! Resume current motion
                ENDIF
                
                ! Send error status 
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;   
                
            ELSEIF requestMsg{1} = StrToByte("J" \Char) THEN   ! Client wants to jog robot

                ! Wait to for MATLAB to send jog ID
                SocketReceive client_socket \RawData:=raw_data;
                
                ! Unpack data into jog input variable
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per value
                jog_input := tmpb;
                
                ! Set command for jog axis
                command := 3;
                
                ! Send error status 
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;   
            
            ENDIF
            
            ! Receive a new request from the client.
            SocketReceive client_socket \Data:=requestMsg \ReadNoOfBytes:=1;
            
        ENDWHILE

        CloseConnection;    ! TCP connection termination
		
    ENDPROC
    
    PROC ListenForAndAcceptConnection()
        ! Function: Establish a connection to an IP Address and port. This is blocking and will timeout after a period of time
        ! Inputs: None  Outputs: None
        ! Last Modified: 18/08/2017
        ! Author: Sample Code
        ! Status: Working
        
        ! Create the socket to listen for a connection on.
        VAR socketdev welcome_socket;
        SocketCreate welcome_socket;
        
        ! Bind the socket to the host and port.
        SocketBind welcome_socket, host, port;
        
        ! Listen on the welcome socket.
        SocketListen welcome_socket;
        
        ! Accept a connection on the host and port.
        SocketAccept welcome_socket, client_socket;
        
        ! Close the welcome socket, as it is no longer needed.
        SocketClose welcome_socket;
        
    ENDPROC
    
    ! Close the connection to the client.
    PROC CloseConnection()
        ! Function: Terminate TCP connection to the current socket
        ! Inputs: None  Outputs: None
        ! Last Modified: 18/08/2017
        ! Author: Sample Code
        ! Status: Working
        
        SocketClose client_socket;
    ENDPROC
		
ENDMODULE