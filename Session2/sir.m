function [sir,P,D] = sir(A,Aest)
%SIR Signal-to-interference ratio.
%   [sir,P,D] = sir(A,Aest) computes a permutation matrix P and a scaling
%   matrix D such that Aest*P*D is optimally permuted and scaled to
%   resemble A. The SIR is then defined as
%
%      20*log10(norm(diag(F))/norm(F-diag(diag(F)),'fro')),
%
%   where F = A\(Aest*P*D).

% Compute the permutation matrix.
C = abs(Aest\A);
P = zeros(size(A,2));
for r = 1:size(A,2)
    [Cr,i] = max(C);
    [~,j] = max(Cr);
    P(i(j),j) = 1;
    C(i(j),:) = 0;
    C(:,j) = 0;
end

% Compute the scaling matrix.
D = diag(conj(dot(A,Aest*P)./dot(Aest*P,Aest*P)));

% Compute the SIR.
F = A\(Aest*P*D);
sir = 20*log10(norm(diag(F),'fro')/norm(F-diag(diag(F)),'fro'));
