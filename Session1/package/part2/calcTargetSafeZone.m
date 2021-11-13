function [ low, high ] = calcTargetSafeZone( outPower, outLabels, L )
%CALCTARGETSAFEZONE Calculate the target safe zone

% find local maxima
local_peaks = zeros(length(outLabels),1);
for idx=1:length(outLabels)
    [start, stop] = spike2window(outLabels(idx), L);
    local_peaks(idx) = max(outPower(start:stop));
end

% use lower and upper percentile for robustness
low = prctile(local_peaks, 5);
high = prctile(local_peaks, 95);

% hardcoded alpha here
alpha = 0.05;

% expand again using a fixed margin
low = low * (1-alpha);
high = high * (1+alpha);

end

