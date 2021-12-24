% 
% function [FD,SE,LE,CD]=nonlin_measures(RR,n)
% % Input:    RR      RR interval time series
% % Output:   FD      Fractal Dimension using boxcounting method
% %           SE      Sample Entropy
% %           LE      Largest Lyapunov Exponent
% %           CD      Correlation Dimension
% % 
% fs = 2;
% time = cumsum(RR/1000); % Time in seconds
% time_new = 0:1/fs:time(end)-time(1);  
% RR_resamp = spline(time-time(1),RR,time_new); 
% % *************************************************************************
% %% Fractal Dimension
% FD = boxcount([time_new',RR_resamp'],7,0);
% 
% % *************************************************************************
% %% Sample Entropy
% dim = 2;  % Embedded dimension
% r  = 0.2*std(RR); % Tolerance (typically 0.2 * std)
% SE = SampEn(dim,r,RR);
% 
% % *************************************************************************
% %% Lyapunov Exponent
% LE = LyapunovExponent(time_new',RR_resamp');
% if isempty(LE)
%     LE = Inf;
% end
% 
% % *************************************************************************
% %% Correlation Dimension
% %-- The most accurate 
% 
% % dim = 8;    % Embedding dimension
% % tau = 1;    % Time delay
% % [logCr{i},logr{i}]=gencorint(RR_resamp,dim,tau);
% % %Derive Correlation Dimension (m=8) from the outputs given above
% % p  = polyfit(logr,logCr);
% % CD = p(2);
% 
% 
% %%-- The intermediate solution
% 
% % dim = 8;    % Embedding dimension
% % tau = 1;    % Time delay
% % 
% % X            = embed(RR_resamp,1,8);
% % 
% % emax         = 0;
% % emin         = 2;
% % 
% % [C,e]        = correlint(X,emin,emax);
% % %Derive Correlation Dimension (m=8) from the outputs given above
% % p  = polyfit(log(e((1:15))),log(C(1:15)),1)
% % CD = p(1)
% 
% %%--The fastes approach (only with >=Matlab2018a)
% MinR  = 10e-4;
% MaxR  = 100;
% tau   = 1;
% dim   = 4;
% Np    = 30;
% % CD = correlationDimension(RR,tau,dim,'MinRadius',MinR,'MaxRadius',MaxR,'NumPoints',Np);
% CD = correlationDimension(RR_resamp,tau,dim,'NumPoints',Np);
% 
% end
% % =======
function [FD,SE,LE,CD]=nonlin_measures(RR)
% Input:    RR      RR interval time series
% Output:   FD      Fractal Dimension using boxcounting method
%           SE      Sample Entropy
%           LE      Largest Lyapunov Exponent
%           CD      Correlation Dimension
% 
fs = 2;
time = cumsum(RR/1000); % Time in seconds
time_new = 0:1/fs:time(end)-time(1);  
RR_resamp = spline(time-time(1),RR,time_new); 
% *************************************************************************
%% Fractal Dimension
FD = boxcount([time_new',RR_resamp'],7,0);

% *************************************************************************
%% Sample Entropy
dim = 2;  % Embedded dimension
r  = 0.2*std(RR); % Tolerance (typically 0.2 * std)
SE = SampEn(dim,r,RR);

% *************************************************************************
%% Lyapunov Exponent
LE = LyapunovExponent(time_new',RR_resamp');
if isempty(LE)
    LE = Inf;
end

% *************************************************************************
%% Correlation Dimension
%-- The most accurate 
% 
% dim = 8;    % Embedding dimension
% tau = 1;    % Time delay
% [logCr,logr]=gencorint(RR_resamp,dim,tau);
% %Derive Correlation Dimension (m=8) from the outputs given above
% p  = polyfit(logr,logCr);
% CD = p(2);


%%-- The intermediate solution

% dim = 8;    % Embedding dimension
% tau = 1;    % Time delay
% 
% X            = embed(RR_resamp,1,8);
% 
% emax         = 0;
% emin         = 2;
% 
% [C,e]        = correlint(X,emin,emax);
% %Derive Correlation Dimension (m=8) from the outputs given above
% p  = polyfit(log(e((1:15))),log(C(1:15)),1);
% CD = p(1);

%%--The fastes approach (only with >=Matlab2018a)
MinR  = 10e-4;
MaxR  = 100;
tau   = 1;
dim   = 4;
Np    = 30;
%CD = correlationDimension(RR,tau,dim,'MinRadius',MinR,'MaxRadius',MaxR,'NumPoints',Np);
CD = correlationDimension(RR_resamp,tau,dim,'NumPoints',Np);

end

