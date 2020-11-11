classdef OperatingPoint
    %OPERATINGPOINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        semi_span
        sigma
        V
        roll_rate = 0
        roll_angle = 0
        flare  
        cl
        y_cl
        rho = 1.225
        c = 0.067
        root_aoa = 0
        m = 0
        l = 0
        g = 9.81
    end
    methods
        function hp = hinge_pos(obj)
            hp = obj.semi_span*(1-obj.sigma);
        end
        function aoa = fwt_geom_aoa(obj,fold_angle)
            aoa = atand(sind(fold_angle)*sind(obj.flare));
        end
        function aoas = spanwise_aoa(obj,y,fold_angle)
            aoas = zeros(size(y));
            fwt_ind = y>= obj.hinge_pos();
            aoas(~fwt_ind) = rad2deg(-y(~fwt_ind)*deg2rad(obj.roll_rate)/obj.V) + obj.root_aoa;
            
            hinge_dist = y(fwt_ind)-obj.hinge_pos();
            y(fwt_ind) = (hinge_dist*sind(fold_angle)).^2 + (obj.hinge_pos()+cosd(fold_angle)*hinge_dist).^2;
            y(fwt_ind) = sqrt(y(fwt_ind));
            aoas(fwt_ind) = obj.hinge_pos() + (y(fwt_ind)-obj.hinge_pos())*cosd(fold_angle);
            aoas(fwt_ind) = -aoas(fwt_ind) * deg2rad(obj.roll_rate) * cosd(fold_angle) /obj.V;
            aoas(fwt_ind) = rad2deg(aoas(fwt_ind)) + obj.fwt_geom_aoa(fold_angle) + obj.root_aoa;
        end
        function L_y = spanwise_lift(obj,y,fold_angle)
            y_delta = y(2)-y(1);
            aoas = obj.spanwise_aoa(y,fold_angle);
            c_l = interp1(obj.y_cl,obj.cl,y);
            L_y = 0.5*obj.rho*obj.V^2*obj.c.*deg2rad(aoas).*c_l*y_delta;            
        end
        function m = hinge_moment(obj,y,fold_angle)
            m = -obj.lift_hinge_moment(y,fold_angle);
            m = m - obj.grav_hinge_moment(fold_angle);
            m = m - obj.centripital_hinge_moment(fold_angle);
        end
        
        function f = hinge_force(obj,y,fold_angle)
            f = obj.lift_hinge_force(y,fold_angle);
            f = f + (-cosd(obj.roll_angle)*obj.g*obj.m);
            f = f*cosd(fold_angle);
        end
        
        function m = lift_hinge_moment(obj,y,fold_angle)
            L_y = obj.spanwise_lift(y,fold_angle);
            ind = y>=obj.hinge_pos();
            m = sum(L_y(ind).*(y(ind)-obj.hinge_pos()));
        end
        function f = lift_hinge_force(obj,y,fold_angle)
            L_y = obj.spanwise_lift(y,fold_angle);
            ind = y>=obj.hinge_pos();
            f = sum(L_y(ind));
        end
        function f = grav_hinge_force(obj,fold_angle)
            f = -cosd(obj.roll_angle - fold_angle)*obj.g*obj.m;
        end
        
        function m = grav_hinge_moment(obj,fold_angle)
            m = obj.grav_hinge_force(fold_angle)*obj.l;
        end
        function m = centripital_hinge_moment(obj,fold_angle)
            m = obj.m*obj.l*obj.semi_span*(1-obj.sigma)*sind(fold_angle)*deg2rad(obj.roll_rate).^2;
        end
        function obj = load_dist(obj,file)
            T = readtable(file);
            obj.cl = T.C_l;
            obj.y_cl = T.y;
        end
        function m = fwt_roll_damping(obj,y,fold_angle)
            ind = y >= obj.hinge_pos();
            L_y = obj.spanwise_lift(y,fold_angle);
            m = sum(L_y(ind).*cosd(fold_angle)).*obj.hinge_pos();
            m = m + sum(y(~ind).*L_y(~ind));
        end
    end
end

