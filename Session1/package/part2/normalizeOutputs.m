function [normSNR, normSPIR] = normalizeOutputs(SNROut, SPIROut, outLabels, L)
%NORMALIZEOUTPUTS Normalize mean maximum label output response.

% normalize SNR
local_peaks = zeros(length(outLabels),1);
for idx=1:length(outLabels)
    [start, stop] = spike2window(outLabels(idx), L);
    local_peaks(idx) = max(SNROut(start:stop));
end

divSNR = mean(local_peaks);
normSNR = SNROut / divSNR;

% normalize SPIR
local_peaks = zeros(length(outLabels),1);
for idx=1:length(outLabels)
    [start, stop] = spike2window(outLabels(idx), L);
    local_peaks(idx) = max(SPIROut(start:stop));
end

divSPIR = mean(local_peaks);
normSPIR = SPIROut / divSPIR;

end

