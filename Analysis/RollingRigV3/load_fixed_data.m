function SimData = load_fixed_data(filename)
T = readtable(filename);
SimData = struct();

mode = string(unique(T.Mode));
velocity = unique(T.V);
torque = unique(T.beta);
AileronAngle = unique(T.AileronAngle);
flare = unique(T.Lambda);
camber = unique(T.alpha_c);
liftDist = unique(T.LiftDist);
time_const = unique(T.T);


i = 1;
for t_i = 1:length(time_const)
for l_i = 1:length(liftDist)
    for f_i = 1:length(flare)
        for v_i = 1:length(velocity)
            for a_i = 1:length(AileronAngle)
                for c_i = 1:length(camber)
                    for m_i = 1:length(mode)
                        SimData(i).Source = 'sim';
                        SimData(i).Locked = true;
                        SimData(i).FlareAngle = round(rad2deg(flare(f_i)));
                        SimData(i).CamberAngle = round(rad2deg(camber(c_i)));
                        SimData(i).LiftDist = liftDist(l_i);
                        SimData(i).T = time_const(t_i);
                        switch mode(m_i)
                            case 'Locked'
                                SimData(i).MassConfig = 'RollingRig_Fixed';
                            case 'Removed'
                                SimData(i).MassConfig = 'RollingRig_Removed';
                            case 'Free'
                                SimData(i).MassConfig = 'RollingRig_Free';
                        end
                        SimData(i).Velocity = velocity(v_i);
                        SimData(i).AileronAngle = AileronAngle(a_i);
                        I = strcmp(T.Mode,mode(m_i));
                        I = I & T.V == velocity(v_i);
                        I = I & T.AileronAngle == AileronAngle(a_i);
                        I = I & T.Lambda == flare(f_i);      
                        I = I & T.alpha_c == camber(c_i);
                        I = I & strcmp(T.LiftDist,liftDist(l_i));
                        I = I & T.T == time_const(t_i);
                        SimData(i).t = T.t(I);

                        % make sim ts_data
                        SimData(i).ts_data = zeros(length(SimData(i).t),4);

                        SimData(i).ts_data(:,1) = rad2deg(T.Roll(I));
                        SimData(i).ts_data(:,2) = SimData(i).ts_data(:,1);
                        SimData(i).RollRate = rad2deg(T.RollRate(I));
                        SimData(i).ts_data(:,3) = rad2deg(T.RightFWTAngle(I));
                        SimData(i).LeftFWTVelocity = rad2deg(T.LeftFWTVelocity(I));
                        SimData(i).ts_data(:,4) = rad2deg(T.LeftFWTAngle(I));
                        SimData(i).RightFWTVelocity = rad2deg(T.RightFWTVelocity(I));
                        i = i+1;
                    end
                end
            end
        end
    end
end
end
end






