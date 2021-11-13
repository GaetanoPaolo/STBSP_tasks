function [ mat ] = stacked2mat( vec, nbChannels )
%STACKED2MAT Convert stacked vector to matrix.
%
% input:
%   vec : stacked data vector (L*nbChannels,1)
%   nbChannels: number of channels for the output matrix
%
% output:
%   mat : data slice to be stacked (L, nbChannels)
%

mat = reshape(vec, nbChannels, []);
mat = mat';

end

