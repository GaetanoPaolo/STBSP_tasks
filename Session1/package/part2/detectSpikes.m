function [ spikes ] = detectSpikes( data, scaling, L )
%DETECTSPIKES detect spikes on every channel using the scaled standard
% deviation as a threshold (for spike detection scaling is often negative)

% calculated spike detection threshold for every channel separately
thresholds = std(data) * scaling;

% detect spikes
if scaling < 0
    spikes = bsxfun(@lt, data, thresholds); 
else
    spikes = bsxfun(@ge, data, thresholds);
end

% collapse all channels
spikes = sum(spikes, 2);

if L>0
    spikes = conv(spikes, ones(L,1), 'same');
end

% return discrete times at which a spike is detected
spikes = find(spikes);

end

