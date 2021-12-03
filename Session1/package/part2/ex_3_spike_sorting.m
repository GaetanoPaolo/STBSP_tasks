%% INITIALIZE

% IMPORTANT: DO NOT REMOVE OR MODIFY ANY OF THE GIVEN CODE, UNLESS
% EXPLICITLY SPECIFIED

close all;

% load the training data
load('trainingData.mat');

% data related parameters
fs = 25000; % sampling frequency
spike_window = 25; % samples spike window
nbChannels = size(trainingData,2);
%% CALCULATE TEMPLATE

% calculate template
template = calcTemplate(trainingData, trainingLabels, spike_window);
% vectorize template for use in filter design
vecTemplate = mat2stacked(template);

% TODO: Visualize the calculated template using plotMultiChannel
% visualize template
plotMultiChannel(template,1)
%% Template as a filter
% TODO: complete applyMultiChannelFilter function
%  make sure to transform the filter coefficients back to a matrix
%  using stacked2mat.
templateFilter = template;
templateFilterOut = applyMultiChannelFilter(trainingData, templateFilter);

% calculate output power
templateFilterOut = templateFilterOut.^2;
%% CHOOSE F1-OPTIMAL THRESHOLD FOR template filter
% shift labels to match output
outLabels = trainingLabels + floor(spike_window/2);

% try different thresholds on the filter output
outStd = std(templateFilterOut);
C = 5;
max_perf = 0;
SNR_senss = [];
SNR_precs = []
SNR_thrs = [];
while 1
    % threshold segments
    thr = C*outStd;
    detections = templateFilterOut > thr;
    cuttedDetections = cutMask(detections, spike_window);
    
    % output training segments
    labels = zeros(size(detections));
    labels(outLabels) = 1;
    cuttedLabels = cutMask(labels, spike_window);
    
    if length(cuttedDetections) == 0
        break;
    end
    
    % validate the detections
    [sens, prec] = validateDetections(cuttedDetections, cuttedLabels);
    
    SNR_thrs = [SNR_thrs; thr];
    SNR_senss = [SNR_senss; sens];
    SNR_precs = [SNR_precs; prec];

    C = C + 1;
end
%% PLOT P-R CURVE FOR template filter AND CHOOSE A THRESHOLD
[~,pos] = max(SNR_precs);
max_threshold = SNR_thrs(pos);
% precision it the only non monotonic variable => defines optimal choice

% TODO: plot a P-R curve using SNR_senss and SNR_precs
figure('Name','P-R plot')
plot(SNR_senss(1:end-53),SNR_precs(1:end-53))
xlabel('Recall/Sensitivity')
ylabel('Precision')

figure('Name','PR-Treshold plot')
hold on
plot(SNR_thrs(1:end-53),SNR_senss(1:end-53))
plot(SNR_thrs(1:end-53),SNR_precs(1:end-53))
plot(SNR_thrs(pos),SNR_precs(pos),"*r")
hold off
legend('recall','precision')

<<<<<<< HEAD

% TODO: based on the plotted P-R curve choose a threshold
% max_threshold =  % <your value here>;

F1 = 2*(SNR_senss.*SNR_precs)./(SNR_senss+SNR_precs);
%[~,pos] = max(SNR_precs);
[~,pos] = max(F1);
max_threshold = SNR_thrs(pos);
disp('Template filter treshold')
disp(max_threshold)
% precision it the only non monotonic variable => defines optimal choice
=======
>>>>>>> cdbeb39157056988a1056ead011ea27b6c0510fe
%% VALIDATE template filter ON TESTING DATA

% load the testing data
load('testingData.mat');

% calculate filter output
testingtemplateFilterOut = applyMultiChannelFilter(testingData, templateFilter);
testingtemplateFilterOut = testingtemplateFilterOut.^2;

% shift label to match output delay
testingOutLabels = testingLabels + floor(spike_window/2);

% threshold segments
detections = testingtemplateFilterOut > max_threshold;
cuttedDetections = cutMask(detections, spike_window);

% output testing segments
labels = zeros(size(detections));
labels(testingOutLabels) = 1;
cuttedLabels = cutMask(labels, spike_window);

% validate the detections
[sens_templateFilter, prec_templateFilter] = validateDetections(cuttedDetections, cuttedLabels);
fprintf('template-filter: for your threshold: recall: %.3f, precision: %.3f\n\n', sens_templateFilter, prec_templateFilter);

% visualize Matched filter output power
figure; hold on;
plot(testingtemplateFilterOut, 'DisplayName', 'Matched filter');
plot(testingOutLabels, testingtemplateFilterOut(testingOutLabels), 'g*', 'DisplayName', 'Testing labels');
title('Template filter output on testing data')
xlabel('Discrete time [samples]')
ylabel('Output power [arb. unit]')
legend('show')

% Slightly better performance on testing data, especially for the recall.
% Bad performance because already bad on training set
%% DESIGN Matched-filter

% find noise segments
noiseSegments = findNoiseSegments(trainingData, spike_window);

% calculate noise covariance matrix

% TODO: Write a function which computes the noise covariance matrix using only the
% data in noise segments.

tempNoiseCovariance =  lagged_n_cov(noiseSegments,trainingData);% Let the estimated noise covariance be this variable.
disp(tempNoiseCovariance)
% regularize the noise covariance matrix
noiseCov = regularizeCov(tempNoiseCovariance,1);

% TODO: calculate the Matched filter filter using noiseCov and the vectorized
% template, make sure to transform the filter coefficients back to a matrix
% Store the matched filter in maxSNR
maxSNR = transpose(noiseCov\template');


% TODO: complete applyMultiChannelFilter function
maxSNROut = applyMultiChannelFilter(trainingData, maxSNR);

% calculate output power
maxSNROut = maxSNROut.^2;

%% CHOOSE F1-OPTIMAL THRESHOLD FOR Matched filter

% shift labels to match output
outLabels = trainingLabels + floor(spike_window/2);

% try different thresholds on the filter output
outStd = std(maxSNROut);
C = 1;
max_perf = 0;
SNR_senss = [];
SNR_precs = [];
SNR_thrs = [];
while 1
    % threshold segments
    thr = C*outStd;
    detections = maxSNROut > thr;
    cuttedDetections = cutMask(detections, spike_window);
    
    % output training segments
    labels = zeros(size(detections));
    labels(outLabels) = 1;
    cuttedLabels = cutMask(labels, spike_window);
    
    if length(cuttedDetections) == 0
        break;
    end
    
    % validate the detections
    [sens, prec] = validateDetections(cuttedDetections, cuttedLabels);
    
    SNR_thrs = [SNR_thrs; thr];
    SNR_senss = [SNR_senss; sens];
    SNR_precs = [SNR_precs; prec];

    C = C + 1;
end

%% PLOT P-R CURVE FOR Matched filter AND CHOOSE A THRESHOLD

[~,pos] = max(SNR_precs);
max_threshold = SNR_thrs(pos);
% TODO: plot a P-R curve using SNR_senss and SNR_precs

figure('Name','P-R plot matched filter')
plot(SNR_senss(1:end-53),SNR_precs(1:end-53))
xlabel('Recall/Sensitivity')
ylabel('Precision')

figure('Name','PR-Treshold plot matched filter')
hold on
plot(SNR_thrs(1:end-53),SNR_senss(1:end-53))
plot(SNR_thrs(1:end-53),SNR_precs(1:end-53))
plot(SNR_thrs(pos),SNR_precs(pos),'*r')
hold off
legend('recall','precision')

<<<<<<< HEAD
% TODO: based on the plotted P-R curve choose a threshold
=======
>>>>>>> cdbeb39157056988a1056ead011ea27b6c0510fe


F1 = 2*(SNR_senss.*SNR_precs)./(SNR_senss+SNR_precs);
%[~,pos] = max(SNR_precs);
[~,pos] = max(F1);
max_threshold = SNR_thrs(pos);
disp('Matched filter treshold')
disp(max_threshold)
%% VALIDATE Matched filter ON TESTING DATA

% load the testing data
load('testingData.mat');

% calculate filter output
testingMaxSNROut = applyMultiChannelFilter(testingData, maxSNR);
testingMaxSNROut = testingMaxSNROut.^2;

% shift label to match output delay
testingOutLabels = testingLabels + floor(spike_window/2);

% threshold segments
detections = testingMaxSNROut > max_threshold;
cuttedDetections = cutMask(detections, spike_window);

% output testing segments
labels = zeros(size(detections));
labels(testingOutLabels) = 1;
cuttedLabels = cutMask(labels, spike_window);

% validate the detections
[sens_SNR, prec_SNR] = validateDetections(cuttedDetections, cuttedLabels);
fprintf('matched-filter: for your threshold: recall: %.3f, precision: %.3f\n\n', sens_SNR, prec_SNR);

% visualize Matched filter output power
figure; hold on;
plot(testingMaxSNROut, 'DisplayName', 'Matched filter');
plot(testingOutLabels, testingMaxSNROut(testingOutLabels), 'g*', 'DisplayName', 'Testing labels');
title('Matched filter output on testing data')
xlabel('Discrete time [samples]')
ylabel('Output power [arb. unit]')
legend('show')

%% DESIGN MAX-SPIR FILTER

% find interference segments
intSegments = findInterferenceSegments(trainingData, maxSNR, outLabels, spike_window);

% visualize interference segments
figure; hold on;
plot(maxSNROut, 'DisplayName', 'Matched filter');
plot(intSegments, maxSNROut(intSegments), 'r*', 'DisplayName', 'Detected interference segments');
plot(outLabels, maxSNROut(outLabels), 'g*', 'DisplayName', 'Training labels');
title('Matched filter output on training data')
xlabel('Discrete time [samples]')
ylabel('Output power [arb. unit]')
legend('show')

% calculate interference covariance matrix and store it in tempIntCov
% TODO: Re-use the function used to calculate noise covariance here.
tempIntCov = lagged_n_cov(intSegments,trainingData);

% regularize the interference covariance matrix
intCov = regularizeCov(tempIntCov,0.01); 

% TODO: calculate the max-SPIR filter using intCov and the vectorized
% template, make sure to transform the filter coefficients back to a matrix
% using stacked2mat.

maxSPIR = transpose(intCov\template');

% calculate filter output
maxSPIROut = applyMultiChannelFilter(trainingData, maxSPIR);
maxSPIROut = maxSPIROut.^2;

%% CHOOSE F1-OPTIMAL THRESHOLD FOR MAX-SPIR

% try different thresholds on the filter output
outStd = std(maxSPIROut);
C = 10;
max_perf = 0;
SPIR_senss = [];
SPIR_precs = [];
SPIR_thrs = [];
while 1
    % threshold segments
    thr = C*outStd;
    detections = maxSPIROut > thr;
    cuttedDetections = cutMask(detections, spike_window);
    
    % output training segments
    labels = zeros(size(detections));
    labels(outLabels) = 1;
    cuttedLabels = cutMask(labels, spike_window);
    
    if length(cuttedDetections) == 0
        break;
    end
    
    % validate the detections
    [sens, prec] = validateDetections(cuttedDetections, cuttedLabels);
    
    SPIR_thrs = [SPIR_thrs; thr];
    SPIR_senss = [SPIR_senss; sens];
    SPIR_precs = [SPIR_precs; prec];

    C = C + 1;
end

%% PLOT P-R CURVE FOR MAX-SPIR AND CHOOSE A THRESHOLD

% TODO: based on the plotted P-R curve choose a threshold
F1 = 2*(SPIR_senss.*SPIR_precs)./(SPIR_senss+SPIR_precs);
[~,pos] = max(F1);
max_threshold_SPIR = SPIR_thrs(pos);

% TODO: plot a P-R curve using SPIR_senss and SPIR_precs
figure('Name','P-R plot max SPIR filter')
<<<<<<< HEAD
hold on
plot(SNR_senss,SNR_precs)
plot(SPIR_senss,SPIR_precs)
plot(0.0305,0.0108,'*r')
hold off
=======
plot(SPIR_senss(1:end-39),SPIR_precs(1:end-39))
>>>>>>> cdbeb39157056988a1056ead011ea27b6c0510fe
xlabel('Recall/Sensitivity')
ylabel('Precision')
legend('Matched filter','max-SPIR filter','chosen treshold')
title('PR curve for both matched and max-SPIR filters')

figure('Name','PR-Treshold plot max SPIR filter')
hold on
plot(SPIR_thrs(1:end-39),SPIR_senss(1:end-39))
plot(SPIR_thrs(1:end-39),SPIR_precs(1:end-39))
plot(SPIR_thrs(pos),SPIR_precs(pos),'*r')
hold off
legend('recall','precision')

<<<<<<< HEAD
% TODO: based on the plotted P-R curve choose a threshold
F1 = 2*(SPIR_senss.*SPIR_precs)./(SPIR_senss+SPIR_precs);
[~,pos] = max(F1);
max_threshold_SPIR = SPIR_thrs(pos);
disp('SPIR teshold')
disp(max_threshold_SPIR)
=======
>>>>>>> cdbeb39157056988a1056ead011ea27b6c0510fe
%% VALIDATE MAX-SPIR FILTER ON TESTING DATA

testingMaxSPIROut = applyMultiChannelFilter(testingData, maxSPIR);
testingMaxSPIROut = testingMaxSPIROut.^2;

testingOutLabels = testingLabels + floor(spike_window/2);

detections = testingMaxSPIROut > max_threshold_SPIR;
cuttedDetections = cutMask(detections, spike_window);

labels = zeros(size(detections));
labels(testingOutLabels) = 1;
cuttedLabels = cutMask(labels, spike_window);

% validate the detections
[sens_SPIR, prec_SPIR] = validateDetections(cuttedDetections, cuttedLabels);
fprintf('max-SPIR: for the maximum F1-score threshold: recall: %.3f, precision: %.3f\n', sens_SPIR, prec_SPIR);

%% COMPARE BOTH FILTER OUTPUTS FROM TESTING DATA

% normalize filter outputs for plotting purposes
[normSNR, normSPIR] = normalizeOutputs(testingMaxSNROut, testingMaxSPIROut, testingOutLabels, spike_window);

% plot normalized filter outputs on testing data
[~,len] = size(testingOutLabels);
labels = zeros(1,len);
figure; hold on;
plot(normSNR);
plot(normSPIR);
plot(testingOutLabels, labels, 'g*');
title('Filter outputs on testing data')
xlabel('Discrete time [samples]');
ylabel('Output power [arb. unit]')
legend('normalized Matched filter','normalized max-SPIR', 'Testing labels');
% The matched filter often undershoots labeled testing points while the
% SPIR often reaches them => due to the specific modelling of the peak
% interferers in the cost function for SPIR, while in the matched filter
% the general noise covariance is modelled =>  max SNR => lowers noise
% level, but pikes not specifically taken into accoun.

%Matched filter reacts much more on interference peaks (outputs much
%higher values) than SPIR => behaves worse for interference peaks

% Conclusion: max SPIR better for spike sorting <=> contradiction with the
% precision values!!! => Check again