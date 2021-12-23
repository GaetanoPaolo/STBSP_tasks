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
legend('raw datapoints (3 first mode 1 rows)','projected data on first 3 PCs')
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
SNRs = -50:5:50;
for i=SNRs
    siricatot=0;
    sirpcatot=0;
    for j = 1:1000
        s = (rand([3,500])-0.5)/2;
        x = A*s;
        [x,n] = noisy(x,i);
        [F,delta] = aci(x); 
        [sirica,P,D] = sir(A,F);
        siricatot = siricatot + sirica;
        covsource = cov(x');
        Q = eye(3);
        %[W,D] = eig(x*x',Q);
        [W,D] = eig(covsource,Q);
        %projB = (U_slice(:,1:3)'*cur_slice)';
        [U,S,V] = svd(x);
        aest2 = U'*U;
        [sirpca,P,D] = sir(A,W');
        sirpcatot = sirpcatot + sirpca;
    end
    sirsica = [sirsica siricatot/1000];
    sirspca = [sirspca sirpcatot/1000];
end
figure
hold on
plot(SNRs, sirsica)
plot(SNRs, sirspca)
hold off
title('SIRS')
legend('SIR from ICA','SIR from PCA')
%The added noise using noisy-function is Gaussian
% The SIR curves show that there is a much better source separation using
% ICA than PCA. The pure source separation in PCA is so bad that , in the low
% SNR case, the high Gaussian noise power makes this interference a bit less worse (maybe due to the lower difference in signal between channels?).
% For higher SNR values, the SIR of PCA remains constant: Covariance not
% affected anymore by Gaussian noise?
% The opposite is true for the ICA: From page 76 in HB: The estimated
% mixing matrix F comes from a CPD: estimationbased on non-Gaussian  part
% of the data. This non_Gaussian part increases as the SNR gets higher =>
% better estimate of the mixture matrix.
%% 2.3 
load('ex3data.mat')
[rowA,~] = size(A);
[rowB,~] = size(B);
[rowC,~] = size(C);
U = {A,B,C};
Trial = cpdgen(U);
disp(size(Trial))
% Plotting
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

% 2.3.1
cur_slice = T(:,:,4);
[U_slice,S_slice,V_slice] = svd(cur_slice);
projB = (U_slice(:,1:3)'*cur_slice)';
projA = cur_slice*V_slice(:,1:3);

%Plotting
%SVD components
figure(4)
subplot(3,1,1)
plot(1:rowA,(U_slice(:,1)'))
title('Component1 matrix A SVD slice 4')
subplot(3,1,2)
plot(1:rowA,(U_slice(:,2)'))
title('Component2 matrix A SVD slice 4')
subplot(3,1,3)
plot(1:rowA,(U_slice(:,3)'))
title('Component3 matrix A SVD slice 4')
figure(5)
subplot(3,1,1)
plot(1:rowB,V_slice(:,1)')
title('Component1 Matrix B SVD slice 4')
subplot(3,1,2)
plot(1:rowB,V_slice(:,2)')
title('Component2 Matrix B SVD slice 4')
subplot(3,1,3)
plot(1:rowB,V_slice(:,3)')
title('Component3 Matrix B SVD slice 4')


% PCA
figure(6)
subplot(3,1,1)
plot(1:rowA,projA(:,1))
title('Component1 matrix A PCA slice 4')
subplot(3,1,2)
plot(1:rowA,projA(:,2))
title('Component2 matrix A PCA slice 4')
subplot(3,1,3)
plot(1:rowA,projA(:,3))
title('Component3 matrix A PCA slice 4')
figure(7)
subplot(3,1,1)
plot(1:rowB,projB(:,1))
title('Component1 Matrix B PCA slice 4')
subplot(3,1,2)
plot(1:rowB,projB(:,2))
title('Component2 Matrix B PCA slice 4')
subplot(3,1,3)
plot(1:rowB,projB(:,3))
title('Component3 Matrix B PCA slice 4')
%Comments: Permutation of the components, demixed components still scaled,
%PCA = projection on components having largest variances/ on othogonal
%vectors spanning the space of the data , but each element in T(:,:,4) is a
%linear combination of each of elements of each of the 3 components of A,B
%and C. Its principal components (orthogonal vectors that span its space with the most variance)
%will thus still be mixtures of those
%components and thus also the slices' projection onto them => elementsof
%differnet components mixed together on plot.
% 2.3.2
T_noise = noisy(T,15);
[U_noise, S_noise, sv_noise] = mlsvd(T_noise);
% projecting the same slice in 1 on the mlsvd components
projB_ml = (U_noise{1}(:,1:3)'*cur_slice)';
projA_ml = cur_slice*U_noise{2}(:,1:3);

%Plotting 
% figure(6)
% subplot(3,1,1)
% plot(1:rowA,projA_ml(:,1))
% title('Component1 matrix A MLPCA')
% subplot(3,1,2)
% plot(1:rowA,projA_ml(:,2))
% title('Component2 matrix A MLPCA')
% subplot(3,1,3)
% plot(1:rowA,projA_ml(:,3))
% title('Component3 matrix A MLPCA')
% figure(7)
% subplot(3,1,1)
% plot(1:rowB,projB_ml(:,1))
% title('Component1 Matrix B MLPCA')
% subplot(3,1,2)
% plot(1:rowB,projB_ml(:,2))
% title('Component2 Matrix B MLPCA')
% subplot(3,1,3)
% plot(1:rowB,projB_ml(:,3))
% title('Component3 Matrix B MLPCA')

R = 4; % setting the amount of rank 1 terms

% ALS
options = struct;
options.Compression = @mlsvd_rsi;
%As the tensor is noisy => compression to reduce computational compl.
options.Initialization = @cpd_gevd;
% Rankest estimates the tensor rank at 41. This does not exceed the second
% largest dimension of our tensor. According to documentation: gevd
% initialisation algorithm can be used for initialization. This gives
% a lower error when looking at output.Initialization. 
%https://tensorlab.net/demos/basic.html
%Reason? HB p. 57 (59 in pdf): If theorems are met (Th 3: linearly independent
%columns of the factor matrices U, Th7: full column rank of Khatri Rao product: CPD can directly be
%computed using GEVD => initialization with GEVD already gives good
%approximation 
options.Algorithm = @cpd_als;
options.Refinement = @cpd_als;
options.ExploitStructure = true;
%options.AlgorithmOptions.Display = 1;
options.AlgorithmOptions.MaxIter = 100;      % Default 200
options.AlgorithmOptions.TolFun = eps^2;     % Default 1e-12
options.AlgorithmOptions.TolX = eps;         % Default 1e-6
[U_als,output_als] = cpd(T_noise,R,options);

%Plotting
% figure
% for r = 1:R
%     subplot(R,1,r)
%     plot(1:rowA,U_als{1}(:,r));
%     title(strcat('Component',int2str(r),' A CPD ALS'))
% end
% figure
% for r = 1:R
%     subplot(R,1,r)
%     plot(1:rowB,U_als{2}(:,r));
%     title(strcat('Component',int2str(r),' B CPD ALS'))
% end
% figure
% for r = 1:R
%     subplot(R,1,r)
%     plot(1:rowC,U_als{3}(:,r));
%     title(strcat('Component',int2str(r),' C CPD ALS'))
% end
% NLS
options = struct;
options.Compression = @mlsvd_rsi;
options.Initialization = @cpd_gevd;
options.Algorithm = @cpd_nls;
options.Refinement = @cpd_nls;
options.ExploitStructure = true;
%options.AlgorithmOptions.Display = 1;
options.AlgorithmOptions.MaxIter = 100;      % Default 200
options.AlgorithmOptions.TolFun = eps^2;     % Default 1e-12
options.AlgorithmOptions.TolX = eps;         % Default 1e-6
[U_nls,output_nls] = cpd(T_noise,R,options);

% figure
% for r = 1:R
%     subplot(R,1,r)
%     plot(1:rowA,U_nls{1}(:,r));
%     title(strcat('Component',int2str(r),' A CPD NLS'))
% end
% figure
% for r = 1:R
%     subplot(R,1,r)
%     plot(1:rowB,U_nls{2}(:,r));
%     title(strcat('Component',int2str(r),' B CPD NLS'))
% end
% figure
% for r = 1:R
%     subplot(R,1,r)
%     plot(1:rowC,U_nls{3}(:,r));
%     title(strcat('Component',int2str(r),' C CPD NLS'))
% end
% Plotting the convergence curves for both algorithms
figure();
semilogy(output_nls.Algorithm.fval); hold all;
semilogy(output_als.Algorithm.fval);
ylabel('Objective function'); xlabel('Iteration');
title('Convergence plot'); legend('cpd\_nls','cpd\_als')

% Comment about the CPD rank 1 terms: COmpared to before:
% Sometimes inversion of sign and permutaiton but mostly good approx of
% original components => almost perfect component separation: CPD = unique
% and EVD is not?
% Very similar results for ALS and NLS upt to a component
% 4th component and further = noise added to the tensor
%Weird: When NLS converges to a higher loss value (should be minimized?),
%it leaks less noise to the components than ALS that converged toe a lower
%value (better?)

%% 2.4
load('ex4data.mat')

%LMLRA-based harmonic retrieval
y = hankelize(x,'order',3);
options.Initialization = @mlsvd;
[UYinc,SYinc] = lmlra(y,[3 3 3],options); 

%% 2.5


