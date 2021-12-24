function [SD1, SD2] = poincare(RR)
    x = RR;
    x = x(1:end-1);
    y = RR;
    y = y(2:end);
    scatter(x,y)
    SD1 = std(x-y)/sqrt(2);
    SD2 = std(x+y)/sqrt(2);
end