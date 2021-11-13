function notched=notchfilter(signal,fs)
        
%     om=50*2*pi/fs;
%     z1=cos(om)+sqrt(-1)*sin(om);z2=cos(om)-sqrt(-1)*sin(om);
%     [b] = [1 -(z1+z2) 1];
%     [a] = [1 0 0];
    [b,a]=butter(1,[50-1/fs*2 50+1/fs*2]/fs*2,'stop');
    chan=size(signal,1);
    j=1;
    while j<=chan
        signal(j,:) = filtfilt(b,a,signal(j,:));
        j=j+1;
    end
    notched=signal;