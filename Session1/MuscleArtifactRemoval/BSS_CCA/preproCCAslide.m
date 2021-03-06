function [C,corrlastwith,corrfirstaway]=preproCCAslide(L,dd)
%L signal
%type   'con' or 'del'
%C cleaned signal
%   C{1}=original signal
%   C{i}=the (i-1) last components eliminated
%   C{end}=all components but one are eliminated
%corrlastwith (i) the corr coef belonging to the last kept component when
%   the (i-1) last components are eliminated
%corrfirstaway (i) the corr coef belonging to the first removed component when 
%   the (i-1) last components are eliminated

gems=mean(L,2);% zero mean
L=L-gems*ones(1,size(L,2));
[y,w,r] = ccaqr(L,dd);
A=pinv(w');
Amatrix=A;
i=1;
C=cell(1,size(A,1));
C{1}=L+gems*ones(1,size(L,2));

while i<size(A,1)
    A(:,end-i+1:end)=0;
    B=A*y;
    
    i=i+1;
    C{i}=[B B(:,end-dd+1:end)]+gems*ones(1,size(L,2));    
    
end


corrlastwith=flipud(r);
corrfirstaway=[0 ;corrlastwith(1:end-1)];

