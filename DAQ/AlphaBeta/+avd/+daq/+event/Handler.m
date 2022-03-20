function Handler(src,varargin)
%Handler An event Handler to decide with function is used when a DAQ event
%is called
%   Authors: Fintan Healy, Lucian Constantin
%   Email:  fintan.healy@bristol.ac.uk
%   Date:   15/09/2021
    p = inputParser;
    p.addParameter('Init',false);
    p.parse(varargin{:});

    global CurrentEvnt
    persistent LastEvnt

    if p.Results.Init
       clear LastEvnt
       return 
    end

    try
        if isempty(CurrentEvnt)
            CurrentEvnt = @avd.daq.event.DoNothing;
        end
        if ~isequal(LastEvnt,CurrentEvnt)
            CurrentEvnt(src,'Init',true);
        end
        CurrentEvnt(src)
        LastEvnt = CurrentEvnt;
    catch err
        disp(err)
        CurrentEvnt = @avd.daq.event.DoNothing;
        src.stop; 
    end
end

