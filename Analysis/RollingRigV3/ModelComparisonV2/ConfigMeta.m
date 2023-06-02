classdef ConfigMeta
    %CONFIGMETA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Enviroment
        Config
        Flare
        Camber
        Color
        Scaling
        Label
        LineSpec
        T
    end
    
    methods
        function obj = ConfigMeta(Config,Flare,Camber,Color,Scaling,Label,LineSpec)
            %CONFIGMETA Construct an instance of this class
            %   Detailed explanation goes here
            obj.Config = Config;
            obj.Flare = Flare;
            obj.Camber = Camber;
            obj.Color = Color;
            obj.Scaling = Scaling;
            obj.Label = Label;
            obj.LineSpec = LineSpec;
        end
        function obj = set_enviroment(obj,env,LineSpec)
            obj.Enviroment = env;
            if exist('LineSpec','var')
                obj.LineSpec = LineSpec;
            end
        end
        function obj = set_T(obj,T)
            obj.T = T;
        end
        function obj = set_Label(obj,Label)
            obj.Label = Label;
        end
        
        function f = create_filter(obj)
            f ={};
            f{1} = {'MassConfig',obj.Config};
            f{2} = {'FlareAngle',obj.Flare};
            f{3} = {'CamberAngle',obj.Camber};
            f{4} = {'Source',obj.Enviroment};
            f{5} = {'T',obj.T};
        end
    end
    methods(Static)
        function obj = CreateMeta(config)
%             colors = fh.colors.linspecer(12,'qualitative');
            switch config
                case 'removed'
                    obj = ConfigMeta('RollingRig_Removed',[],0,[0 1 0],@(x,y)1,'Removed Case','-');
                case 'fixed'
                    obj = ConfigMeta('RollingRig_Fixed',[],0,[1 0 0],@(x,y)1,'Fixed Case','-');
                case 'free10'
                    obj = ConfigMeta('RollingRig_Free',10,0, [1 1 0],@(x,y)1,'10 Degrees Flare','-');
                case 'free30'
                    obj = ConfigMeta('RollingRig_Free',30,0, [0 1 1],@(x,y)1,'30 Degrees Flare','-');
            end
        end
    end
end

