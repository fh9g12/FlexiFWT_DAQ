function [data] = postProcessData(obj,data)
%POSTPROCESSDATA Summary of this function goes here
%   Detailed explanation goes here

data.daq.left_wingroot_strain.val = linearCalibration(...
    data.daq.left_wingroot_strain.raw,587.7622,-0.1447);
data.daq.left_wingroot_strain.gain = 587.7622;
data.daq.left_wingroot_strain.intercept = -0.1447;

data.daq.right_wingroot_strain.val = linearCalibration(...
    data.daq.right_wingroot_strain.raw,572.0144,-0.0643);
data.daq.right_wingroot_strain.gain = 572.0144;
data.daq.right_wingroot_strain.intercept = -0.0643;

data.daq.right_fwt_enc.val = linearCalibration(...
    data.daq.right_fwt_enc.raw,107.6119,-179.23);
data.daq.right_fwt_enc.gain = 107.6119;
data.daq.right_fwt_enc.intercept = -179.23;

data.daq.left_fwt_enc.val = linearCalibration(...
    data.daq.left_fwt_enc.raw,-108.564,180.3207);
data.daq.left_fwt_enc.gain = -108.564;
data.daq.left_fwt_enc.intercept = 180.3207;

data.daq.gust_vane_angle.val = linearCalibration(...
    data.daq.gust_vane_angle.raw,6,0);

data.daq.encoder_3v3.val = data.daq.encoder_3v3.raw;
end

