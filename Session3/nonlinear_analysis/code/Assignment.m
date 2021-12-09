anxiety = ["../data/RR518.mat","../data/RR542.mat","../data/RR547.mat","../data/RR562.mat","../data/RR576.mat"];
chill = ["../data/RR507.mat","../data/RR514.mat","../data/RR571.mat","../data/RR619.mat","../data/RR621.mat"];
for k = 1:length(chill)
    load
fs = 2;
time = cumsum(RR/1000); % Time in seconds
time_new = 0:1/fs:time(end)-time(1);  
RR_resamp = spline(time-time(1),RR,time_new); 
%% DFA 
x_hat = mean(RR_resamp);
y = cumsum(RR_resamp-x_hat);
[~,len] = size(y);
rangeshort = 4:16;
rangelong = 16:64;
Fshort = zeros(1,length(rangeshort));
Flong = zeros(1,length(rangelong));
for n = rangeshort
    yn = zeros(1,len);
    for i = 1:n:len-n
        b = y(i:i+n-1);
        A = [(i:i+n-1)' ones(n,1)];
        p = A\b';
        yn(i:i+n-1) = p(1)*(i:i+n-1)+p(2);
    end
    Fshort(n-rangeshort(1)+1) = sqrt((1/len)*sum((y-yn).^2));
end
for n = rangelong
    yn = zeros(1,len);
    for i = 1:n:len-n
        b = y(i:i+n-1);
        A = [(i:i+n-1)' ones(n,1)];
        p = A\b';
        yn(i:i+n-1) = p(1)*(i:i+n-1)+p(2);
    end
    Flong(n-rangelong(1)+1) = sqrt((1/len)*sum((y-yn).^2));
end
% alpha = zeros(1,length(1:2:length(range)));
% for i = 2:length(range)
%     alpha(i) = (log10(F(i))-log10(F(i-1)))/(log(i+range(1)-1)-log(i+range(1)-2));
% end
A = [log10(range)' ones(length(range),1)];
b = log10(Fshort)';
pshort = A\b;
end
disp("Mean Alpha")
disp(mean(alpha))
disp("LS Alpha")
disp(p(1))
figure
plot(1:length(F),F)
title('F')
figure
plot(1:length(alpha),alpha)
title('Alpha')
figure
plot(log10(range),log10(F))
xlabel('log(n)')
ylabel('log(F)')
  
   
    
    