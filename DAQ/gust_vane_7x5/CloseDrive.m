function [ output_args ] = CloseDrive( PIPE )
%CLOSEDRIVE Close the connection to the drive

fclose(PIPE);

end

%eof