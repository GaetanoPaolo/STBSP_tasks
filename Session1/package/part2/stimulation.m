load('artifactData.mat')
[chann,samp] = size(data);

%% Plotting
figure; hold on; 
x= 1:100;
plotted_data = data(1,x);
plot(x,plotted_data)

cur_events =  find((x(1) <=events) & (events<= x(end)));
cur_labels = find((x(1) <=labels) & (labels<= x(end)));
amp = zeros(1,size(cur_events,2));
cur_events_idx = events(cur_events);
cur_labels_idx = labels(cur_labels);
plot(cur_events_idx,cur_events_idx - x(1),'*g')
plot(cur_labels_idx,plotted_data(cur_labels_idx-x(1)),'*r')
title('Stimulation artifact recodring')
xlabel('Timesamples')
ylabel('Amplitude')

%% Computing LS filter solution
cur_chan = 1;
chan = adjacent_channels{cur_chan};
L = 9;
M = events(1)+L-1:events(2);
X = double.empty();
for t = M
    adj_data = double.empty(0,0);
    for i = chan
        if i ~= cur_chan
            adj_data = cat(2,adj_data,data(i,t-L+1:t));
        end
    end
    X = cat(1,X,adj_data);
end

