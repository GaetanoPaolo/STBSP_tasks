function el=elpos19osg()

el=zeros(19,2);
el=[ 90  75;... %Fp2
     90  36;... %F8 
     90  0;...  %T4
     90  324;... %T6
     90  288;... %O2
     62  57;... %F4
     45  0;...  %C4
     62  303;... %P4
     90   45;... %Fz
     0   0;... %Cz
     45   270;...
     90    108;... %FP1
     90    144;... %F7 
     90    180;... %T3
     90  216;... %T5
     90  252;... %O1
     62 123;... %F3
     45   180;... %C3
      62   237;... %P3
     ]; 
el=el/180*pi;