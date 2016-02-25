function [sigma,mu,A,skew] = customGaussFit_new(x,y,h)

%% threshold
if nargin == 2, h=0.2; end

%% cutting
ymax = max(y);
xnew = [];
ynew = [];

for n = 1:length(x)
    if y(n) > ymax*h;
        xnew = [xnew,x(n)];
        ynew = [ynew,y(n)];
    end
end

% JR added 07/19/13 to ensure at least 3 points fitted
if length(ynew) < 3
  xnew = x(y>0);
  ynew = y(y>0);
end

% %% fitting
% ylog = log(ynew);
% xlog = xnew;
% p = polyfit(xlog,ylog,2);
% A2 = p(1);
% A1 = p(2);
% A0 = p(3);
% sigma = sqrt(-1/(2*A2));
% mu = A1*sigma^2;
% A = exp(A0+mu^2/(2*sigma^2));

options = statset('MaxIter', 100, 'TolFun', 1e-6, 'TolX', 1e-6, 'Display', 'off', 'Robust', 'on');
beta = lsqcurvefit(@myGauss_skewed,[mean(xnew),mean(ynew),0,0],xnew,ynew,[0,0,0,0],[max(xnew),max(xnew),max(ynew),10],options);
skew = beta(4);
A = beta(3);
sigma = beta(2);
mu = beta(1);

function y = myGauss(param,t)
  mu    = param(1);
  sigma = param(2);
  A     = param(3);
  y = A .* exp(-(t-mu).^2 ./ (2.*sigma.^2));
end

function y = myGauss_skewed(param,t)
  mu    = param(1);
  sigma = param(2);
  A     = param(3);
  skew  = param(4);
  y = A .* exp(-(t-mu).^2 ./ (2.*sigma.^2)) .* (1 + erf(skew .* (t-mu) ./ sigma) );
end

end
