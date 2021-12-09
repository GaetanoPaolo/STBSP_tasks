function maximal_lyap_exp(x)
% Usage: maximal_lyap_exp(x);
% x - data structure with required fields:
%     .data - time series array (attractor). columns - observables, rows -
%     observations
%     .time - vector of observation times
% Computed maximal Lyapunov exponent printed in GUI
%
% References:
% Eckmann J.-P., Kamphorst S.O., Ruelle D., Gilberto D. Lyapunov
% exponents from a time series - Phys. Rev. 1986. V. A34. P. 4971-4979.
%
% Wolf A., Swift J. B., Swinney H.L., Vastano J.A. Determining Lyapunov
% exponents from a time series - Physica. 1985. V. D16. P. 285-317.

% last modified 9.02.05

global mleContinue Faling

Ergens_gefaald=0;
Faling=0;  %ANDRIES

if isa(x,'struct') %if x is van de vorm struct dan is 1
	MAX=max(x.data);
	MIN=min(x.data);
	R=max(MAX-MIN);
	T0=(x.time(end)-x.time(1))/30;
    
    %ANDRIES PARAMETERS
    Emin=20;  % As small as possible by more cosistent results obtained at 20
    Emax=50;  % Basic
    T0=250;   % As big as possible but still making sure there will be convergence
    
    
    
    if var(diff(x.time))>1e-7
        warning('Time samples should be equidistant');
    end
	max_lyap_exp.x=x.data;
	max_lyap_exp.t=x.time;
	max_lyap_exp.fig=figure('numbertitle','off','name','Maximal Lyapunov exponent');
	uicontrol('parent',gcf,'units','normalized','position',[0.045 0.91 0.60 0.04],...
        'style','text','String',sprintf('Maximal distance along dimensions: %f',R),...
        'horizontalal','left','fontsize',9);
	uicontrol('parent',gcf,'units','normalized','position',[0.045 0.86 0.30 0.04],...
        'style','text','String','E_min: ',...
        'horizontalal','left','fontsize',9);
	uicontrol('parent',gcf,'units','normalized','position',[0.045 0.81 0.30 0.04],...
        'style','text','String','E_max: ',...
        'horizontalal','left','fontsize',9);
	uicontrol('parent',gcf,'units','normalized','position',[0.045 0.76 0.250 0.04],...
        'style','text','String','T_min: ',...
         'horizontalal','left','fontsize',9);

     % 	max_lyap_exp.t0=uicontrol('parent',gcf,'units','normalized','position',[0.2 0.76 0.12 0.04],...
%         'style','edit','String',sprintf('%f',T0),'horizontalal','left','fontsize',9,'backgr',[1 1 1]);
% 	max_lyap_exp.E_max=uicontrol('parent',gcf,'units','normalized','position',[0.2 0.81 0.12 0.04],...
%         'style','edit','String',sprintf('%f',R/10),'horizontalal','left','fontsize',9,'backgr',[1 1 1]);
% 	max_lyap_exp.E_0=uicontrol('parent',gcf,'units','normalized','position',[0.2 0.86 0.12 0.04],...
%         'style','edit','String',sprintf('%f',R/200),'horizontalal','left','fontsize',9,'backgr',[1 1 1]);
	max_lyap_exp.t0=uicontrol('parent',gcf,'units','normalized','position',[0.2 0.76 0.12 0.04],...
        'style','edit','String',sprintf('%f',T0),'horizontalal','left','fontsize',9,'backgr',[1 1 1]);
	max_lyap_exp.E_max=uicontrol('parent',gcf,'units','normalized','position',[0.2 0.81 0.12 0.04],...
        'style','edit','String',sprintf('%f',Emax),'horizontalal','left','fontsize',9,'backgr',[1 1 1]);
	max_lyap_exp.E_0=uicontrol('parent',gcf,'units','normalized','position',[0.2 0.86 0.12 0.04],...
        'style','edit','String',sprintf('%f',Emin),'horizontalal','left','fontsize',9,'backgr',[1 1 1]);
	
    
% 	max_lyap_exp.compute_button=uicontrol('parent',gcf,'units','normalized','position',[0.1 0.67 0.20 0.06],...
%         'style','push','String','Compute','horizontalal','center','fontsize',10,'callback','maximal_lyap_exp(''compute'')');
% 	max_lyap_exp.stop_button=uicontrol('parent',gcf,'units','normalized','position',[0.1 0.6 0.20 0.06],'visible','off',...
%         'style','push','String','Stop','horizontalal','center','fontsize',10,'callback','global mleContinue; mleContinue=0;');
	
	max_lyap_exp.axes=axes('parent',gcf,'units','normalized','position',[0.4 0.15 0.53 0.53],...
        'fontsize',8,'visible','off');
	
	max_lyap_exp.text_exp=uicontrol('parent',gcf,'units','normalized','position',[0.5 0.86 0.45 0.05],...
        'style','text','String','','horizontalal','left','fontsize',10,'visible','off');
	set(max_lyap_exp.fig,'userdata',max_lyap_exp);

%else %ANDRIES
    Results=[];
    
    for q=1:5
	
        max_lyap_exp=get(gcf,'userdata');

        X=max_lyap_exp.x;
        L=length(X(1,:));

        T=max_lyap_exp.t;
        N=length(T);
        MAX=max(X);
        MIN=min(X);
        R=max(MAX-MIN);

        e_max=str2num(get(max_lyap_exp.E_max,'string'));
        e_0=str2num(get(max_lyap_exp.E_0,'string'));
        T0=str2num(get(max_lyap_exp.t0,'string'));
%        set(max_lyap_exp.stop_button,'visible','on','enable','on');
        set(max_lyap_exp.axes,'visible','on','nextplot','add');
        xlabel('samples'); ylabel('L_{+}');
%        set(max_lyap_exp.compute_button,'enable','off');
        UpSum=0; DownSum=0; counter=1; Failed=0; firstTime=1; V=X; mleContinue=1;

        while (counter<150)&&(Failed<20)&& mleContinue
            if firstTime
                for i=1:10
                    [x,x_ix,y,y_ix,ok]=get_start_points(X,T,T0,N,e_0);
                    if ok
                        break
                    end
                end
                if i==10
                    disp('Bad parameters');
%                    set(max_lyap_exp.stop_button,'visible','off','enable','off');
                    axes(max_lyap_exp.axes); cla;
                    set(max_lyap_exp.axes,'visible','off','nextplot','add');
%                    set(max_lyap_exp.compute_button,'enable','on');
                    return
                end
            else
                x=x2; x_ix=x2_ix;
                V=X;
                for i=1:L
                    V(:,i)=V(:,i)-x(i);
                end
                ScalarProd=V*(x');
                curr=1;
                for i=1:N
                    if (abs(T(i)-T(x_ix))<T0)||(sum(abs(X(i,:)-x))>e_0)
                        ScalarProd(i)=-inf;
                    end
                    if ScalarProd(i)>ScalarProd(curr)
                        curr=i;
                    end
                end

                if max(ScalarProd)==-inf
                    %disp('Warning,Warning: Bad parameters. e_0 too small or T0 too big');
                    Ergens_gefaald=1;  %ANDRIES
                    Faling=1;
%                   set(max_lyap_exp.stop_button,'visible','off','enable','off');
%                   set(max_lyap_exp.compute_button,'enable','on');
                    return
                end
                y_ix=curr;
                y=X(y_ix,:);
            end
            x2=x; y2=y; x2_ix=x_ix; y2_ix=y_ix;

            while (sum(abs(x2-y2))<e_max)&&(max([x2_ix y2_ix])<N)
                x2_ix=x2_ix+1; y2_ix=y2_ix+1;
                x2=X(x2_ix,:); y2=X(y2_ix,:);
            end
            if max([x2_ix y2_ix])==N
                Failed=Failed+1;
                firstTime=1;
                continue 
            end
            UpSum=UpSum+log(sum(abs(x2-y2))/sum(abs(x-y)));
            DownSum=DownSum+T(x2_ix)-T(x_ix);
            bestDir=y2-x2;
            axes(max_lyap_exp.axes);
            set(max_lyap_exp.text_exp,'string',sprintf('Maximal Lyapunov Exponent: %f',UpSum/DownSum),...
                'visible','on');
            Max_Lyapunov_Exp=UpSum/DownSum;
            % plot(counter,UpSum/DownSum,'.','MarkerFaceColor','b','markersize',6),hold on, grid on 
            counter=counter+1;
            drawnow;
            firstTime=0;
        end
%       set(max_lyap_exp.compute_button,'enable','on');
%       set(max_lyap_exp.stop_button,'visible','on','enable','off');
        
        Results=[Results Max_Lyapunov_Exp];
    end
end

%% ANDRIES
% if Ergens_gefaald==1
%     disp('Parameters niet goed')
% else
%     disp('Parameters altijd in orde')
% end
global Lyapunov_Estimate

close all

Lyapunov_Estimate=mean(Results);



