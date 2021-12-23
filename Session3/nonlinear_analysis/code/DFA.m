function [Fshort, Flong, alphashort, alphalong] = DFA(RR)
    x_hat = mean(RR);
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
    alphashort = zeros(1,length(1:2:length(rangeshort)));
    for i = 2:length(rangeshort)
        alphashort(i) = (log10(Fshort(i))-log10(Fshort(i-1)))/(log(i+rangeshort(1)-1)-log(i+rangeshort(1)-2));
    end
    alphalong = zeros(1,length(1:2:length(rangelong)));
    for i = 2:length(rangelong)
        alphalong(i) = (log10(Flong(i))-log10(Flong(i-1)))/(log(i+rangelong(1)-1)-log(i+rangelong(1)-2));
    end
end

