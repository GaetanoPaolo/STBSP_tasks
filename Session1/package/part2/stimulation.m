load('artifactData.mat')
[chann,samp] = size(data);

%% Plotting
figure; hold on; 
x=108800:109400;
cur_events =  find((x(1) <=events) & (events<= x(end)));
cur_labels = find((x(1) <=labels) & (labels<= x(end)));
amp_events = zeros(1,size(cur_events,2));
amp_labels = zeros(1,size(cur_labels,2));
cur_events_idx = events(cur_events);
cur_labels_idx = labels(cur_labels);

plot(x,data(14,x))
plot(x,data(4,x))
plot(cur_events_idx,amp_events,'*g')
plot(cur_labels_idx,amp_labels,'*r')
hold off
title('Stimulation artifact recordings superimposed')
xlabel('Timesamples')
ylabel('Amplitude')
legend('chan14','chan4','events','labels')
%% Defining filter calculation parameters
all_chans = 1:32;
L = 9;
jump = 29;
filt_out = zeros(size(data,1),size(data,2));
for cur_chan = all_chans
    disp(cur_chan)
    adj_chan = adjacent_channels{cur_chan};
    used_chan = double.empty();
    for i= all_chans
        if sum(ismember(adj_chan,i)) == 0
            used_chan = cat(2,used_chan,i);
        end
    end
    % Calculating different filter taps timesamples matrix
    X = double.empty();
    for k = 1:jump:length(events)
        M_cur = events(k):events(k+1);
        for t = M_cur
        adj_data = double.empty(0,0);
            for i = used_chan
                if t < L
                    obs_int = cat(2,zeros(1,L-t),data(i,1:t));
                else
                    obs_int = data(i,t-L+1:t);
                end
                adj_data = cat(2,adj_data,obs_int);
            end
        X = cat(1,X,adj_data);
        end
    end
    % saving X to mat file
    %save('X.mat','X')
    % creating observed channel time vector with artifacts
    %load('X.mat')
    x_art = double.empty();
    for k = 1:jump:length(events)
        M_cur = events(k):events(k+1);
        adj_data = data(cur_chan,M_cur)';
        x_art = cat(1,x_art,adj_data);
    end
    % estimating Linear MMSE filter
    w_est = X\x_art;
    % estimating artifacts
    cur_y = data(cur_chan,:);
    for k = 1:2:length(events)
        time_interval = events(k):events(k+1);
        event_res = zeros(1,size(time_interval,2));
        for t = time_interval
            adj_data = double.empty(0,0);
            for i = used_chan
                if t < L
                    obs_int = cat(2,zeros(1,L-t),data(i,1:t));
                else
                    obs_int = data(i,t-L+1:t);
                end
                adj_data = cat(2,adj_data,obs_int);
            end
            event_res(t-events(k)+1) = dot(w_est',adj_data');
        end
        cur_y(time_interval) = cur_y(time_interval) - event_res;
    end
    cur_art = data(cur_chan,:) - cur_y;
    filt_out(cur_chan,:) = cur_y;
end
%% saving filtered channels
%save('filtered_channels.mat','filt_out')
load('filtered_channels.mat')
%% Plotting artifacts and filtered data

t = 108800:109400;
all_chans = 1:32;
figure
hold on
for cur_chan = all_chans
    plot(t, filt_out(cur_chan,t)+(32-cur_chan)*2500)
end
hold off
legend('chan1','chan2','chan3','chan4','chan4','chan5','chan6','chan7',...
    'chan8','chan9','chan10','chan11','chan12','chan13','chan14','chan15',...
    'chan16','chan17','chan18','chan19','chan20','chan21','chan22','chan23'...
    ,'chan24','chan25','chan26','chan27','chan28','chan29','chan30','chan31','chan32');
title('Filtered recordings for all channels in sample range: 108800:109400')
ylabel('Amplitude')
xlabel('Timesamples')
%% Extra plots
t = 108800:109400;
cur_labels = find((t(1) <=labels) & (labels<= t(end)));
cur_labels_idx = labels(cur_labels);
amp = zeros(1,size(cur_labels,2));
figure
hold on
plot(t,filt_out(14,t))
plot(t,filt_out(4,t))
plot(cur_labels_idx,amp,'*g')
hold off
legend('chan14','chan4','labels')
title('Filtered recorndings superimposed')
ylabel('Amplitude')
xlabel('Timesamples')

            
        
    