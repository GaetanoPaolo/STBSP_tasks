%% 2.1
load('ex1data.mat')
[U,S,sv] = mlsvd(Tn);
sing_amount_1 = 3;
sing_amount_2 = 3;
sing_amount_3 = 3;
U_arr = {};
U_arr{1} = U{1}(:,1:sing_amount_1)';
%U_arr{2} = U{2}(:,1:sing_amount_2)';
%U_arr{3} = U{3}(:,1:sing_amount_3)';
X = tmprod(S,U_arr, 1);
figure(1)
plot3(X(1,:),X(2,:),X(3,:),'x'), grid    % mode-1 vectors
sa = 200;
axis([-sa sa -sa sa -sa sa])
title('tensor mode-1 vectors')

%% 2.
load('ex2data.mat')
s = (rand([3,500])-0.5)/2;
n =noisy(zeros(3,500), 5);
x = A*s+n;
[F,delta]=aci(s+n)
