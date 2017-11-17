% class for handling all tcp communication with abb robot
% The standard protocol for all communication is
% 1) Client sends a 1 byte request packet. 
% 2) ABB side reads the request packet:
%     a) Reutrns an error status flag if no data is required (0 means no error)
%     b) A packet containing data of a specified size (depending on the
%     request)
%     c) Reads the tcp socket if the reqest is to send the ABB something
% 3) If b and c apply above, the robot concludes with an error status flag.
% Written by Aravind Baratha Raj
% Last modified 15 September 2017


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
        

        function obj = openTCP(obj, ip_address, port)
             %opens connection and returns true if successful or false if
             %invalid
             % takes in an IP address and port. Stores TCP object.
             % Written by Jay Motwani
             % Last updated 15 September 2017
             
             
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
            %closes a tcp socket
            %written by Jay Motwani
            %Last updated 5 Spetember 2017
            close(obj.socket);
        end
        
        
        %% %%%%%%%%%%%%% METHODS FOR GETTING DATA OFF ROBOT %%%%%%%%%%%
        
        %------------ Requesting data ---------------
        
        function pose = requestPose(obj)
            %attempts to get the pose off the robot gets joint and xyz
            %Returns the pose as an array
            %Written by Jay Motwani
            % Last updated 1 September 2017
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
            %Requests the errors off the robot
            %Returns an array of error status flags
            % Written by Aravind Baratha Raj
            % Last updated 15 September 2017
            
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
        function setPose(obj, poseArray)
            %attempts to set the pose of the robot
            %Takes in a desired pose position
            %Written by Aravind Baratha Raj
            %Last updated 15 September 2017

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
        
        function setPoseSafe(obj, poseArray)
             %attempts to set the pose of the robot
            %Takes in a desired pose position
            %Written by Aravind Baratha Raj
            %Last updated 15 September 2017

            disp('Sending poseArray safely')
            try
                %send request to send RAPID the i/o array
                fwrite(obj.socket, 'Z', 'uchar');

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
            %Attempts to se the IOs of the ABB over tcp
            %Takes in an array of IO status flag
            %Written by Aravind Baratha Raj
            %Last updated 10 September 2017
            
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
            %Attempts to set the motion mode to 'Joint' or 'Linear'
            %Takes in the motion mode as a 1 or a 0.
            %Written by Aravind Baratha Raj
            %Last updated 10 September 2017
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
           % Attempts ot set the speed of the ABB robot arm
           % Takes in a speed value as an integer
           % Written by Jay Motwani
           % Last modified 15 September 2017
            
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
           %Sends a jog command to the ABB
           %Takes in a number between 0 and 18
           %Written by Aravind Baratha Raj
           %Last modified 15 September 2017
           
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
        
        function setEndEffector(obj, effectorAngle)
            %Sends an end effector angle to ABB
            %Takes in a number between 0 and 360
            %Written by Aravind Baratha Raj
            %Last modified 10 November 2017

           try
               %send request ot set speed
               fwrite(obj.socket, 'N', 'char');

               %write speed
               fwrite(obj.socket, effectorAngle, 'uint8');

               %read error message
               obj.error = fread(obj.socket, 1, 'uchar');
           catch
               disp('Socket error');
               obj.connected = false;                
           end
            
        end
        
        function loadConveyorBox(obj, forward)
            %sends command to ABB to start conveyor to load box
            %takes in a 1 or a 0 to indicate direciton
            %Written by Aravind Baratha Raj
            %Last modified 10 November 2017
           try
               %send request ot set speed
               fwrite(obj.socket, 'L', 'char');

               %write direction. 1 is towards robot. 0 is away
               fwrite(obj.socket, forward, 'uchar');

               %read error message
               obj.error = fread(obj.socket, 1, 'uchar');
           catch
               disp('Socket error');
               obj.connected = false;                
           end
            
        end
        
        function ready = readyForNextCommand(obj)
            %Sends a call to the robot to ask if it is ready for the next
            %command in the queue
            %Takes in nothing
            %Last Modified 25 October 2017
            
           ready = 0;
           try
               %send request ot set speed
               fwrite(obj.socket, 'X', 'char');

               
               ready = fread(obj.socket, 1, 'uchar');

               %read error message
               obj.error = fread(obj.socket, 1, 'uchar');
           catch
               disp('Socket error');
               obj.connected = false;                
           end
            
        end
        
        
        
        
    end
end
    