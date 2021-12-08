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
sirsica = [];
sirspca = [];
SNRs = 0:5:50;
for i=SNRs
    siricatot=0;
    sirpcatot=0;
    for j = 1:100
        s = (rand([3,500])-0.5)/2;
        x = A*s;
        [x,n] = noisy(x,i);
        [F,delta] = aci(x); 
        [sirica,P,D] = sir(A,F);
        siricatot = siricatot + sirica;
        covsource = cov(x');
        Q = eye(3);
        [W,D] = eig(x*x',Q);
        %projB = (U_slice(:,1:3)'*cur_slice)';
        [U,S,V] = svd(x);
        aest2 = U'*U;
        [sirpca,P,D] = sir(A,W');
        sirpcatot = sirpcatot + sirpca;
    end
    sirsica = [sirsica siricatot/100];
    sirspca = [sirspca sirpcatot/100];
    disp("skeeeeet")
end
hold on
plot(SNRs, sirsica)
plot(SNRs, sirspca)
%% 2.3 
load('ex3data.mat')
[rowA,~] = size(A);
[rowB,~] = size(B);
[rowC,~] = size(C);
figure(1)
subplot(3,1,1)
plot(1:rowA,A(:,1))
title('Component1 matrix A')
subplot(3,1,2)
plot(1:rowA,A(:,2))
title('Component2 matrix A')
subplot(3,1,3)
plot(1:rowA,A(:,3))
title('Component3 matrix A')
figure(2)
subplot(3,1,1)
plot(1:rowB,B(:,1))
title('Component1 Matrix B')
subplot(3,1,2)
plot(1:rowB,B(:,2))
title('Component2 Matrix B')
subplot(3,1,3)
plot(1:rowB,B(:,3))
title('Component3 Matrix B')
figure(3)
subplot(3,1,1)
plot(1:rowC,C(:,1))
title('Component1 matrix C')
subplot(3,1,2)
plot(1:rowC,C(:,2))
title('Component2 matrix C')
subplot(3,1,3)
plot(1:rowC,C(:,3))
title('Component3 matrix C')

% estimate componenents from T(:,:,4)
cur_slice = T(:,:,4);
[U_slice,S_slice,V_slice] = svd(cur_slice);
projB = (U_slice(:,1:3)'*cur_slice)';
projA = cur_slice*V_slice(:,1:3);
figure(4)
subplot(3,1,1)
plot(1:rowA,projA(:,1))
title('Component1 matrix A')
subplot(3,1,2)
plot(1:rowA,projA(:,2))
title('Component2 matrix A')
subplot(3,1,3)
plot(1:rowA,projA(:,3))
title('Component3 matrix A')
figure(5)
subplot(3,1,1)
plot(1:rowB,projB(:,1))
title('Component1 Matrix B PCA')
subplot(3,1,2)
plot(1:rowB,projB(:,2))
title('Component2 Matrix B PCA')
subplot(3,1,3)
plot(1:rowB,projB(:,3))
title('Component3 Matrix B PCA')
%% 2.4
load('ex4data.mat')

%LMLRA-based harmonic retrieval
y = hankelize(x);
[UYinc,SYinc] = lmlra(y,[2 2]); 
Ylmlra = lmlragen(UYinc,SYinc);

