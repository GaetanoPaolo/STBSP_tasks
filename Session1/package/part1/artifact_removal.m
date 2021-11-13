%% Visualizing dataset
load('eegdata_artifacts.mat')
eegplot_simple(eegdata,fs)
%% Locating artifacts
disp(channelnames);
%muscle artifacts between 2 and 16 and between 33 and 53
%eye blink artifacts between 1 and 7 and between 33 and 40
% channels 1 to 7 and 33 to 40= frontal areas of the skull: close to the eyes
%channels 2 to 16 and 33 to 53 = mid areas of the skull: mouth and jaw
%muscles
%% Computing CCA
eegdata_delayed = eegdata(:,2:end);
eegdata_trunc = eegdata(:,1:end-1);
%[A,B,r,U,V] = canoncorr(eegdata_trunc,eegdata_delayed);
[y,w,r] = ccaqr(eegdata,1);
w_trans = w';
[row,col] = size(w_trans);
w_inv = inv(w_trans);
eeg_rec = w_inv(:,1:end-37)*y(1:end-37,:);
%Comparing original eeg with muscle artifact removal
figure("Name","Original")
eegplot_simple(eegdata,fs)
figure("Name","Mod")
eegplot_simple(eeg_rec,fs);

% to remove eye blink artifacts: try removing higher CCA components that
% contain the higher eye blink artifact correlations

%% MWF eyeblink mask gen
%mask = mwf_getmask(eegdata, fs) ;
load('mask.mat')
%% MWF process
p               = mwf_params(...
                'rank', 'poseig', ...
                'delay', 0);
[n, d, W, SER, ARR] = mwf_process(eegdata, mask,p);


figure("Name","Mixed Plot delay 0")
hold on
plot(1:30*fs, eegdata(1,1:30*fs))
plot(1:30*fs, n(1,1:30*fs))
plot(1:30*fs, d(1,1:30*fs))
hold off
legend("raw","MWF","est artifacts")
title(strcat("ARR: ",num2str(ARR),"SER: ",num2str(SER)))
%save('mask.mat','mask')
%% 1.3.1.3-4
% The delay is automatically set to 0 in the mwf_process function, so L =
% 1. A single tap filter is automatically only spatial. Increasing the
% delay param makes the filter spatio temporal.
p               = mwf_params(...
                'rank', 'poseig', ...
                'delay', 3);
[n_d, d_d, W, SER_d, ARR_d] = mwf_process(eegdata, mask,p);
figure("Name","Mixed Plot delay 3")
hold on
plot(1:30*fs, eegdata(1,1:30*fs))
plot(1:30*fs, n_d(1,1:30*fs))
plot(1:30*fs, d_d(1,1:30*fs))
hold off
legend("raw","MWF","est_artifacts")
title(strcat("ARR: ",num2str(ARR_d)," SER: ",num2str(SER_d)))
% The ARR for delay 3 increases by 3 => slightly better artifact
% supression,but at the cost of a huge SER decrease => large distortion on
% the produced EEG signal (dirty)
%% 1.3.1.5
%Check the eigenvalues in the Lambda variable in mwf_compute and retain te
%values that are large enough (compared to the first) => not smalle than
%0.1*largest eig
p               = mwf_params(...
                'rank', 'first', ...
                'rankopt',4, ...
                'delay', 0);
[n_d, d_d, W, SER_d, ARR_d] = mwf_process(eegdata, mask,p);
figure("Name","Mixed Plot delay 3")
hold on
plot(1:30*fs, eegdata(1,1:30*fs))
plot(1:30*fs, n_d(1,1:30*fs))
plot(1:30*fs, d_d(1,1:30*fs))
hold off
legend("raw","MWF","est_artifacts")
title(strcat("ARR: ",num2str(ARR_d)," SER: ",num2str(SER_d)))

%for eigenvalues with a magnitude above 0.1*margest eigenvalue kept (=4 in
%total), the ARR decreases (worse artifact supression), but SER increases
%(less artifacts introduced by filter itself) => optimize trade off/find
%sweetspot

%% 1.3.1.6
%muscle_mask = mwf_getmask(eegdata, fs) ;
load('muscle_mask.mat')
%save('muscle_mask.mat','muscle_mask')
p               = mwf_params(...
                'rank', 'poseig', ...
                'delay', 5);
[n_d, d_d, W, SER_d, ARR_d] = mwf_process(eegdata, muscle_mask,p);
figure("Name","Mixed Plot delay 3")
hold on
plot(80*fs:119*fs, eegdata(43,80*fs:119*fs))
plot(80*fs:119*fs, n_d(43,80*fs:119*fs))
plot(80*fs:119*fs, d_d(43,80*fs:119*fs))
hold off
legend("raw","MWF","est_artifacts")
title(strcat("ARR: ",num2str(ARR_d)," SER: ",num2str(SER_d)))
disp('SER MWF')
disp(SER_d)
disp('ARR MWF')
disp(ARR_d)
% A very good performance is achived in this case and increasin with delay(both SER
% and ARR) => explanation? advantage of taking many samples in the
% filtering compared to eyeblink artifacts?

%% 1.3.1.7
%SER_CCA = 10*log10(mean(eeg(1,64*fs:67*fs))/mean(d_d(1,64*fs:67*fs)));
d_CCA = eegdata(:,1:end-1) - eeg_rec;
[SER_CCA, ARR_CCA] = mwf_performance(eegdata, d_CCA, muscle_mask);
disp('SER CCA')
disp(SER_CCA)
disp('ARR CCA')
disp(ARR_CCA)
% MWF better SER when removing many CCA (> 60)sources because the estimation of the autocorrelation for
% the artifacts is better due to the masking technique, while in CCA the
% sources with lowest autocorrelation are simply left out => more (desired)
% clean EEG is removed. But the ARR is way better in MWF due to the blind
% nature in which the sources are removed. The assumption of the artifacts
% having no correlation does not always hold. 

%When removing few sources in CCA (37), the SER is better at CCA compared
%to MWF due to the large amount of desired signal that is kept. As a
%consequence, the ARR of the CCA decreases as some of the more correlated
%parts of the artifeacts are ignored in the implicit estimation.

%% 1.3.1.8
%blink_tot_mask = mwf_getmask(eegdata, fs) ;
%save('blink_tot_mask.mat','blink_tot_mask')
load('blink_tot_mask.mat')
tot_mask = blink_tot_mask + muscle_mask;
while sum(ismember(2,tot_mask)) > 0
    [~,Loc] = ismember(2,tot_mask);
    tot_mask(Loc) = tot_mask(Loc) -1;
end
p               = mwf_params(...
                'rank', 'poseig', ...
                'delay', 0);
[n_d, d_d, W, SER_d, ARR_d] = mwf_process(eegdata, tot_mask,p);
[row,col] = size(eegdata);

figure("Name","Tot mask plot")
hold on
plot(1:col, eegdata(1,:))
plot(1:col, n_d(1,:))
plot(1:col, d_d(1,:))
hold off
legend("raw","MWF","est_artifacts")
title(strcat("ARR: ",num2str(ARR_d)," SER: ",num2str(SER_d)))
 
figure("Name","EEG plot totmask")
eegplot_simple(d_d,fs)

% Muscle artifacts less removed due to their lower autocorrelations => less
% present in the estimated covariance matrix

