MODULE MTRN4230_Server_Sample    
	
    ! The socket connected to the client.
    VAR socketdev client_socket;
    
    ! The host and port that we will be listening for a connection on.
    !CONST string host := "192.168.125.1";
    CONST string host := "127.0.0.1";
    CONST num port := 1025;
    
    ! TEMPORARY DIRTY SOLUTION WE NEED TO ADD THE SYSTEM MODULES TO THIS TASK THAT DEFINE tSCUP PERSISTENTLY
    PERS tooldata tmp_tSCup:=[TRUE,[[0,0,65],[1,0,0,0]],[0.5,[0,0,20],[1,0,0,0],0,0,0]];
    
    ! Data stores   (persistent across tasks) (not directly compatible with UnpackRawBytes - use tmpf, tmpb)
    PERS byte jog_input := 0;

    PERS byte write_io{4} := [0,0,0,0];   ! DO10_1, DO10_2, DO10_3, DO10_4 (off = 0, on = 1)
    PERS byte read_io{5} := [0,0,0,0,0];    ! DO10_1, DO10_2, DO10_3, DO10_4, DI10_1 (off = 0, on = 1)
    
    PERS pos write_position := [0,0,0];
    PERS jointtarget write_joints := [[0,0,0,0,0,0],[0,0,0,0,0,0]];
    
    PERS pos read_position := [175,4.24428E-14,147];
    PERS jointtarget read_joints := [[1.38892E-14,6.48693,68.7812,3.40449E-17,14.7319,-1.59849E-14],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    
    PERS speeddata speed := [100,500,5000,1000];       ! v_tcp, v_ori, v_leax, v_reax, begun at v100
    PERS byte mode := 1;          ! mode = 0 (execute joint motion); mode = 1 (execute linear motion)
    PERS byte pause := 0;         ! pause = 0 (moving), pause = 1 (paused)
    
    PERS byte errorMsg{1} := [0];
    PERS byte command := 0;
    PERS bool quit := FALSE;
    
    PROC main()
        ! RawBytes buffer for data manipulation
        VAR rawbytes raw_data;
        VAR num tmpf := 0;
        VAR byte tmpb := 0;
        
        ! Message requests and replies
        VAR byte requestMsg{1};
        errorMsg{1} := 0;
        
        ! Initialise/reset persistent variables
        jog_input := 0;

        write_io := [0,0,0,0];   ! DO10_1, DO10_2, DO10_3, DO10_4 (off = 0, on = 1)
        read_io := [0,0,0,0,0];    ! DO10_1, DO10_2, DO10_3, DO10_4, DI10_1 (off = 0, on = 1)
        
        write_position := [0,0,0];
        write_joints := [[0,0,0,0,0,0],[0,0,0,0,0,0]];
        
        read_position := [0,0,0];
        read_joints := [[0,0,0,0,0,0],[0,0,0,0,0,0]];
        
        speed := v100;       ! v_tcp, v_ori, v_leax, v_reax, begun at v100
        mode := 1;          ! mode = 0 (execute joint motion); mode = 1 (execute linear motion)
        pause := 0;         ! pause = 0 (moving), pause = 1 (paused)
        
        command := 0;
        quit := FALSE;
        
        ListenForAndAcceptConnection;
        
        ! Receive a new request from the client.
        SocketReceive client_socket \Data:=requestMsg \ReadNoOfBytes:=1;    
        
        WHILE TRUE DO     ! Keep server alive until close command recieved
            ClearRawBytes raw_data;
            
            IF requestMsg{1} = StrToByte("c" \Char) THEN   ! Client requesting to close connection
            
                quit := TRUE;

            ELSEIF requestMsg{1} = StrToByte("p" \Char) THEN   ! Client requested pose_state data
                read_position := CPos (\Tool:=tmp_tSCup);
                read_joints := CJointT (\TaskRef:=RobControlId);

                PackRawBytes read_position.x, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_position.y, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_position.z, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                
                PackRawBytes read_joints.robax.rax_1, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_2, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_3, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_4, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_5, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes read_joints.robax.rax_6, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                
                SocketSend client_socket \RawData:=raw_data;    ! Send pose
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
                
            ELSEIF requestMsg{1} = StrToByte("i" \Char) THEN   ! Client requested io_state data
                    read_io{1} := DOutput (DO10_1);
                    read_io{2} := DOutput (DO10_2);
                    read_io{3} := DOutput (DO10_3);
                    read_io{4} := DOutput (DO10_4);
                    read_io{5} := DInput (DI10_1);
            
                FOR i FROM 1 TO Dim(read_io,1) DO
                    PackRawBytes read_io{i}, raw_data, (RawBytesLen(raw_data)+1) \hex1;
                ENDFOR
                
                SocketSend client_socket \RawData:=raw_data;    ! Send io_state
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
            
            ELSEIF requestMsg{1} = StrToByte("P" \Char) THEN   ! Client wants to set pose
                
                SocketReceive client_socket \RawData:=raw_data;
                
                UnpackRawBytes raw_data, 1, tmpf \Float4;  ! 4 bytes per value
                write_position.x := tmpf;
                UnpackRawBytes raw_data, 5, tmpf \Float4;  ! 4 bytes per value
                write_position.y := tmpf;
                UnpackRawBytes raw_data, 9, tmpf \Float4;  ! 4 bytes per value
                write_position.z := tmpf;
                UnpackRawBytes raw_data, 13, tmpf \Float4;  ! 4 bytes per value
                
                command := 1;   ! Execute move to pose
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
                
            ELSEIF requestMsg{1} = StrToByte("I" \Char) THEN   ! Client wants to set io_state

                SocketReceive client_socket \RawData:=raw_data;
                
                FOR i FROM 1 TO Dim(write_io,1) DO
                    UnpackRawBytes raw_data, i, tmpb \Hex1;   ! 1 byte per value
                    write_io{i} := tmpb;
                ENDFOR
                
                command := 2;   ! Execute io updates
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
            
            ELSEIF requestMsg{1} = StrToByte("S" \Char) THEN   ! Client wants to set speed

                SocketReceive client_socket \RawData:=raw_data;   
                
                UnpackRawBytes raw_data, 1, tmpf \Float4;  ! 4 bytes per value
                speed.v_tcp := tmpf;
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
                
            ELSEIF requestMsg{1} = StrToByte("M" \Char) THEN   ! Client wants to set motion mode

                SocketReceive client_socket \RawData:=raw_data;
                
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per values
                mode := tmpb;
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status    
                
            ELSEIF requestMsg{1} = StrToByte("G" \Char) THEN   ! Client wants to set pause state

                SocketReceive client_socket \RawData:=raw_data;
                
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per value
                pause := tmpb;
                
                IF pause = 1 THEN
                    StopMove;
                ELSE
                    StartMove;
                ENDIF
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status    
                
            ELSEIF requestMsg{1} = StrToByte("J" \Char) THEN   ! Client wants to jog robot

                SocketReceive client_socket \RawData:=raw_data;
                
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per value
                jog_input := tmpb;
                
                command := 3;   ! Execute move to pose
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status    
            
            ENDIF
            
            ! Receive a new request from the client.
            SocketReceive client_socket \Data:=requestMsg \ReadNoOfBytes:=1;
            
        ENDWHILE

        CloseConnection;
		
    ENDPROC
    
    PROC ListenForAndAcceptConnection()
        
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
        SocketClose client_socket;
    ENDPROC
		
ENDMODULE