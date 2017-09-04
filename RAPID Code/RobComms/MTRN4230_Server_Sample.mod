MODULE MTRN4230_Server_Sample    
	
    ! The socket connected to the client.
    VAR socketdev client_socket;
    
    ! The host and port that we will be listening for a connection on.
    !CONST string host := "192.168.2.1";
    CONST string host := "127.0.0.1";
    CONST num port := 1025;
    
    ! Data stores   (persistent across tasks) (not directly compatible with UnpackRawBytes - use tmpf, tmpb)
    PERS pose pose_state := [[175,0,140],[0,0,-1,0]];  ! pos(x, y, z), orient(q1,q2,q3,q4), begun at table home
    PERS speeddata speed := [100,500,5000,1000];       ! v_tcp, v_ori, v_leax, v_reax, begun at v100
    PERS byte io_state{4} := [1,0,1,0];   ! DI10_1, DO10_1, DO10_2, DO10_3 (off = 0, on = 1)
    PERS byte mode := 1;          ! mode = 0 (execute joint motion); mode = 1 (execute linear motion)
    PERS byte pause := 0;         ! pause = 0 (moving), pause = 1 (paused)
    PERS byte jog_input := 0;
    PERS bool quit := FALSE;
    
    PROC MainServer()
        
        ! RawBytes buffer for data manipulation
        VAR rawbytes raw_data;
        VAR num tmpf := 0;
        VAR byte tmpb := 0;
        
        ! Message requests and replies
        VAR byte requestMsg{1};
        VAR byte errorMsg{1};
        
        ListenForAndAcceptConnection;
        
        ! Receive a new request from the client.
        SocketReceive client_socket \Data:=requestMsg \ReadNoOfBytes:=1;
        
        WHILE quit = FALSE DO     ! Keep server alive until close command recieved
            ClearRawBytes raw_data;
            
            IF requestMsg{1} = StrToByte("c" \Char) THEN   ! Client requesting to close connection
            
                quit := TRUE;

            ELSEIF requestMsg{1} = StrToByte("p" \Char) THEN   ! Client requested pose_state data
                
                PackRawBytes pose_state.trans.x, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes pose_state.trans.y, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes pose_state.trans.z, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                
                PackRawBytes pose_state.rot.q1, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes pose_state.rot.q2, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes pose_state.rot.q3, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                PackRawBytes pose_state.rot.q4, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                
                SocketSend client_socket \RawData:=raw_data;    ! Send pose
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
            
            ELSEIF requestMsg{1} = StrToByte("i" \Char) THEN   ! Client requested io_state data
                
                FOR i FROM 1 TO Dim(io_state,1) DO
                    PackRawBytes io_state{i}, raw_data, (RawBytesLen(raw_data)+1) \hex1;
                ENDFOR
                
                SocketSend client_socket \RawData:=raw_data;    ! Send io_state
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
            
            ELSEIF requestMsg{1} = StrToByte("P" \Char) THEN   ! Client wants to set pose
                
                SocketReceive client_socket \RawData:=raw_data;
                
                UnpackRawBytes raw_data, 1, tmpf \Float4;  ! 4 bytes per value
                pose_state.trans.x := tmpf;
                UnpackRawBytes raw_data, 5, tmpf \Float4;  ! 4 bytes per value
                pose_state.trans.y := tmpf;
                UnpackRawBytes raw_data, 9, tmpf \Float4;  ! 4 bytes per value
                pose_state.trans.z := tmpf;
                UnpackRawBytes raw_data, 13, tmpf \Float4;  ! 4 bytes per value
                pose_state.rot.q1 := tmpf;
                UnpackRawBytes raw_data, 17, tmpf \Float4;  ! 4 bytes per value
                pose_state.rot.q2 := tmpf;
                UnpackRawBytes raw_data, 21, tmpf \Float4;  ! 4 bytes per value
                pose_state.rot.q3 := tmpf;
                UnpackRawBytes raw_data, 25, tmpf \Float4;  ! 4 bytes per value
                pose_state.rot.q4 := tmpf;
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
                
            ELSEIF requestMsg{1} = StrToByte("I" \Char) THEN   ! Client wants to set io_state

                SocketReceive client_socket \RawData:=raw_data;
                
                FOR i FROM 1 TO Dim(io_state,1) DO
                    UnpackRawBytes raw_data, i, tmpb \Hex1;   ! 1 byte per value
                    io_state{i} := tmpb;
                ENDFOR
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
            
            ELSEIF requestMsg{1} = StrToByte("S" \Char) THEN   ! Client wants to set speed

                SocketReceive client_socket \RawData:=raw_data;   
                
                UnpackRawBytes raw_data, 1, tmpf \Float4;  ! 4 bytes per value
                speed.v_leax := tmpf;
                UnpackRawBytes raw_data, 5, tmpf \Float4;  ! 4 bytes per value
                speed.v_ori := tmpf;
                UnpackRawBytes raw_data, 9, tmpf \Float4;  ! 4 bytes per value
                speed.v_reax := tmpf;
                UnpackRawBytes raw_data, 13, tmpf \Float4;  ! 4 bytes per value
                speed.v_tcp := tmpf;
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
                
            ELSEIF requestMsg{1} = StrToByte("M" \Char) THEN   ! Client wants to set motion mode

                SocketReceive client_socket \RawData:=raw_data;
                
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per value
                mode := tmpb;
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status    
                
            ELSEIF requestMsg{1} = StrToByte("G" \Char) THEN   ! Client wants to set pause state

                SocketReceive client_socket \RawData:=raw_data;
                
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per value
                pause := tmpb;
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status    
                
            ELSEIF requestMsg{1} = StrToByte("J" \Char) THEN   ! Client wants to set pause state

                SocketReceive client_socket \RawData:=raw_data;
                
                UnpackRawBytes raw_data, 1, tmpb \Hex1;   ! 1 byte per value
                jog_input := tmpb;
                
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