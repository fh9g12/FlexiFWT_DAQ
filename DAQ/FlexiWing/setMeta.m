function d = setMeta(d,varargin)
%% Folding Wingtip WTT DAQ - Set Metadata
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

iMax = floor(size(varargin,2)/2);
for ii = 1:iMax
    if(isfield(d,varargin{ii*2-1}))
        d = setfield(d,varargin{ii*2-1},varargin{ii*2});
    else
        fprintf('Unable to set %s\n',varargin{ii*2-1});
    end
end
end