function scales = make_scales(beginFreq,eindFreq)
% this function computes the corresponding scales from given starting and
% ending frequency for the biorthogonal wavelet  (bior1.3) with a
% homogeneous sampling

waveletName = 'bior1.3';
fs = 250;
% beginFreq = 1;
% eindFreq = 30;
freqRes = 1;

centerFreq = centfrq(waveletName);

counter=1;
for i=beginFreq:freqRes:eindFreq
    scales(counter) = (centerFreq*fs)/(i);
    counter=counter+1;
end
