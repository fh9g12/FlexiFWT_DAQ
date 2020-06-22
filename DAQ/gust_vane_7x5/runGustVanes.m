function [] = runGustVanes(TOP_DRIVE,BOT_DRIVE,cycle_duration)
    % Start the drives
    WriteToDrive(TOP_DRIVE,1930,1,1);
    WriteToDrive(BOT_DRIVE,1930,1,1);

    % Wait some time then stop the drives
    pause(cycle_duration);
    WriteToDrive(TOP_DRIVE,1930,0,1);
    WriteToDrive(BOT_DRIVE,1930,0,1);
end
