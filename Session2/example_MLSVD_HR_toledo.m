%% data

t = 0:0.01:4.98;
s1 = 2*exp(-t);                 % 1 real pole
s2 = exp(-0.3*t).*cos(3*t);     % 2 complex poles
x = s2-s1;
z = [exp(-0.01), exp(-0.003+1i*0.03), exp(-0.003-1i*0.03)].';
disp('ztrue:'), disp(z);                        % poles
figure(1); plot(t,x)

Hx1 = hankelize(x,'order',3);   % tensorization
figure(2); surf3(Hx1)

xn = noisy(x,5);                % SNR = 5 dB
Hx1n = hankelize(xn,'order',3); % tensorization
figure(3); plot(t,xn)           % noisy signal
figure(4); surf3(Hx1n)          % noisy tensor

%% low ML rank approximation

% MLSVD, estimation ML rank
[U,S,sv] = mlsvd(Hx1n);
figure(5); 
subplot(211), plot(sv{1},'x');  % dim core == [3 3 3]
subplot(212), plot(sv{1}(1:10),'x') 
% or use GUI to inspect

% truncated MLSVD
[Utrunc,Strunc]=mlsvd(Hx1n,[3 3 3],0);  

% best low ML rank approximation
options.Initialization = @mlsvd;
[Uopt,Sopt]=lmlra(Hx1n,[3 3 3],options);

% comparison
format long
relerrtrunc = frob(lmlrares(Hx1n,Utrunc,Strunc))/frob(Hx1n)  % relative reconstruction error trunc
relerropt = frob(lmlrares(Hx1n,Uopt,Sopt))/frob(Hx1n)   % relative reconstruction error best
sangle = lmlraerr(Uopt,Utrunc) % angles between subspace estimates

%% harmonic retrieval

% pole estimates
U1toptrunc = Utrunc{1}(1:166,1:3); U1bottomtrunc = Utrunc{1}(2:167,1:3);
disp('ztrunc:'), disp(eig(pinv(U1toptrunc)*U1bottomtrunc))   % pole estimates truncation ~ z

U1topopt = Uopt{1}(1:166,1:3); U1bottomopt = Uopt{1}(2:167,1:3);
disp('zopt:'), disp(eig(pinv(U1topopt)*U1bottomopt))       % pole estimates best low ML rank approx ~ z
