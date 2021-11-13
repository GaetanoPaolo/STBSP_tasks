function Rnn = lagged_n_cov(noiseSegments,trainingData)
    [rows,~] = size(noiseSegments);
    [~,col] = size(trainingData);
    total = zeros(size(trainingData,2));
    lag = 25; %Template window lenght
%     tot_noise_mat = zeros(rows,col);
%     end_of_seq = zeros(rows,1);
%     for j = 1:rows
%         cur_sample = trainingData(noiseSegments(j),:);
%         tot_noise_mat(j,:) = cur_sample;
%         if j < rows
%             next_sample = trainingData(noiseSegments(j),:);
%             if cur_sample+1 < next_sample
%                 end_of_seq(j) = 1;
%             end
%         end
%     end
%     avg = mean(tot_noise_mat,1);
%     i = lag;
%     count = 0;
%     while i < rows
%         if end_of_seq(i-1) == 1
%             i = i+lag-1;
%         end
%         temp = tot_noise_mat(i-lag+1,:);
%         temp_lag = tot_noise_mat(i,:);
%         temp_mat = (temp'-avg')*(temp_lag-avg);
%         total = total + temp_mat;
%         count = count +1;
%         i = i+1;
%     end
    for i = 1:rows-lag
        temp = trainingData(noiseSegments(i):noiseSegments(i+lag),:);
        temp_mat = temp'*temp;
        total = total + temp_mat;
    end
    Rnn = total/(rows-lag);
end