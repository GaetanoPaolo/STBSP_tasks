function [ noiseSegments ] = findNoiseSegments( data, L )
%findNoiseSegments Find noise segments given the data and a template window
% length.

%  detect spikes in the given data
spikes = detectSpikes(data, -3, L);

noiseSegments = zeros(size(data,1),1);
% a noise segment is a time point where no spike is detected within its
% L-window
for idx=L:length(noiseSegments)
    window = (idx-L+1):idx;

    % if the intersection spikes and window is empty we
    % have a valid noise segment (making use of internal matlab helper)
    if ~any(ismembc(window, spikes))
        noiseSegments(idx) = 1;
    end
end

noiseSegments = find(noiseSegments);

end

