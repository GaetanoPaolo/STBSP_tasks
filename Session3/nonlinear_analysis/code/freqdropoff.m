function slope = freqdropoff(RR)
    fs = 2;
    time = cumsum(RR/1000); % Time in seconds
    time_new = 0:1/fs:time(end)-time(1);  
    RR_resamp = spline(time-time(1),RR,time_new); 
    n = length(RR_resamp);
    y = fft(RR_resamp);
    f = (0:n-1)*(fs/n);
    fselup = f<=10^(-2);
    fsellow = f>=10^(-4);
    fseltot = fselup & fsellow;
    f = f(fseltot);
    power = (abs(y).^2)/n;
    power = power(fseltot);
    flog = log(f);
    plog = log(power);
    b = plog;
    A = [ones(length(flog),1) flog'];
    regress = A\b';
    slope = regress(2);
end