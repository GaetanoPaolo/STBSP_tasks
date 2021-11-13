function [ output ] = applyMultiChannelFilter( data, filter )
%APPLYMULTICHANNELFILTER Calculate multi-channel FIR filter output on given data.
%
% inputs:
%   data : multi-channel data (numberSamples, numberChannels)
%   filter : multi-channel FIR filter (numberTaps, numberChannels)
%
% output:
%   output : filter output
%

% extract the temporal window length from the give matrix filter
% coefficients
L = size(filter, 1);
% initialize the filter output
output = zeros(size(data, 1), 1);

% calculate output
for idx=L:length(output)
    
    % TODO: Calculate the filter output(idx). At time idx consider only idx
    % and its past samples (i.e., we implement a causal filter).
    cur_sec = data(idx-L+1:idx,:);
    %exp_filt = repmat(filter,1,size(data,2));
    exp_filt = stacked2mat(filter,size(data,2));
    output(idx) = sum(sum(cur_sec.*exp_filt,1),2);
end

end

