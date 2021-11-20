function [transformed_data] = multiwavelet(data,scales);
%function [transformed_data] = multiwavelet(data,scales);
%EEGsignal to waveletdecomposition on all channels
% uses a biorthogonal wavelet 1.3
% other possibilities: bior1.5, cmor2-1, ...bior1.3,mexh

if nargin <2
    scales=5:70;
end

for k=1:size(data,1)
  transformed_data(k,:,:)=cwt(data(k,:),scales,'bior1.3');
end
