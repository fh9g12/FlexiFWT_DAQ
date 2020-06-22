function [x] = fitCL(q,S,alpha,theta,m,g,L,gamma)
% all inputs are column vectors
% dAlpha from theta
dAlpha = -atan(tan(theta).*sin(gamma));
% Ax = b
A = [alpha,dAlpha.^3,dAlpha.^2,dAlpha,1./q./S];
% A = [alpha.^3,alpha.^2,alpha,dAlpha.^2,dAlpha,1./q./S];
b = m*g*L.*cos(theta)./q./S;
x = A\b;
end