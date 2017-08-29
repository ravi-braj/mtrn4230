%%% class for tcp communication with abb robot
%%% protocols inbuilt


classdef abb_tcp < handle
    properties
        socket;
    end
    methods
        %constructor
        function obj = abb_tcp()
            fprintf("created abb_tcp object\n");
            fclose('all');
        end
        
        %opens connection and returns true if successful or false if
        %invalid
        function obj = openTCP(obj, ip_address, port)
            % Open a TCP connection to the robot.
            obj.socket = tcpip(ip_address, port);
            
            pause(0.5);
            set(obj.socket, 'ReadAsyncMode', 'continuous');
            fopen(obj.socket);

            % Check if the connection is valid.
            if(~isequal(get(obj.socket, 'Status'), 'open'))
                warning(['Could not open TCP connection to ', ip_address, ' on port ', port]);
                valid = false;
                return;
            end
            valid = true;
        end
        
        %closes the socket.
        function closeSocket(obj)
            close(obj.socket);
        end
        
        
        %% %%%%%%%%%%%%% METHODS FOR GETTING DATA OFF ROBOT %%%%%%%%%%%
        
        %------------ Requesting data ---------------
        %attempts to get the pose off the robot
        function pose = requestPose()
        end
      
        %attempts to get the ios off the robot
        function ios = requestIOs()
        end
        
        %------------ Sending data ------------------
        %attempts to set the ios off the robot
        function setIOs(ioArray)
        end
        
        %tells the robot to execute some command (like go to this point)
        function sendCommand(command)
        end
        
        function firstRead(obj) 
            disp("inside first read");
            % Send a sample string to the server on the robot.
            fwrite(obj.socket, num2str(45645456456));
            disp('attempting to read data');
            data = fgetl(obj.socket);
            disp(data);
        end
        
    end
end
    