%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This File will call on the nessesary functions to calculate one of the
% parameters.
% Parameter Calculated in this file: The Maximal Lyapunov Exponent
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ParamResult = LyapunovExponent(time_resampled,signal_resampled)

%% Calculating Asked Parameter

global Lyapunov_Estimate Faling

Drozzle=struct('data',signal_resampled,'time',time_resampled);
maximal_lyap_exp(Drozzle)
while (Faling==1)
    %disp('Lyapunov Failed: Trying again')
    maximal_lyap_exp(Drozzle)
end

ParamResult = Lyapunov_Estimate;
%disp('Calculated: The Maximal Lyapunov Exponent')


