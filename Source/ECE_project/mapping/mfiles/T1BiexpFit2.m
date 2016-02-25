function [T1S, ctheta1, ctheta2, M0L, M0S, res] = T1BiexpFit2(data, nlsS, T1L)

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

beta0 = [T1L,0.1*T1L,-1,-1,0.8*max(data),0.2*max(data)];
betaMin = [T1L,0,-1,-1,0,0];
betaMax = [1.001*T1L,max(tVec),1,1,5*max(data),5*max(data)];
[beta,res] = lsqcurvefit(@T1bi_eqn,beta0,tVec,data,betaMin,betaMax,options);
T1S = beta(2);
ctheta1 = beta(3);
ctheta2 = beta(4);
M0L = beta(5);
M0S = beta(6);

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
  
  y = abs( M0L * (1 - cos_theta1*exp(-TR/T1L) - (1-cos_theta1)*(exp(-t/T1L)))  + ...
           M0S * (1 - cos_theta2*exp(-TR/T1S) - (1-cos_theta2)*(exp(-t/T1S))) );

end

end
