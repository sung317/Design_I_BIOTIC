function [T1L, T1S, ctheta1, ctheta2, M0L, M0S, res] = T1BiexpFit(data, nlsS)

if ( length(data) ~= nlsS.N )
  error('nlsS.N and data must be of equal length!')
end

% Make sure the data come in increasing TI-order
[tVec,order] = sort(nlsS.tVec); 
data = squeeze(data); 
data = data(order);

% Make sure data vector is a column vector
data = data(:);

options = statset('MaxIter', 100, 'TolFun', 1e-6, 'TolX', 1e-6, 'Display', 'off', 'Robust', 'on');
[~,minind] = min(data);

% Get initial guess from mono-exponential fit
[T1Est_init, b_init, a_init, res] = rdNlsPr(data,nlsS);
IE_init = (1-a_init./-b_init) ./ (exp(-6000./T1Est_init) - a_init./-b_init);

if (IE_init > 1) || (IE_init < -2) % || (T1Est_init>1500) || (T1Est_init <1000)
  T1L = 0;
  T1S = 0;
  ctheta1 = 0;
  ctheta2 = 0;
  M0L = 0;
  M0S = 0;
  res = -1;
  return;
end

beta0 = [T1Est_init,0.1*T1Est_init,-1,-1,0.8*max(data),0.2*max(data)];
betaMin = [0,0,-1,-1,0,0];
betaMax = [max(tVec),max(tVec),1,1,5*max(data),5*max(data)];
%betaMax = [max(tVec),max(tVec),-0.999,-0.999,5*max(data),5*max(data)];
[beta,res] = lsqcurvefit(@T1bi_eqn,beta0,tVec,data,betaMin,betaMax,options);

if beta(1) > beta(2)
  T1L = beta(1);
  T1S = beta(2);
  ctheta1 = beta(3);
  ctheta2 = beta(4);
  M0L = beta(5);
  M0S = beta(6);
else
  T1L = beta(2);
  T1S = beta(1);
  ctheta1 = beta(4);
  ctheta2 = beta(3);
  M0L = beta(6);
  M0S = beta(5);
end

return;

function y = T1bi_eqn(param,t)
  % Define parameters to calculate using regression / minimize least squares
  T1L = param(1);
  T1S = param(2);
  TR = 6000;
  cos_theta1 = param(3);
  cos_theta2 = param(4);
  M0L = param(5);
  M0S = param(6);
  
  %y = abs(M0a * (1 - (1-IE)*exp(-t/T1a)) + M0b * (1 - (1-IE)*exp(-t/T1b)));
%  y = abs( M0L * (1 - cos_theta1*exp(-TR/T1L) - (1-cos_theta1)*(exp(-t/T1L))) / (1 - cos_theta1 * cos_theta2 * exp(-TR/T1L)) + ...
%           M0S * (1 - cos_theta1*exp(-TR/T1S) - (1-cos_theta1)*(exp(-t/T1S))) / (1 - cos_theta1 * cos_theta2 * exp(-TR/T1S)) );
  y = abs( M0L * (1 - cos_theta1*exp(-TR/T1L) - (1-cos_theta1)*(exp(-t/T1L)))  + ...
           M0S * (1 - cos_theta2*exp(-TR/T1S) - (1-cos_theta2)*(exp(-t/T1S))) );

end

end
