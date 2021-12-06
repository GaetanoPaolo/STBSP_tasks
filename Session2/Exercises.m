%% 2.1
load('ex1data.mat')
%% creating mode 1 and mode 2 
T1 = tens2mat(Tn,1); T2 = tens2mat(Tn,2);

%% MLSVD
[UT,ST,svT] = mlsvd(Tn);
% sing_amount_1 = 3;
% sing_amount_2 = 3;
% sing_amount_3 = 3;
%% Projection on PC's
Tcomp1 = UT{1}(:,1:3) * UT{1}(:,1:3)' * T1;    % proj on dominant 2 mode-1 PCs
Tcomp2 = UT{2}(:,1:2) * UT{2}(:,1:2)' * T2;    % proj on dominant 2 mode-2 PCs
Tcomp2bis = UT{2}(:,1) * UT{2}(:,1)' * T2;     % proj on dominant 1 mode-2 PC
plt_rows = [1,2,3];
figure(1) % mode-1 vectors
hold on  
plot3(T1(plt_rows(1),:),T1(plt_rows(2),:),T1(plt_rows(3),:),'x'), grid 
plot3(Tcomp1(plt_rows(1),:),Tcomp1(plt_rows(2),:),Tcomp1(plt_rows(3),:),'rx')
hold off
sa = 2;
axis([-sa sa -sa sa -sa sa])
title('tensor mode-1 vectors')
legend('raw datapoints (3 first mode 1 rows)','projected data on first 3 PCss')
figure(2)
hold on
plot3(T2(1,:),T2(2,:),T2(3,:),'x'), grid 
plot3(Tcomp2(1,:),Tcomp2(2,:),Tcomp2(3,:),'rx')
plot3(Tcomp2bis(1,:),Tcomp2bis(2,:),Tcomp2bis(3,:),'gx')
hold off
   % mode-2 vectors
axis([-sa sa -sa sa -sa sa])
title('tensor mode-2 vectors')
legend('raw datapoints (3 first mode 2 rows)','projected data on first 3 PCs','projected data on first PC')

%% 2.2
load('ex2data.mat')
s = (rand([3,500])-0.5)/2;
n = noisy(zeros(3,500), 0);
x = A*s+n;
[F,delta] = aci(x);
corrsources = pinv(F)*x;
covsource = cov(corrsources');
[V,D] = eig(covsource);
disp(V)
[Ds, ind] = sort(diag(D),'descend');
V = V(:,ind);
construct = V(:,3)*V(:,3)'*corrsources;
%% 2.3 
load('ex3data.mat')
figure(1)
plot3(A(:,1),A(:,2),A(:,3),'rx')
title('Matrix A')
figure(2)
plot3(B(:,1),B(:,2),B(:,3),'rx')
title('Matrix B')
figure(3)
plot3(C(:,1),C(:,2),C(:,3),'rx')
title('Matrix C')

% estimate componenents from T(:,:,4)
cur_slice = T(:,:,4);
[U_slice,S_slice,V_slice] = svd(cur_slice);
