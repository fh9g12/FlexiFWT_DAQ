function addChannels(obj)
%ADDCHANNELS Summary of this function goes here
%   Detailed explanation goes here
%% add strain gauges
% strain gauge ch12
warning('off','nidaq:ni:propUpdatedOnAllChannels');
warning('off','nidaq:ni:variationInRates');
warning('off','daq:Session:closestRateChosen');
ch = addinput(obj,'PXI1Slot2','ai0','Bridge');
ch.BridgeMode = 'Half';
ch.ExcitationSource = 'Internal';
ch.ExcitationVoltage = 10.0;
ch.NominalBridgeResistance = 350;
ch.Name = "left_wingroot_strain";

ch = addinput(obj,'PXI1Slot2','ai6','Bridge');
ch.BridgeMode = 'Half';
ch.ExcitationSource = 'Internal';
ch.ExcitationVoltage = 10.0;
ch.NominalBridgeResistance = 350;
ch.Name = "right_wingroot_strain";

%% add encoders
% encoder @ ai0
ch = addinput(obj,'PXI1Slot7','ai0','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [-5,5]; % encoder volatge range
ch.Name = "left_fwt_enc";

% encoder @ ai0
ch = addinput(obj,'PXI1Slot7','ai1','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [-5,5]; % encoder volatge range
ch.Name = "right_fwt_enc";

% gust output
ch = addinput(obj,'PXI1Slot7','ai2','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [-10,10]; % encoder volatge range
ch.Name = "gust_vane_angle";

% Encoder3V3
ch = addinput(obj,'PXI1Slot7','ai3','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [-5,5]; % encoder volatge range
ch.Name = "encoder_3v3";

warning('on','nidaq:ni:propUpdatedOnAllChannels');
warning('on','nidaq:ni:variationInRates');
warning('on','daq:Session:closestRateChosen');
end

