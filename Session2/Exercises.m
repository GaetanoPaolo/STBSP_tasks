%% 2.1
load('ex1data.mat')
%% creating mode 1 and mode 2 vectors and plotting them
T1 = tens2mat(Tn,1); T2 = tens2mat(Tn,2);
figure(1)
plot3(T1(1,:),T1(2,:),T1(3,:),'x'), grid    % mode-1 vectors
sa = 2;
axis([-sa sa -sa sa -sa sa])
title('tensor mode-1 vectors')
figure(2)
plot3(T2(1,:),T2(2,:),T2(3,:),'x'), grid    % mode-2 vectors
axis([-sa sa -sa sa -sa sa])
title('tensor mode-2 vectors')
%% MLSVD
[UT,ST,svT] = mlsvd(Tn);
% sing_amount_1 = 3;
% sing_amount_2 = 3;
% sing_amount_3 = 3;
%% 
%% Mode 1
U_arr = {};
U_arr{1} = U{1}(:,1:sing_amount_1)';
X1 = tmprod(S,U_arr, 1);
X1 = reshape(X1,[3,10000]);
figure(1)
plot3(X1(1,:),X1(2,:),X1(3,:),'x'), grid    % mode-1 vectors
sa = 2;
axis([-sa sa -sa sa -sa sa])
title('tensor mode-1 vectors')

%% 2.2
load('ex2data.mat')
s = (rand([3,500])-0.5)/2;
n = noisy(zeros(3,500), 0);
x = A*s+n;
[F,delta] = aci(x);
corrsources = pinv(F)*x;
covsource = cov(corrsources');
[V,D] = eig(covsource);
[Ds, ind] = sort(diag(D),'descend');
V = V(:,ind);
construct = V(:,3)*V(:,3)'*corrsources;

