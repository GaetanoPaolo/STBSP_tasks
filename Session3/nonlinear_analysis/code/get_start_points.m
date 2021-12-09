%% Nieuwe functie
function [x,x_ix,y,y_ix,ok]=get_start_points(X,T,T0,N,e_0)
x_ix=floor(N*rand/3)+1;
x=X(x_ix,:);
y_ix=1;
for i=1:N
    if (abs(T(i)-T(x_ix))>T0)&&(sum(abs(x-X(i,:)))<e_0)
        y_ix=i;
        break
    end
end
y=X(y_ix,:);

if i==N
    ok=0;
else
    ok=1;
end