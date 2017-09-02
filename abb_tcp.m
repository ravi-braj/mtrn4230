%%% class for tcp communication with abb robot
%%% protocols inbuilt


classdef abb_tcp < handle
    properties
        socket;
        
        %this gets set after each method
        error;
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
        function pose = requestPose(obj)
            
            %send request for pose
            fwrite(obj.socket, 'p', 'char');
            
            %read the pose
            pose = fread(obj.socket, 4, 'int32');
            
            %read error message
            obj.error = fread(obj.socket, 1, 'char');
           
        end
      
        %attempts to get the ios off the robot
        function ios = requestIOs(obj)
            
            disp('requesting IOs');
            
            %send request to RAPID for i/o data
            fwrite(obj.socket, 'i', 'char');
            
            %read the i/o data
            ios = fread(obj.socket, 6, 'int32');
            
            %read error message
            obj.error = fread(obj.socket, 1, 'char');
        end
        
        %------------ Sending data ------------------
        %attempts to set the ios off the robot
        function error = setIOs(obj, ioArray)
            disp('Sending IOarrays')
            
            %send request to send RAPID the i/o array
            fwrite(obj.socket, 'I', 'char');
            
            %send RAPID the i/o array
            fwrite(obj.socket, ioArray, 'int32');
            
            obj.error = fread(obj.socket, 1, 'char');
        end
       
        
        function pauseRobot(obj)
            %send pause request message to robot
            fwrite(obj.socket, 'p', 'char');
           
            %read error message
            obj.error = fread(obj.socket, 1, 'char');
           
        end
        
        function setMotionMode(obj, mode)
           %send request to set motion mode
           fwrite(obj.socket, 'M', 'char');
           
           %write motion mode
           fwrite(obj.socket, mode', 'int32');
           
           %read error message
           obj.error = fread(obj.socket, 1, 'char');
        end
        
        function setSpeed(obj, speed)
           %send request ot set speed
           fwrite(obj.socket, 'S', 'char');
           
           %write speed
           fwrite(obj.socket, speed, 'int32');
           
           %read error message
           obj.error = fread(obj.socket, 1, 'char');
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
    