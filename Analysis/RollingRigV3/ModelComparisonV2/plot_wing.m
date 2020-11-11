function h = plot_wing(roll,fold,s,varargin)
    p = inputParser;
    p.addParameter('sigma',0.272)
    p.addParameter('Label','')
    p.addParameter('Legend',false)
    p.parse(varargin{:})
    
    sigma = p.Results.sigma;
      
    % x,y along inner wing as percentage (1 tip,0 root)
    wing_x = @(x) s*x*(1-sigma)*cosd(-roll);
    wing_y = @(x) s*x*(1-sigma)*sind(-roll);
    
    % x,y along fwt relative to hinge  as percentage (1 tip,0 root)
    fwt_x = @(x)s*x*sigma*cosd(-roll-fold);
    fwt_y = @(x)s*x*sigma*sind(-roll-fold);
    
    % x,y along fwt relative to centre  as percentage (1 tip,0 root)
    f_x = @(x)wing_x(1)+fwt_x(x);
    f_y = @(x)wing_y(1)+fwt_y(x);
    
    
    x_text = f_x(1.25);
    y_text = f_y(1.25);
    
    % plot hinge
    h = plot(wing_x(1),wing_y(1),'o');
    h.MarkerFaceColor = [0 0 0];
    h.MarkerSize = 6;
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold on   
    
    % calculte magnitude of each force
    g = sum([-0.3,0].*[fwt_x(1),fwt_y(1)]./norm([fwt_x(1),fwt_y(1)])); 
    centri = -0.15*sind(-fold);
    lift = -g-centri;
    
    %plot centrifugal vector
    centri_vec = [centri*cosd(-roll-fold+90),centri*sind(-roll-fold+90)];  
    q = plot_quiver(f_x(0.4),f_y(0.4),centri_vec(1),centri_vec(2),'r','Centrifugal Force'); 
    if ~p.Results.Legend
        q.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    %plot grav vector
    q = plot_quiver(f_x(0.5),f_y(0.5),0,-0.2,[0 0.6 0],'Gravitational Force');  
    if ~p.Results.Legend
        q.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    disp(['g: ',num2str(g),' centri: ',num2str(centri),' Lift: ',num2str(lift)])
    
    % plot lift vector
    lift_vec = [lift*cosd(-roll-fold+90),lift*sind(-roll-fold+90)];    
    q = plot_quiver(f_x(0.6),f_y(0.6),lift_vec(1),lift_vec(2),'b','Lift Force'); 
    if ~p.Results.Legend
        q.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    h = plot([0,wing_x(1),f_x(1)],[0,wing_y(1),f_y(1)],'k-');
    h.LineWidth = 2;
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    t = text(x_text,y_text,p.Results.Label);
    t.FontSize = 13;
end

function q = plot_quiver(x,y,u,v,color,Label)
    q = quiver(x,y,u,v);
    q.Color = color;
    q.AutoScale = 'off';
    q.MaxHeadSize = 0.5;
    q.LineWidth = 2;
    q.LineStyle = '-';
    q.DisplayName = Label;
end
