% -------------------------------------------------------------------------
% Correlation integral
% -------------------------------------------------------------------------
% Input: X    - embedded time series
%        emin - log of minimum value of epsilon (e.g. -2)
%        emax - log of maximum value of epsilon (e.g. 2)
%
% Output: C - correlation integral
%         e - epsilon (spatial separation)
% 
% Example: [C,e]=correlint(X,-2,3);
%          plot(log(e(2:end)),diff(log(C))./diff(log(e))); (for estimation
%          of the correlation dimension)
% -------------------------------------------------------------------------
% Copyright (C) 2013 Philip Clemson, Lancaster University
%
% This file is part of TACTS.
%
% TACTS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% TACTS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with TACTS.  If not, see <http://www.gnu.org/licenses/>.
% -------------------------------------------------------------------------

function [C,e]=correlint(X,emin,emax)

L=length(X);

% e=logspace(emin,emax,500);
e=logspace(emin,emax,20);

K=length(e);

C=zeros(1,length(e));

k=1;

% w=waitbar(0);

while k<K+1

disp(['k --> ',num2str(k)])    
    
for i=1:L
%     disp(['i --> ',num2str(i)])
    Y=sqrt(sum(bsxfun(@minus,X,X(:,i)).^2));
    ind=find(Y<e(k));
    C(k)=C(k)+length(ind);
end

C(k)=(C(k)-L)/(L*(L-1));

% waitbar(k/(K+1))

k=k+1;

end

% close(w);

end
