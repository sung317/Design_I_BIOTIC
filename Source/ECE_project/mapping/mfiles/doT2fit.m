function [T2Est, bEst, aEst, res] = doT2fit(data, nlsS)
    
if ( length(data) ~= nlsS.N )
  error('nlsS.N and data must be of equal length!')
end

% Make sure the data come in increasing TI-order
[tVec,order] = sort(nlsS.tVec); 
data = squeeze(data); 
data = data(order);

% Make sure data vector is a column vector
data = data(:);

% Uncomment this block for linear fit - does not work well with short-T2 Bruker data
% data = log(data(:));
% beta = polyfit(tVec,data,1);
% T2Est = -1/beta(1);
% bEst = exp(beta(2));
% aEst = 0;
% if abs(T2Est) > 4e3
%   T2Est = 4e3;
% end

% Uncomment this block for exponential fit
options = statset('MaxIter', 100, 'TolFun', 1e-6, 'TolX', 1e-6, 'Display', 'off', 'Robust', 'on');
beta = lsqcurvefit(@T2_eqn,[mean(tVec),max(data),0],tVec,data,[0,0,0],[20*max(tVec),10*max(data),2*min(data)+1],options);
aEst = beta(3);
bEst = beta(2);
T2Est = beta(1);

res = 0;

function y = T2_eqn(param,t)
  % Define parameters to calculate using regression / minimize least squares
  T2 = param(1);
  M0 = param(2);
  B  = param(3);
  y = M0*exp(-t/T2);%+B;
end

end
