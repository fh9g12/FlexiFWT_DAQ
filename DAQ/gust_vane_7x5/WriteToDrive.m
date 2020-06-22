function [ RES ] = WriteToDrive( PIPE , ADDR , VAL , VERB)
%WRITETODRIVE Write the value (VAL) to the address (ADDR) on the drive
%connection (PIPE)

transID=uint16(0);
transID = uint16(transID+1); % 16b Transaction Identifier 
ProtID = uint16(0); % 16b Protocol ID (0 for ModBus) 
Lenghf = uint16(6); % 16b Remaining bits (6) 
UnitID = uint16(0); % Unit ID (0) 
UnitID = bitshift(UnitID,8); 
FunCod = uint16(6); % Function code: write (6) 
UnitIDFunCod = bitor(FunCod,UnitID); 
% Concatenation of UnitID & FunctionCode 
% in one uint16 word
% According to modbus protocol, UnitID and Function code are 8bit data. 
% In order to maintain the same data tipe in vector "message", I converted 
% each of them to uint16, and used "bitor" to create a uint16 word when 
% the MSB is the UnitID and the LSB is the function code
Add = uint16(ADDR); % 16b Adress of the resister (8501) 
Val = uint16(VAL); % 16b Data (5)
message = [transID; ProtID; Lenghf; UnitIDFunCod; Add; Val]; 
if VERB
%     disp(message); 
end
fwrite(PIPE, message,'int16');
% while ~PIPE.BytesAvailable,end
% PIPE.BytesAvailable
% RES = fread(PIPE,PIPE.BytesAvailable);

end

%eof