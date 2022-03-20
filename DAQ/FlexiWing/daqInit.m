function [s,ch,lh,lh2] = daqInit(SampleRate)
%% Folding Wingtip WTT DAQ - Set up NI DAQ
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

daqreset
% %     % check devices
% %     vendors = daq.getVendors;
% %     devices = daq.getDevices;
%% Create Session
s = daq.createSession('ni');d = daq()
%% Set up device channels
% accelerometers ch1-7
chNameList = {'z_wg', ...
    'y_hg','z_hg','x_hg', ...
    'y_wt','z_wt','x_wt','z_wtt'};
chList = 0:7;
% chNameList{8} = {'z_wtt'};
% chList(8) = 7;
for ii = 1:length(chList)
    ch = addAnalogInputChannel(s,'PXI1Slot5', ...
        ['ai',num2str(chList(ii))],'Accelerometer');
    ch.Sensitivity = 100e-3; % 100mV/g
    ch.Name = chNameList{ii};
end
% accelerometers ch8-11
chNameList = {'x_rt','z_rt','z_wgt','z_hgt'};
chList = 0:3;
for ii = 1:length(chList)
    ch = addAnalogInputChannel(s,'PXI1Slot6', ...
        ['ai',num2str(chList(ii))],'Accelerometer');
    ch.Sensitivity = 100e-3; % 100mV/g
    ch.Name = chNameList{ii};
end

% strain gauge ch12
ch = addAnalogInputChannel(s,'PXI1Slot2','ai0','Bridge');
ch.BridgeMode = 'Full';
ch.NominalBridgeResistance = 350;
ch.ExcitationVoltage = 10.0;
ch.Name = 'wingroot_strain';
% disp(ch)

% loadcell [root_fx,root_fy,root_mx,root_my,bearing_fz] => ch13-ch17
chNameList = {'fx_rt','fy_rt','mx_rt','my_rt','fz_br'};
chList = [0:4];
for ii = 1:length(chList)
    ch = addAnalogInputChannel(s,'PXI1Slot7', ...
        ['ai',num2str(chList(ii))],'Voltage');
    ch.TerminalConfig = 'Differential';
    ch.Range = [-10,10]; % volatge range
    ch.Name = chNameList{ii};
end


% dummy signal @ ch18
ch = addAnalogInputChannel(s,'PXI1Slot7','ai5','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [-5,5]; % volatge range
ch.Name = 'dummy';

d
% sync signal @ ch20
ch = addAnalogInputChannel(s,'PXI1Slot7','ai19','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [-10,10]; % volatge range
ch.Name = 'sync';


% servo signal @ ch21
ch = addAnalogInputChannel(s,'PXI1Slot7','ai20','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [-10,10]; % volatge range
ch.Name = 'servo';


% gust signal @ ch22
ch = addAnalogInputChannel(s,'PXI1Slot7','ai21','Voltage');
ch.TerminalConfig = 'Differential';
ch.Range = [-10,10]; % volatge range
ch.Name = 'gust';



% Output - Sync
ch = addAnalogOutputChannel(s,'PXI1Slot7','ao0','Voltage');
ch.TerminalConfig = 'SingleEnded'; % hardware only supports single-ended
ch.Range = [-10,10]; % volatge range
ch.Name = 'sync_out';
% Output - Servo signal
ch = addAnalogOutputChannel(s,'PXI1Slot7','ao1','Voltage');
ch.TerminalConfig = 'SingleEnded'; % hardware only supports single-ended
ch.Range = [-10,10]; % volatge range
ch.Name = 'servo_out';
% % Output - gust vane signal
% ch = addAnalogOutputChannel(s,'PXI1Slot7','ao2','Voltage');
% ch.TerminalConfig = 'SingleEnded'; % hardware only supports single-ended
% ch.Range = [-10,10]; % volatge range
% ch.Name = 'gust_out';
%% Sampling Rate
s.Rate = SampleRate; % Hz
%% setup listeners for background DAQ
lh = s.addlistener('DataAvailable', @saveBgData);
lh2 = s.addlistener('DataRequired', @(src,event) src.queueOutputData(d));
%% Display setup
disp(s)
end