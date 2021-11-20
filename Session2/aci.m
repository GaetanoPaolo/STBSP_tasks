function [F,delta]=aci(Y)
% Comon, version 6 march 92
% English comments added in 1994
% [F,delta]=aci(Y)
% Y is the observations matrix
% This routine outputs a matrix F such that Y=F*Z, Z=pinv(F)*Y,
% and components of Z are uncorrelated and approximately independent
% F is Nxr, where r is the dimension Z;
% Entries of delta are sorted in decreasing order;
% Columns of F are of unit norm;
% The entry of largest modulus in each column of F is positive real.
% Initial and final values of contrast can be fprinted for checking.
% REFERENCE: P.Comon, "Independent Component Analysis, a new concept?",
% Signal Processing, Elsevier, vol.36, no 3, April 1994, 287-314.
%
[N,TT]=size(Y);T=max(N,TT);N=min(N,TT);
if TT==N, Y=Y';[N,T]=size(Y);end; % Y est maintenant NxT avec N<T.
%%%% STEPS 1 & 2: whitening and projection (PCA)
[U,S,V]=svd(Y',0);tol=max(size(S))*norm(S)*eps;
s=diag(S);I=find(s<tol);r=N;
if length(I)~=0, r=I(1)-1;U=U(:,1:r);S=S(1:r,1:r);V=V(:,1:r);end;
Z=U'*sqrt(T);L=V*S'/sqrt(T);F=L; %%%%%% on a Y=L*Z;
%%%%%% INITIAL CONTRAST
T=length(Z);contraste=0;
for i=1:r,
 gii=Z(i,:)*Z(i,:)'/T;Z2i=Z(i,:).^2;;giiii=Z2i*Z2i'/T;
 qiiii=giiii/gii/gii-3;contraste=contraste+qiiii*qiiii;
end;
%%%% STEPS 3 & 4 & 5: Unitary transform
S=Z;
if N==2,K=1;else,K=1+round(sqrt(N));end;  % K= max number of sweeps
Rot=eye(r);
for k=1:K,                           %%%%%% strating sweeps
Q=eye(r);
  for i=1:r-1,
  for j= i+1:r,
    S1ij=[S(i,:);S(j,:)];
    [Sij,qij]=tfuni4(S1ij);    %%%%%% processing a pair
    S(i,:)=Sij(1,:);S(j,:)=Sij(2,:);
    Qij=eye(r);Qij(i,i)=qij(1,1);Qij(i,j)=qij(1,2);
    Qij(j,i)=qij(2,1);Qij(j,j)=qij(2,2);
    Q=Qij*Q;
  end;
  end;
Rot=Rot*Q';
end;                                    %%%%%% end sweeps
F=F*Rot;
%%%%%% FINAL CONTRAST
S=Rot'*Z;
T=length(S);contraste=0;
for i=1:r,
 gii=S(i,:)*S(i,:)'/T;S2i=S(i,:).^2;;giiii=S2i*S2i'/T;
 qiiii=giiii/gii/gii-3;contraste=contraste+qiiii*qiiii;
end;
%%%% STEP 6: Norming columns
delta=diag(sqrt(sum(F.*conj(F))));
%%%% STEP 7: Sorting
[d,I]=sort(-diag(delta));E=eye(r);P=E(:,I)';delta=P*delta*P';F=F*P';
%%%% STEP 8: Norming
F=F*inv(delta);
%%%% STEP 9: Phase of columns
[y,I]=max(abs(F));
for i=1:r,Lambda(i)=conj(F(I(i),i));end;Lambda=Lambda./abs(Lambda);
F=F*diag(Lambda);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

function [S,A]=tfuni4(e)
%[S,A]=tfuni4(e)
% version corrigee fev 92
%Transformation orthogonale REELLE directe
%pour la separation de 2 sources en presence de bruit.
%Les sources sont supposees centrees

T=length(e);
%%%%% moments d'ordre 2
 g11=e(1,:)*e(1,:)'/T;%cv vers 1
 g22=e(2,:)*e(2,:)'/T;%cv vers 1
 g12=e(1,:)*e(2,:)'/T; %cv vers 0
%%%%% moments d'ordre 4
e2=e.^2;
 g1111=e2(1,:)*e2(1,:)'/T;
 g1112=e2(1,:).*e(1,:)*e(2,:)'/T;
 g1122=e2(1,:)*e2(2,:)'/T;
 g1222=e2(2,:).*e(2,:)*e(1,:)'/T;
 g2222=e2(2,:)*e2(2,:)'/T;
%%%%% cumulants croises d'ordre 4
 q1111=g1111-3*g11*g11;
 q1112=g1112-3*g11*g12;
 q1122=g1122-g11*g22-2*g12*g12;
 q1222=g1222-3*g22*g12;
	q2222=g2222-3*g22*g22;
%%%%% racine de Pw(x): si t est la tangente de l'angle, x=t-1/t.
u=q1111+q2222-6*q1122;v=q1222-q1112;z=q1111*q1111+q2222*q2222;
c4=q1111*q1112-q2222*q1222;
c3=z-4*(q1112*q1112+q1222*q1222)-3*q1122*(q1111+q2222);
c2=3*v*u;
c1=3*z-2*q1111*q2222-32*q1112*q1222-36*q1122*q1122;
c0=-4*(u*v+4*c4);
%c0=q1112*q2222-q1222*q1111-3*q1112*q1111+3*q1222*q2222-6*q1122*q1112+6*q1122*q1222;c0=4*c0
Pw=[c4 c3 c2 c1 c0];R=roots(Pw);I=find(abs(imag(R))<eps);xx=R(I);
%%%%% maximum du contraste en x
a0=q1111;a1=4*q1112;a2=6*q1122;a3=4*q1222;a4=q2222;
b4=a0*a0+a4*a4;
b3=2*(a3*a4-a0*a1);
b2=4*a0*a0+4*a4*a4+a1*a1+a3*a3+2*a0*a2+2*a2*a4;
b1=2*(-3*a0*a1+3*a3*a4+a1*a4+a2*a3-a0*a3-a1*a2);
b0=2*(a0*a0+a1*a1+a2*a2+a3*a3+a4*a4+2*a0*a2+2*a0*a4+2*a1*a3+2*a2*a4);
Pk=[b4 b3 b2 b1 b0];  % numerateur du contraste
Wk=polyval(Pk,xx);Vk=polyval([1 0 8 0 16],xx);Wk=Wk./Vk;
[Wmax,j]=max(Wk);Xsol=xx(j);
%%%%% maximum du contratse en theta
t=roots([1 -Xsol -1]);j=find(t<=1 & t>-1);t=t(j);
%%%%% test et conditionnement
if abs(t)< 100*eps	%eigen aanpassing; comon:	1/T,
  A=eye(2); %fprintf('pas de rotation plane pour cette paire\n');
else,
  A(1,1)=1/sqrt(1+t*t);A(2,2)=A(1,1);A(1,2)=t*A(1,1);A(2,1)=-A(1,2);
end;
%%%%% filtrage de la sortie
 S=A*e;
end
