close all;clc;fclose all;clear all;
%% Gust Vane Test Script
% Author: R Cheung
% Created: 25 MARCH 2019
%% Operating modes
% 5 => Turbulence, between +/- Amplitude
% 4 => Chirp, between +/- Amplitude
% 3 => Single-shot, single-sided "1-Cosine"
% 2 => Sine, between +/- Amplitude
% 1 => Analogue, @ 2.7 degree per volt
% 0 => Off
% 
MODE = 3;
cycle_duration = 10;
AMP = 2;

% MODE = 2;
% cycle_duration = 5.0;
% AMP = 3;


% Frequency Hz [Max value 14 Hz]
FRQ = 0.5;




% Single-sided Amplitude, in degrees [Max value 20 deg]
% Negative deflection?
Negative_deflection = 0; % 1-cosine only
FRQ_END = 2; % End frequency, for Chirp only
%% Check Inputs
if(MODE==5)
    if(AMP>5)
        AMP=5;
        disp('Clamped maximum amplitude to +/- 5 degs');
    elseif(AMP<1)
        AMP=1;
        disp('Clamped minimum amplitude to 1 degs');
    end
else
    if(AMP>20)
        AMP=20;
        disp('Clamped maximum amplitude to 25 degs');
    elseif(AMP<1)
        AMP=1;
        disp('Clamped minimum amplitude to 1 degs');
    end
end

if(FRQ>20)
    FRQ=20;
    disp('Clamped maximum frequency to 20 Hz');
elseif(FRQ<0.1)
    FRQ=0.1;
    disp('Clamped minimum frequency to 0.1 Hz');
end

% if(MODE==1)
%     MODE=0;
%     disp('Mode 1 (analogue tracking) prohibited in this test script')
% end

%% Open connections
TOP_DRIVE = OpenDrive('192.168.1.101',502);
BOT_DRIVE = OpenDrive('192.168.1.102',502);
pause(0.5);

%% Set drive mode, duration, frequency and amplitude
WriteToDrive(TOP_DRIVE , 1910 , floor(AMP*10) , 1);
WriteToDrive(BOT_DRIVE , 1910 , floor(AMP*10) , 1);
% WriteToDrive(TOP_DRIVE , 1910 , floor((AMP/2)*10) , 1);
% WriteToDrive(BOT_DRIVE , 1910 , floor((AMP/2)*10) , 1);
pause(0.3);
WriteToDrive(TOP_DRIVE , 1911 , floor(FRQ*10) , 1);
WriteToDrive(BOT_DRIVE , 1911 , floor(FRQ*10) , 1);
pause(0.3);
WriteToDrive(TOP_DRIVE , 1912 , MODE , 1);
WriteToDrive(BOT_DRIVE , 1912 , MODE , 1);
pause(0.3);
if(MODE==3)
    if(Negative_deflection)
        WriteToDrive(TOP_DRIVE , 1915 , 1 , 1);
        WriteToDrive(BOT_DRIVE , 1915 , 1 , 1);
        pause(0.3);
    else
        WriteToDrive(TOP_DRIVE , 1915 , 0 , 1);
        WriteToDrive(BOT_DRIVE , 1915 , 0 , 1);
        pause(0.3);
    end
end
if(MODE==4)
    WriteToDrive(TOP_DRIVE , 1913 , floor(cycle_duration*10) , 1);
    WriteToDrive(BOT_DRIVE , 1913 , floor(cycle_duration*10) , 1);
    pause(0.3);
    WriteToDrive(TOP_DRIVE , 1914 , floor(FRQ_END*10) , 1);
    WriteToDrive(BOT_DRIVE , 1914 , floor(FRQ_END*10) , 1);
    pause(0.3);
end
if(MODE==5)
    WriteToDrive(TOP_DRIVE , 1913 , floor(cycle_duration*10) , 1);
    WriteToDrive(BOT_DRIVE , 1913 , floor(cycle_duration*10) , 1);
    pause(0.3);
end
%% Start Drives
WriteToDrive(TOP_DRIVE , 1930 , 1 , 1);
WriteToDrive(BOT_DRIVE , 1930 , 1 , 1);
%% Wait before stopping the drives
pause(cycle_duration);
%% Stop Drives
WriteToDrive(TOP_DRIVE , 1930 , 0 , 1);
WriteToDrive(BOT_DRIVE , 1930 , 0 , 1);
% Close connection to drives
CloseDrive(TOP_DRIVE);
CloseDrive(BOT_DRIVE);

% eof