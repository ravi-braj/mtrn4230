MODULE MTRN4230_Server_Sample    
	
    ! The socket connected to the client.
    VAR socketdev client_socket;
    
    ! The host and port that we will be listening for a connection on.
    !CONST string host := "192.168.2.1";
    CONST string host := "127.0.0.1";
    CONST num port := 1025;
    
    PROC MainServer()
        
        ! RawBytes buffer for data manipulation
        VAR rawbytes raw_data;
        
        ! Message requests and replies
        VAR byte requestMsg{1};
        VAR byte errorMsg{1};
        !errorMsg{1} := StrToByte("y" \Char);
        
        ! Data stores
        VAR num pose_{4};        ! x, y, z, theta
        VAR bool io_state{5};   ! DI10_1, DO10_1, DO10_2, DO10_3, DO10_4
        !VAR num speed{4};       ! v_tcp, v_ori, v_leax, v_reax
        !VAR bool mode;          ! mode = 0 (execute joint motion); mode = 1 (execute linear motion)
        !VAR bool pause;         ! pause = 0 (moving), pause = 1 (paused) 
        
        ListenForAndAcceptConnection;
        
        ! Receive a new request from the client.
        SocketReceive client_socket \Data:=requestMsg \ReadNoOfBytes:=1;
        
        WHILE requestMsg{1} <> StrToByte("c" \Char) DO     ! Keep server alive until close command recieved
            ClearRawBytes raw_data;

            IF requestMsg{1} = StrToByte("p" \Char) THEN   ! Client requested pose data
                
                FOR i FROM 1 TO Dim(pose_,1) DO
                    PackRawBytes pose_{i}, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                ENDFOR
                
                SocketSend client_socket \RawData:=raw_data;    ! Send pose
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
            
            ELSEIF requestMsg{1} = StrToByte("i" \Char) THEN   ! Client requested io_state data
                
                FOR i FROM 1 TO Dim(io_state,1) DO
                    PackRawBytes io_state{i}, raw_data, (RawBytesLen(raw_data)+1) \IntX:=USINT;
                ENDFOR
                
                SocketSend client_socket \RawData:=raw_data;    ! Send io_state
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
            
            ELSEIF requestMsg{1} = StrToByte("P" \Char) THEN   ! Client wants to set pose
                
                SocketReceive client_socket \RawData:=raw_data;   
                
                FOR i FROM 1 TO Dim(pose_,1) DO
                    UnpackRawBytes raw_data, 4*(i-1) + 1, pose_{i} \Float4;  ! 4 bytes per value
                ENDFOR
                
                SocketSend client_socket \Data:= errorMsg \NoOfBytes:=1;    ! Send error status
                
            ELSEIF requestMsg{1} = StrToByte("I" \Char) THEN   ! Client wants to set

                SocketReceive client_socket \RawData:=raw_data;
                
                FOR i FROM 1 TO Dim(io_state,1) DO
                    UnpackRawBytes raw_data, i, io_state{i} \IntX:=USINT;   ! 1 byte per value
                ENDFOR
                
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