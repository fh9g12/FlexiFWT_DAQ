function [alpha] = findAlpha(q,S,x,theta,m,g,L,gamma)
% all inputs are column vectors
% dAlpha from theta
dAlpha = -atan(tan(theta).*sin(gamma));
% Ax = b
b = m*g*L.*cos(theta)./q./S;
A = [dAlpha.^3,dAlpha.^2,dAlpha,1./q./S];
alpha = b-A*x(2:end,:);
alpha = alpha/x(1,1);

% A = [dAlpha.^2,dAlpha,1./q./S];
% r = b-A*x(4:end,:);
% alpha = zeros(length(r),3);
% for ii = 1:length(r)
%     alpha(ii,:) = roots([x(1:3,:)',-r(ii,1)])';
% end
end