%%
anxiety = ["../data/RR518.mat","../data/RR542.mat","../data/RR547.mat","../data/RR562.mat","../data/RR576.mat"];
chill = ["../data/RR507.mat","../data/RR514.mat","../data/RR571.mat","../data/RR619.mat","../data/RR621.mat"];
%%
olphoa = [];
olphoc = [];
for k = 1:length(anxiety)
    load(anxiety(k))
    fs = 2;
    time = cumsum(RR/1000); % Time in seconds
    time_new = 0:1/fs:time(end)-time(1);  
    RR_resamp = spline(time-time(1),RR,time_new); 
    x_hat = mean(RR_resamp);
    figure
    plot(1:length(RR_resamp),RR_resamp)
    y = cumsum(RR_resamp-x_hat);
    figure
    plot(1:length(y),y)
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
   
    A = [log10(rangelong)' ones(length(rangelong),1)];
    b = log10(Flong)';
    pshort = A\b;
    disp("Alpha")
    disp(pshort(1))
    olphoa = [olphoa pshort(1)];
    figure
    plot(1:length(Flong),Flong)
    title('F')
    figure
    plot(log10(rangelong),log10(Flong))
    xlabel('log(n)')
    ylabel('log(F)')

end
for k = 1:length(anxiety)
    load(chill(k))
    fs = 2;
    time = cumsum(RR/1000); % Time in seconds
    time_new = 0:1/fs:time(end)-time(1);  
    RR_resamp = spline(time-time(1),RR,time_new); 
    x_hat = mean(RR_resamp);
    figure
    plot(1:length(RR_resamp),RR_resamp)
    y = cumsum(RR_resamp-x_hat);
    figure
    plot(1:length(y),y)
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
   
    A = [log10(rangelong)' ones(length(rangelong),1)];
    b = log10(Flong)';
    pshort = A\b;
    disp("Alpha")
    disp(pshort(1))
    olphoc = [olphoc pshort(1)];
    figure
    plot(1:length(Flong),Flong)
    title('F')
    figure
    plot(log10(rangelong),log10(Flong))
    xlabel('log(n)')
    ylabel('log(F)')

end
figure
bar([olphoc;olphoa])
xlabel('1 = Low Anxiety Group  |  2 = High Anxiety Group')
ylabel('Amplitude')
%%
slopea =[];
for k = 1:length(anxiety)
    load(anxiety(k))
    slopea = [slopea freqdropoff(RR)];
end
slopec =[];
for k = 1:length(anxiety)
    load(chill(k))
    slopec = [slopec freqdropoff(RR)];
end
figure 
bar([slopec;slopea])
xlabel('1 = Low Anxiety Group  |  2 = High Anxiety Group')
ylabel('Amplitude')

%%
disp('Anxiety')

fda = [];
sea = [];
lea = [];
cda = [];
for k = 1:length(anxiety)
    load(anxiety(k))
    [FD,SE,LE,CD] = nonlin_measures(RR);
    fda = [fda FD];
    sea = [sea SE];
    lea = [lea LE];
    cda = [cda CD];
end

disp('Chill')

fdc = [];
sec = [];
lec = [];
cdc = [];
for k = 1:length(anxiety)
    load(chill(k))
    [FD,SE,LE,CD] = nonlin_measures(RR);
    fdc = [fdc FD];
    sec = [sec SE];
    lec = [lec LE];
    cdc = [cdc CD]; 
end


%%
figure
bar([lec;lea])
xlabel('1 = Low Anxiety Group  |  2 = High Anxiety Group')
ylabel('Amplitude')

%%

disp('Anxiety')

sd1 = [];
sd2 = [];
for k = 1:length(anxiety)
    load(anxiety(k))
    [SD1, SD2] = poincare(RR);
    sd1 = [sd1 SD1];
    sd2 = [sd2 SD2];
end

disp('Chill')
sd1c = [];
sd2c = [];
for k = 1:length(anxiety)
    load(chill(k))
    [SD1, SD2] = poincare(RR);
    sd1c = [sd1c SD1];
    sd2c = [sd2c SD2];
end

figure
bar([sd1 sd2;sd1c sd2c])
xlabel('1 = Low Anxiety Group  |  2 = High Anxiety Group')
ylabel('Amplitude')
   
    
    