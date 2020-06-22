function [ tcpip_pipe ] = OpenDrive( IPADDR , PORT )
%OPENDRIVE Open a connection to the Unidrive on the given IP and PORT.
%Returns the communications object which must be passed to the write and
%close functions.

% configuration of TCP/IP channel
tcpip_pipe=tcpip(IPADDR, PORT); %IP and Port of ATV32 
set(tcpip_pipe, 'InputBufferSize', 512); 
tcpip_pipe.ByteOrder='bigEndian';

try 
    if ~strcmp(tcpip_pipe.Status,'open') 
        fopen(tcpip_pipe); 
    end
    disp('TCP/IP Open'); 
catch err 
    disp('Error: Can''t open TCP/IP'); 
end

end

%eof