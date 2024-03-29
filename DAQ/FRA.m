 function [FRF, dft_a, dft_b] = FRA(a,b,f,Fs,N)

% FRA - Frequency Response Analyzer
% Applies Hanning window and then computes FRF point from stepped sine measurement. It uses Goertzel algorithm for computation of discrete Fourier transform 
% 
%   FRF = FRA(a,b,f,Fs)
%   FRF = FRA(a,b,f,Fs,N)
%
% Input parameters:
%   a ... excitation signal - vector (n,1)
%   b ... output signal in steady state - vector(n,1)
%   f ... frequency of interest (excitation frequency) [Hz]
%   Fs ... sampling frequency [Hz]
%   N ... number of points for calculation (N last points from a,b), N should be as high as possible (N < numel(a)) - default: 100 
%
% Output parameters:  
%   FRF - one points of frequency response function at given frequency (f) - compex scalar (1,1)
%
% Example:
%   Fs = 1000;  
%   f = 50; 
%   t = linspace(0,1,Fs);
%   a = sin(2*pi*50*t)';
%   b = 2*sin(2*pi*50*t + pi)';
%   FRF = FRA(a,b,f,Fs);
%   FRF = FRA(a,b,f,Fs,500);
%
% Referencies:
%   [1] Ewins D.J.: Modal Testing: theory, practice and application, 2001
%
% Created by Vaclav Ondra, 20th Jul 2014, Matlab 2014a,

    if nargin == 4 % only 4 inputs entered
        N = 100; % default value for points
    end
    
    win = hann(N); % hanning window
    a = a(end-N+1:end).*win; % application of window on the signal, just in steady state (given by N)
    b = b(end-N+1:end).*win;

    freq_index = round(f/Fs*N)+1; % index of frequency which will be computed

    
    dft_a = 2*2*goertzel(a,freq_index)/N; % DFT computed using Goertzel algorithm - System Processing Toolbox is needed
    dft_b = 2*2*goertzel(b,freq_index)/N; % corrections: first '2' for Hanning window, and '2/N' for the algorithm

    FRF = dft_b/dft_a; % FRF estimate

end
