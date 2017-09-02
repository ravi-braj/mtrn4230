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
            disp('requesting Pose');
            
            %send request for pose
            fwrite(obj.socket, 'p', 'uchar');
            
            %read the pose
            pose = fread(obj.socket, 4, 'float32');
            
            %read error message
            obj.error = fread(obj.socket, 1, 'uchar');
           
        end
      
        %attempts to get the ios off the robot
        function ios = requestIOs(obj)
            disp('requesting IOs');
            
            %send request to RAPID for i/o data
            fwrite(obj.socket, 'i', 'uchar');
            
            %read the i/o data
            ios = logical(fread(obj.socket, 4, 'uint8'));
            
            %read error message
            obj.error = fread(obj.socket, 1, 'uchar');
        end
        
        %------------ Sending data ------------------
        %attempts to set the pose of the robot
        function setPose(obj, poseArray)
            disp('Sending poseArray')
            
            %send request to send RAPID the i/o array
            fwrite(obj.socket, 'P', 'uchar');
            
            %send RAPID the i/o array
            fwrite(obj.socket, poseArray, 'float32');
            
            %read error message
            obj.error = fread(obj.socket, 1, 'uchar');
        end
        
        %attempts to set the ios of the robot
        function setIOs(obj, ioArray)
            disp('Sending ioArray')
            
            %send request to send RAPID the i/o array
            fwrite(obj.socket, 'I', 'uchar');
            sz = size(ioArray)
            %send RAPID the i/o array
            fwrite(obj.socket, ioArray, 'uint8');
            
            %read error message
            obj.error = fread(obj.socket, 1, 'uchar');
        end
       
        function pauseRobot(obj, pauseFlag)
            %send pause request message to robot
            fwrite(obj.socket, 'G', 'uchar');
            
            %send RAPID the pauseFlag
            fwrite(obj.socket, logical(pauseFlag), 'uint8');
            
            %read error message
            obj.error = fread(obj.socket, 1, 'uchar'); 
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
    