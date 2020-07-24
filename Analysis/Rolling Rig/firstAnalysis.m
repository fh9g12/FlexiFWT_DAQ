load('C:\Users\PXI-1082\Documents\R Cheung\data\20March2020\Locked\trim_locked_datum_aoa0d0_v17d6_t0d0.mat')
%load('C:\Users\PXI-1082\Documents\git\FlexiFWT_DAQ\data\21-Jul-2020\RollingRig_Removed\AoA0d0\RollingRig_Removed_Steady_aoa0d0_v17d5_tf0d0_a0d0_t0d0_Run1028.mat')
%load('C:\Users\PXI-1082\Documents\git\FlexiFWT_DAQ\data\21-Jul-2020\RollingRig_Removed\AoA0d0\RollingRig_Removed_Steady_aoa0d0_v17d8_tf0d0_a0d0_t0d0_Run1029.mat')
%load('C:\Users\PXI-1082\Documents\git\FlexiFWT_DAQ\data\21-Jul-2020\RollingRig_Removed\AoA0d0\RollingRig_Removed_Steady_aoa0d0_v17d3_tf0d0_a0d0_t0d0_Run1030.mat')
load('C:\Users\PXI-1082\Documents\git\FlexiFWT_DAQ\data\21-Jul-2020\RollingRig_Removed\AoA0d0\RollingRig_Removed_Steady_aoa0d0_v22d4_tf0d0_a0d0_t0d0_Run1031.mat')
old_data = d;
t_old = d.daq.t;
load('C:\Users\PXI-1082\Documents\git\FlexiFWT_DAQ\data\20-Jul-2020\RollingRig_Fixed\AoA0d0\RollingRig_Fixed_Steady_aoa0d0_v17d4_tf0d0_a0d0_t0d0_Run1012.mat')
new_data = d;
t_new = d.daq.t;

v_old = old_data.daq.encoder.v/5*360;
v_new = new_data.daq.encoder.v/5*360;

v_new_filt = movmean(v_new,17);
v_old_filt = movmean(v_old,17);

figure(2)
hold off
plot(v_new_filt(2:end),diff(v_new_filt),'r-')
hold on
plot(v_old_filt(2:end),diff(v_old_filt),'b-')
ylim([0,0.2])


figure(1)
hold off
plot(t_old,v_old,'b-')
hold on
plot(t_new,v_new,'r-')
%load('C:\Users\PXI-1082\Documents\git\FlexiFWT_DAQ\data\20-Jul-2020\RollingRig\AoA0d0\RollingRig_Datum_aoa0d0_v0d0_t0d0_Run1008.mat')
%load('C:\Users\PXI-1082\Documents\git\FlexiFWT_DAQ\data\20-Jul-2020\RollingRig_Removed\AoA0d0\RollingRig_Removed_Steady_aoa0d0_v19d8_tf0d0_a0d0_t0d0_Run1023.mat')
load('C:\Users\PXI-1082\Documents\git\FlexiFWT_DAQ\data\21-Jul-2020\RollingRig_Removed\AoA0d0\RollingRig_Removed_Steady_aoa0d0_v17d5_tf0d0_a0d0_t0d0_Run1028.mat')
figure(3)
hold off
plot(d.daq.t,d.daq.encoder.v/5*360,'g-')
hold on 
plot(t_new,v_new,'r-')

addpath('C:\Users\PXI-1082\Documents\R Cheung\DAQ\ERA')

[f,p] = genfft(1700,v_new);
[f_old,p_old] = genfft(1700,v_old);

figure(4)
hold off
semilogy(f,p,'r')
hold on
semilogy(f_old,p_old,'b')


