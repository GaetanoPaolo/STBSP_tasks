function [filteredsignal]=datacreateplot(original,pagenr,scale,window,notchflag,lpcutoff,hpcutoff,fs,figurehandle,filename)

%window selection
if pagenr==0
    datawindow=original;
else
    samples=fs*window;
    datawindow=original(:,(pagenr-1)*samples+1:pagenr*samples);
end
%notch filtering
if notchflag
    datawindow=notchfilter(datawindow,fs);
end

%frequency filtering
filteredsignal=freqfilter(datawindow,lpcutoff,hpcutoff,fs);

%plotting
if isempty(figurehandle)
else
    figure(figurehandle)
    fullpage=(pagenr==floor(pagenr));
    eegplot_orig(filteredsignal,meas21osg,scale,'k',1-fullpage);
end
    
