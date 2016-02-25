% nlsS = getNLSStruct_T2( extra, dispOn)
%
% extra.tVec    : defining TEs 
% extra.T2Vec   : defining T2s
% dispOn        : 1 - display the struct at the end
%                 0 (or omitted) - no display
%
% Data Model    : a + b*exp(-TE/T2) 
%    
% modified by James Rioux, based on code
% written by J. Barral, M. Etezadi-Amoli, E. Gudmundson, and N. Stikov, 2009
%  (c) Board of Trustees, Leland Stanford Junior University 

function nlsS = getNLSStruct_T2(extra, dispOn)

nlsS.tVec = extra.tVec(:);
nlsS.N = length(nlsS.tVec);
nlsS.T2Vec = extra.T2Vec(:);
nlsS.T2Start = nlsS.T2Vec(1);
nlsS.T2Stop = nlsS.T2Vec(end);
nlsS.T2Len = length(nlsS.T2Vec);

% Display the struct so that the user can see it went ok
if nargin < 2 
  dispOn = 0;
end
	
if dispOn
  % Display the structure for inspection
  nlsS
end
   
end 

