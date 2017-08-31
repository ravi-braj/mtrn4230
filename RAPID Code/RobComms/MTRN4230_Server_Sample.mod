MODULE MTRN4230_Server_Sample    
    !test shit removed
    !dans edits
    ! The socket connected to the client.
    VAR socketdev client_socket;
    
    ! The host and port that we will be listening for a connection on.
    !CONST string host := "192.168.2.1";
    CONST string host := "127.0.0.1";
    CONST num port := 1025;
    
    PROC MainServer()
        
        ! Message request from client
        VAR string request;
        
        ! Output data to client
        VAR num pose{3};
        VAR num io_states{5};
        
        pose{1}:=150; pose{2}:=230; pose{3}:=62;
        io_states{1} := 1; io_states{2}:=0; io_states{3}:=0; io_states{4}:=1; io_states{5}:=1;  
        
        ListenForAndAcceptConnection;
        
        ! Receive a new request from the client.
        SocketReceive client_socket \Str:=request;
        
        WHILE request <> "c" DO     ! Keep server alive until close command recieved
            
            IF request = "p" THEN   ! Client requested pose data
                SocketSend client_socket \Data := pose \NoOfBytes := Dim(pose,1); 
            ELSEIF request = "i" THEN   ! Client requested io_states data
                SocketSend client_socket \Data := io_states \NoOfBytes := Dim(io_states,1); 
            ENDIF
            
            ! Receive a new request from the client.
            SocketReceive client_socket \Str:=request;
            
        ENDWHILE

        CloseConnection;
		
    ENDPROC

    PROC MainServer_test()
        
        ! Message request from client
        VAR string request;
        
        ! Output data to client
        VAR rawbytes raw_data;
        VAR num pose{3};
        VAR num io_states{5};
        
        pose{1}:=1123.4; pose{2}:=232.05; pose{3}:=6.242;
        io_states{1} := 1; io_states{2}:=0; io_states{3}:=0; io_states{4}:=1; io_states{5}:=1; 
        
        ListenForAndAcceptConnection;
        
        ! Receive a new request from the client.
        SocketReceive client_socket \Str:=request;
        
        WHILE request <> "c" DO     ! Keep server alive until close command recieved
            ClearRawBytes raw_data;
        
            IF request = "p" THEN   ! Client requested pose data
                
                FOR i FROM 1 TO Dim(pose,1) DO
                    PackRawBytes pose{i}, raw_data, (RawBytesLen(raw_data)+1) \Float4;
                ENDFOR
                
                SocketSend client_socket \RawData:=raw_data;
            
            ELSEIF request = "i" THEN   ! Client requested io_states data
                
                FOR i FROM 1 TO Dim(pose,1) DO
                    PackRawBytes io_states{i}, raw_data, (RawBytesLen(raw_data)+1) \IntX := INT;
                ENDFOR
                SocketSend client_socket \RawData:=raw_data;
                
            ENDIF
            
            ! Receive a new request from the client.
            SocketReceive client_socket \Str:=request;
            
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