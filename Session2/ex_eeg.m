% Required software for this exercise:
% - EEGLAB: http://sccn.ucsd.edu/eeglab/downloadtoolbox.html
% - Wavelet Toolbox

% Load and inspect EEG measurements.
load demosignal3_963
%eegplot()

% Epileptic activity occurs around 52s.
% Normalise the measurements and wavelet transform them to a tensor.
[data_3D,m,s] = normalise_3D(demosignal3_963,51,53,make_scales(2,25));

% Decompose the tensor in two rank one terms.
R = 2;
U = cpd(data_3D,R);
A = U{1}; B = U{2}; C = U{3};

% Look at the error of the fit in function of the number of rank one terms.
% This can be done by manually testing each R.

% Topoplots.
result = transform_back(A,s);

% Frequency signatures.
figure;
plot(B);
title('frequency signatures');

% Temporal signatures.
figure;
plot(C);
title('temporal signatures');
