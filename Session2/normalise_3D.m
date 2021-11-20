function [data_3D,m,s] = normalise_3D(data_all,startp,eind,scales)
%function [data_3D,m,s] = normalise_3D(data_all,startp,eind,scales)
%this function preprocesses your EEG data (from startp in seconds until eind in seconds) by subtracting the mean, and
%dividing each channel by its standard deviation.  Afterwards the 2D
%EEGdata is wavelet-transformed to obtain a 3D tensor

if nargin <3
    scales=5:70;
end

point=startp*250+1;
endpoint=eind*250;
data=data_all(:,point:endpoint);

m=mean(data,2);
data=data-m(:,ones(1,size(data,2)));
s=std(data,[],2);
data=data./s(:,ones(1,size(data,2)));

data_3D=multiwavelet(data,scales);
