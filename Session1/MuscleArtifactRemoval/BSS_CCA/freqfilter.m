function filteredsignal=freqfilter(signal,lp,hp,fs);
filter=1;
filter2=0;
% Determination of b & a for the filter
%     if lp~=0
%         if hp~=0
%             [b,a]=butter(1,[hp/(fs/2) lp/(fs/2)]);%4
%         else
%             [b,a]=butter(1,lp/(fs/2));
%         end
%     elseif hp~=0
%         [b,a]=butter(1,hp/(fs/2),'high');
%     else
%         filter=0;%no filtering needed because hp en lp ==0
%     end
if lp==0 & hp==0
    filter=0;
elseif lp==0%high pass filter
    w0=2*pi*hp;
    Q=1/sqrt(2);
    b=4*fs^2*[1 -2 1];
    a=[(4*fs^2/(w0)^2)+(2*fs/(w0*Q))+1 (-8*(fs)^2/(w0)^2)+2 (4*fs^2/(w0)^2)-(2*fs/(w0*Q))+1];
elseif hp==0 %low pass filter
    w0=2*pi*lp;
    Q=1/sqrt(2);
    b=[0 0 1];
    a=[(4*fs^2/(w0)^2)+(2*fs/(w0*Q))+1 (-8*(fs)^2/(w0)^2)+2 (4*fs^2/(w0)^2)-(2*fs/(w0*Q))+1];
else %bandpass
    w0=2*pi*hp;
    Q=1/sqrt(2);
    b=4*fs^2*[1 -2 1];
    a=[(4*fs^2/(w0)^2)+(2*fs/(w0*Q))+1 (-8*(fs)^2/(w0)^2)+2 (4*fs^2/(w0)^2)-(2*fs/(w0*Q))+1];
    filter2=1;
    w0=2*pi*lp;
    b2=[0 0 1];
    a2=[(4*fs^2/(w0)^2)+(2*fs/(w0*Q))+1 (-8*(fs)^2/(w0)^2)+2 (4*fs^2/(w0)^2)-(2*fs/(w0*Q))+1];
    
%     fo=(lp+hp)/2
%     B=(lp-hp)/2
%     Q=fo/B;
%     b=[2*fs/(Q*2*pi*fo) 0 -2*fs/(Q*2*pi*fo)];
%     a=[(4*fs^2/(2*pi*fo)^2)+2*fs/(Q*2*pi*fo)+1 (-8*fs^2/(2*pi*fo)^2)+2 (4*fs^2/(2*pi*fo)^2)-2*fs/(Q*2*pi*fo)+1];
end
%     lpnr=find([15 30 35 0]==lp);
%     hpnr=find([0 0.04 0.095 0.27 0.3 0.53 1 1.6 3 5 10 16]==hp);
%     load filtercoefs
%     b=filtercoefs{hpnr,lpnr};
%     a=1;


% The filtering    
    if filter
        chan=size(signal,1);
        ch=1;
        signal2filt=[zeros(21,250*10) signal(:,:) zeros(21,250*10)];
        filteredsignal=zeros(size(signal2filt));
        %gemsignal=mean(signal,2);
        %signal=signal-gemsignal*ones(1,size(signal,2));
        while ch<=chan
            filteredsignal(ch,:)=filtfilt(b,a,signal2filt(ch,:));%signal(ch,:)
            ch=ch+1;
        end
        filtered=filteredsignal;
        clear filteredsignal
        filteredsignal=filtered(:,250*10+1:end-250*10);
        %filteredsignal=filteredsignal+gemsignal*ones(1,size(signal,2));
    else
        filteredsignal=signal;
    end
    
    if filter2==1
        chan=size(signal,1);
        ch=1;
        signal2filt=[zeros(21,250*10) filteredsignal(:,:) zeros(21,250*10)];
        filteredsignal2=zeros(size(signal2filt));
        %gemsignal=mean(signal,2);
        %signal=signal-gemsignal*ones(1,size(signal,2));
        while ch<=chan
            filteredsignal2(ch,:)=filtfilt(b2,a2,signal2filt(ch,:));%signal(ch,:)
            ch=ch+1;
        end
        filtered=filteredsignal2;
        clear filteredsignal
        filteredsignal=filtered(:,250*10+1:end-250*10);
    end
        