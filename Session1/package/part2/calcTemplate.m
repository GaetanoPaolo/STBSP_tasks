function [ template ] = calcTemplate( data, labels, L )
%CALCTEMPLATE Calculate the template given data, labels and window
% length L.

% get dimension
nbChannels = size(data, 2);
nbLabels = length(labels);

% initialise template tensor
templateTensor = zeros(L, nbChannels, nbLabels);

% loop over all labels
for idx=1:nbLabels
    [start, stop] = spike2window(labels(idx), L);
    templateTensor(:,:,idx) = data(start:stop,:);
end

% calculate median over the third dimension to obtain the template
template = median(templateTensor, 3);

end

