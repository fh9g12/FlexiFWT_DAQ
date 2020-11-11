function SimData = load_SimData(files)
%LOAD_SIMDATA Summary of this function goes here
%   Detailed explanation goes here
SimData = load_fixed_data(files(1));
for i = 2:length(files)
    SimData = [SimData , load_fixed_data(files(i))];
end
end

