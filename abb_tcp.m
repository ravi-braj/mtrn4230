%%% class for tcp communication with abb robot
%%% protocols inbuilt

classdef abb_tcp < handle
    properties
        socket;
        connected;
        %this gets set after each method
        error;
    end
    methods
        %constructor
        function obj = abb_tcp()
            fprintf('created abb_tcp object\n');
            fclose('all');
        end
        
        %opens connection and returns true if successful or false if
        %invalid
        function obj = openTCP(obj, ip_address, port)
            obj.connected = false;
            % Open a TCP connection to the robot.
            obj.socket = tcpip(ip_address, port);

            obj.socket.ByteOrder = 'littleEndian';
            
            pause(0.5);
            set(obj.socket, 'ReadAsyncMode', 'continuous');
            try 
                fopen(obj.socket);
            catch 
                disp('Could not connect to tcp')
                return;
            end

            % Check if the connection is valid.
            if(~isequal(get(obj.socket, 'Status'), 'open'))
                warning(['Could not open TCP connection to ', ip_address, ' on port ', port]);
                obj.connected = false;
                return;
            end

            disp('connected')

            obj.connected = true;
        end
        
        %closes the socket.
        function closeSocket(obj)
            close(obj.socket);
        end
        
        
        %% %%%%%%%%%%%%% METHODS FOR GETTING DATA OFF ROBOT %%%%%%%%%%%
        
        %------------ Requesting data ---------------
        %attempts to get the pose off the robot gets joint and xyz
        function pose = requestPose(obj)
            try
                %send request for pose
                fwrite(obj.socket, 'p', 'uchar');

                %read the pose
                pose = fread(obj.socket, 9, 'float32');

                %read error message
                obj.error = fread(obj.socket, 1, 'uchar');

            catch
                disp('Socket error');
                pose = [NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];
                obj.connected = false;
            end
           
        end
      
        %attempts to get the ios off the robot
        function ios = requestIOs(obj)
            disp('requesting IOs');
            try

                %send request to RAPID for i/o data
                fwrite(obj.socket, 'i', 'uchar');

                %read the i/o data
                ios = fread(obj.socket, 4, 'uint8');

                %read error message
                obj.error = fread(obj.socket, 1, 'uchar');
            catch
                ios = [NaN, NaN, NaN, NaN];
                disp('Socket error');
                obj.connected = false;
            end
        end
        
        function errors = requestErrors(obj)
            try
                %send request for pose
                fwrite(obj.socket, 'x', 'uchar');

                %read the pose
                errors = fread(obj.socket, 6, 'uint8');

                %read error message
                obj.error = fread(obj.socket, 1, 'uchar');
            catch
                errors = [NaN, NaN, NaN, NaN, NaN, NaN];
                disp('Socket error');
                obj.connected = false;
            end
        end
        
        %------------ Sending data ------------------
        %attempts to set the pose of the robot
        function setPose(obj, poseArray)
            disp('Sending poseArray')
            try
                %send request to send RAPID the i/o array
                fwrite(obj.socket, 'P', 'uchar');

                tmp = zeros(1,7);
                tmp(1:3) = poseArray;

                %send RAPID the i/o array
                fwrite(obj.socket, tmp, 'float32');

                %read error message
                obj.error = fread(obj.socket, 1, 'uchar');
            catch
                disp('Socket error');
                obj.connected = false;
            end
        end
        
        %attempts to set the ios of the robot
        function setIOs(obj, ioArray)
            
            disp('Sending ioArray')
            try
                %send request to send RAPID the i/o array
                fwrite(obj.socket, 'I', 'uchar');

                %send RAPID the i/o array
                fwrite(obj.socket, ioArray, 'uint8');

                %read error message
                obj.error = fread(obj.socket, 1, 'uchar');
            catch
                disp('Socket error');
                obj.connected = false;
            end
        end
       
        function pauseRobot(obj, pauseFlag)
            try
                %send pause request message to robot
                fwrite(obj.socket, 'G', 'uchar');

                %send RAPID the pauseFlag
                fwrite(obj.socket, pauseFlag, 'uint8');

                %read error message
                obj.error = fread(obj.socket, 1, 'uchar');
            catch
                disp('Socket error');
                obj.connected = false;                
            end
        end
        
        function setMotionMode(obj, mode)
            try
               %send request to set motion mode
               fwrite(obj.socket, 'M', 'uchar');

               %write motion mode
               fwrite(obj.socket, mode', 'uint8');

               %read error message
               obj.error = fread(obj.socket, 1, 'uchar');
            catch
                disp('Socket error');
                obj.connected = false;                
            end
        end
        
        function setSpeed(obj, speed)
           try
               %send request ot set speed
               fwrite(obj.socket, 'S', 'uchar');

               %write speed
               fwrite(obj.socket, speed, 'float32');

               %read error message
               obj.error = fread(obj.socket, 1, 'uchar');
           catch
                disp('Socket error');
                obj.connected = false;                
           end
            
        end
        
        function setJOG(obj, jog)

           try
               %send request ot set speed
               fwrite(obj.socket, 'J', 'char');

               %write speed
               fwrite(obj.socket, jog, 'uint8');

               %read error message
               obj.error = fread(obj.socket, 1, 'uchar');
           catch
               disp('Socket error');
               obj.connected = false;                
           end
        end
        
    end
end
    