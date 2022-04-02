function [ tcpip_pipe ] = OpenDrive( IPADDR , PORT )
%OPENDRIVE Open a connection to the Unidrive on the given IP and PORT.
%Returns the communications object which must be passed to the write and
%close functions.

tcpip_pipe = tcpclient(IPADDR , PORT);

end

%eof