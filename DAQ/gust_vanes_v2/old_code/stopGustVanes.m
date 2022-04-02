function [] = stopGustVanes(TOP_DRIVE,BOT_DRIVE)
    % Close the drive connections
    CloseDrive(TOP_DRIVE);
    CloseDrive(BOT_DRIVE);
end
