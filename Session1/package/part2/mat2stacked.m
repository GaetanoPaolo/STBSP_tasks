function [ vec ] = mat2stacked( mat )
%MAT2STACKED Convert given matrix to stacked vector.
%
% input:
%   mat : data slice to be stacked (L, numberChannels)
%
% output:
%   vec : stacked data vector (L*numberChannels,1)
%

vec = reshape(mat',[],1);

end

