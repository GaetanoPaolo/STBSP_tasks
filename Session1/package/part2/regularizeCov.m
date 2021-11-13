function [ output_cov ] = regularizeCov( input_cov, correction )
%REGULARIZECOV Regularize covariance matrix.

S = svd(input_cov);
idxs = 1:length(S);

S_norm = S / max(S) * max(idxs);
zipped = [S_norm, idxs'];

maxs = max(zipped, [], 2);
[~,minmax_idx] = min(maxs);

output_cov = input_cov + correction*S(minmax_idx)*eye(size(input_cov));

end

