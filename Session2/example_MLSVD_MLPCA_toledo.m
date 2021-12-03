
% make sure Matlab path includes Tensorlab

% two-way PCA
%%%%%%%%%%%%%%

% data
Nmat = randn(3,500);
[Qmat,Rmat] = qr(randn(3,3));
Dmat = [7 4 1];                     % spatial color
Xmat =  Qmat * diag(Dmat) * Nmat;   % data
figure(1)
plot3(Xmat(1,:),Xmat(2,:),Xmat(3,:),'x'), grid
title('matrix column vectors')

%%
% SVD
[UXmat,SXmat,VXmat] = svd(Xmat,'econ');
disp('matrix singular values:')
disp(SXmat/SXmat(3,3))     % ~ [7 4 1]

%%
% projection on dominant 2 PCs
Xmattrunc = UXmat(:,1:2) * UXmat(:,1:2)' * Xmat;
figure(1), hold, plot3(Xmattrunc(1,:),Xmattrunc(2,:),Xmattrunc(3,:),'rx') % 3D plot
figure(2), plot(SXmat(1,1)*VXmat(:,1), SXmat(2,2)*VXmat(:,2),'rx')  % 2D plot
axis([-25, 25, -25, 25])

%% three-way PCA
%%%%%%%%%%%%%%%%

% data
N = randn(3,3,500);
[Q1,R1] = qr(randn(3,3));
[Q2,R2] = qr(randn(3,3));
D1 = [7 4 1];                   % color
D2 = [16 4 1];                  % worse condition than mode 1
U{1} = Q1 * diag(D1); U{2} = Q2 * diag(D2); 
X = tmprod(N,U, [1 2]);

X1 = tens2mat(X,1); X2 = tens2mat(X,2);
figure(3)
plot3(X1(1,:),X1(2,:),X1(3,:),'x'), grid    % mode-1 vectors
sa = 200;
axis([-sa sa -sa sa -sa sa])
title('tensor mode-1 vectors')
figure(4)
plot3(X2(1,:),X2(2,:),X2(3,:),'x'), grid    % mode-2 vectors
axis([-sa sa -sa sa -sa sa])
title('tensor mode-2 vectors')


%%
% MLSVD
[UX,SX,svX] = mlsvd(X);
disp('mode-1 singular values:'), disp(svX{1}')    
disp('mode-2 singular values:'), disp(svX{2}')    

%%
% projection on dominant PCs
Xtrunc1 = UX{1}(:,1:2) * UX{1}(:,1:2)' * X1;    % proj on dominant 2 mode-1 PCs
Xtrunc2 = UX{2}(:,1:2) * UX{2}(:,1:2)' * X2;    % proj on dominant 2 mode-2 PCs
Xtrunc2bis = UX{2}(:,1) * UX{2}(:,1)' * X2;     % proj on dominant 1 mode-2 PC
figure(3), hold, plot3(Xtrunc1(1,:),Xtrunc1(2,:),Xtrunc1(3,:),'rx')
figure(4), hold, plot3(Xtrunc2(1,:),Xtrunc2(2,:),Xtrunc2(3,:),'rx')
figure(4), plot3(Xtrunc2bis(1,:),Xtrunc2bis(2,:),Xtrunc2bis(3,:),'gx')


