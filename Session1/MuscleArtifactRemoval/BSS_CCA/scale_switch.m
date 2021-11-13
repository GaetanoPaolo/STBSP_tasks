function new_scale=scale_switch(old_scale,method);
%method ==1 => higher scale
%method==-1=> lower scale
scales=[20 30 50 70 100 150 200 300 500 700 1000 1500 2000];
if method==1
    if old_scale==2000;
        I=length(scales);
    else
    I=find(scales==old_scale)+1;
end
else
    if old_scale==20
        I=1;
    else
        I=find(scales==old_scale)-1;
    end
end
new_scale=scales(I);