function [] = setGustVanes(TOP_DRIVE,BOT_DRIVE,MODE,FRQ,AMP)

%     Amplitude 0-X degrees => Max value 20 deg
%     Frequency in Hz => Max value 14 Hz
%     Modes => 3 single, 2 continuous, 1 analogue, 0 off

    % Sanity check the inputs
    if (AMP>20)
        AMP=20;
        disp('Clamped maximum amplitude to 25 degs');
    elseif (AMP<1)
        AMP=1;
        disp('Clamped minimum amplitude to 1 degs');
    end

    if (FRQ>20)
        FRQ=20;
        disp('Clamped maximum frequency to 15 Hz');
    elseif (FRQ<0.1)
        FRQ=0.1;
        disp('Clamped minimum frequency to 0.1 Hz');
    end

    % Set the drive mode, frequency, and amplitude
    WriteToDrive(TOP_DRIVE,1910,floor((AMP)*10),1);
    WriteToDrive(BOT_DRIVE,1910,floor((AMP)*10),1);
    pause(0.3);
    WriteToDrive(TOP_DRIVE,1911,floor(FRQ*10),1);
    WriteToDrive(BOT_DRIVE,1911,floor(FRQ*10),1);
    pause(0.3);
    WriteToDrive(TOP_DRIVE,1912,MODE,1);
    WriteToDrive(BOT_DRIVE,1912,MODE,1);
    pause(0.3);
end
