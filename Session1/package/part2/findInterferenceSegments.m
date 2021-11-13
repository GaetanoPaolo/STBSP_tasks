function [ intSegments ] = findInterferenceSegments( data, maxSNRFilter, outLabels, L )
%FINDINTERFERENCESEGMENTS Find interference segments.

% apply the maxSNRFilter to the data
maxSNROut = applyMultiChannelFilter(data, maxSNRFilter);
maxSNROut = maxSNROut.^2;

% determine target safe zone
[low, high] = calcTargetSafeZone( maxSNROut, outLabels, L );

% determine noise floor
noise_floor = median(maxSNROut);

% interference threshold
beta = 0.5;
intThresh = (1-beta)*noise_floor + beta*low;

% apply threshold
detections = maxSNROut > intThresh;
cuttedDetections = cutMask(detections, 0); % don't extend detections here

intSegments = [];
% enforce safe zone
for idx=1:length(cuttedDetections)
    peak = max(maxSNROut(cuttedDetections{idx}));
    if peak < low | peak > high
        intSegments = [intSegments; cuttedDetections{idx}];
    end
end

end

