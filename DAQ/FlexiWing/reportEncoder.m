function [] = reportEncoder(d)
v = mean(d.daq.encoder.v);
m = d.daq.encoder.calibration.slope;
c = d.daq.encoder.calibration.constant;
fprintf('Mean Encoder Voltage: %f v\n',v);
fprintf('Mean Encoder Angle: %5.2f deg\n',m*v+c);
end