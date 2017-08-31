% Script to communicate with IRB120 robot system
% Mark Whitty
% 140324
function MTRN4230_Client_Sample

% The robot's IP address.
%robot_IP_address = '192.168.2.1';
robot_IP_address = '127.0.0.1';

% The port that the robot will be listening on. This must be the same as in
% your RAPID program.
robot_port = 1025;
fclose('all');
% Open a TCP connection to the robot.
socket = tcpip(robot_IP_address, robot_port);
socket.ByteOrder = 'littleEndian';   %Set Endian to convert
set(socket, 'ReadAsyncMode', 'continuous');
fopen(socket);

% Check if the connection is valid.+6

if(~isequal(get(socket, 'Status'), 'open'))
    warning(['Could not open TCP connection to ', robot_IP_address, ' on port ', robot_port]);
    return;
end

quit = false;

while quit == false
   % Send a sample string to the server on the robot.
    disp('Writing to socket...');
    pose = [202.1, 4673.4, 60.23];
    fwrite(socket, 'P');
    fwrite(socket, pose,'float32');
    
    disp('Freadsocket');
    % Read a line from the socket. Note the line feed appended to the message in the RADID sample code.
    data = fread(socket);

    % Print the data that we got.
    fprintf(char(data));
    
    %data = fread(socket,3,'uint8');    % To read bytes
    %data = fread(socket,3,'float32');   % To read rawbytes
end

% Close the socket.
fclose(socket);
