function [d,testType] = massDistro(d,caseID)
% Mass Cases
switch(caseID)
    case(1) % empty
        testType = 'mEmpty';
    case(2) % 1/4 mass case
        testType = 'mQtr';
        d.inertia.position_10 = setMeta(d.inertia.position_10,'mass',87.6e-3);
    case(3) % 1/2 mass case
        testType = 'mHalf';
        d.inertia.position_6 = setMeta(d.inertia.position_6,'mass',87.7e-3);
        d.inertia.position_8 = setMeta(d.inertia.position_8,'mass',87.8e-3);
    case(4) % 3/4 mass case
        testType = 'm3Qtr';
        d.inertia.position_4 = setMeta(d.inertia.position_4,'mass',87.6e-3);
        d.inertia.position_8 = setMeta(d.inertia.position_8,'mass',87.8e-3);
        d.inertia.position_10 = setMeta(d.inertia.position_10,'mass',87.6e-3);
    case(5) % full mass case
        testType = 'mFull';
        d.inertia.position_4 = setMeta(d.inertia.position_4,'mass',87.6e-3);
        d.inertia.position_6 = setMeta(d.inertia.position_6,'mass',87.7e-3);
        d.inertia.position_8 = setMeta(d.inertia.position_8,'mass',87.8e-3);
        d.inertia.position_10 = setMeta(d.inertia.position_10,'mass',87.6e-3);
    case(6) % 1/4 mass case inner
        testType = 'mQtr_inner';
        d.inertia.position_0 = setMeta(d.inertia.position_0,'mass',87.6e-3);
    case(7) % tab wingtip
        testType = 'servo_fwt';
end
end