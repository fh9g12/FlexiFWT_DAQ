function d = initDAQ(obj)
%INITDAQ Summary of this function goes here
%   Detailed explanation goes here
daqreset;
d = daq('ni');
d.Rate = obj.SampleRate;

%% add strain gauges
% strain gauge ch12
ch = addinput(d,'PXI1Slot2','ai0','Bridge');
ch.BridgeMode = 'Half';
ch.ExcitationSource = 'Internal';
ch.ExcitationVoltage = 10.0;
ch.NominalBridgeResistance = 350;
ch.Name = 'left_wingroot_strain';

ch = addinput(d,'PXI1Slot2','ai6','Bridge');
ch.BridgeMode = 'Half';
ch.ExcitationSource = 'Internal';
ch.ExcitationVoltage = 10.0;
ch.NominalBridgeResistance = 350;
ch.Name = 'right_wingroot_strain';

%% add encoders
% encoder @ ai0
ch = addinput(s,'PXI1Slot7','ai0','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [0,4]; % encoder volatge range
ch.Name = 'left_encoder';

% encoder @ ai0
ch = addinput(s,'PXI1Slot7','ai1','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [0,4]; % encoder volatge range
ch.Name = 'right_encoder';

end

