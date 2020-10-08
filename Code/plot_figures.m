function plot_figures(fig,data)
    
    switch fig
       
        case 'fig2a'
            
            data.ave_stim_range = zeros(length(data.Stimulus),1);
            data.ave_stim_range(data.AveStim<=36) = 1;
            data.ave_stim_range(data.AveStim>36 & data.AveStim<=43) = 2;
            data.ave_stim_range(data.AveStim>43) = 3;

            for r = 1:3
                ir = data.ave_stim_range == r;
                min_stim = 15+7*(r-1); max_stim = 51+7*(r-1);
                N=6; n = (max_stim-min_stim)/N; % N = number of bins
                edges = min_stim:n:max_stim;
                
                m = []; ci = []; x = [];
                for t = 1:N
                    u = unique(data.Subject(ir));
                    dis = zeros(length(u),1);
                    for s = 1:length(u)
                        is = data.Subject==u(s);
                        Y = discretize(data.Stimulus(ir&is),edges);
                        res = data.Response(ir&is);
                        dis(s) = mean(res(Y==t));
                    end
                    dis = dis(isnan(dis)==0);
                    [m(t),~,int] = normfit(dis); ci(t) = diff(int)/2;
                    x = [x,min_stim+n*t-n/2];
                end
                colors = [0.3 0.6 0.5; 0.75 0.45 0.75; 1 0.6 0.6]; 
                errorbar(x,m,ci,'.-','LineWidth',3,'MarkerSize',15,'CapSize',0,'Color',colors(r,:));
                hold on
            end
            
            legend({'AveStim 30-36','AveStim 37-43','AveStim 44-50'},'Location','northwest','FontSize',20);
            legend('boxoff'); legend('AutoUpdate','off');
            plot(0:66,0:66,'--','color',[0.5,0.5,0.5]);
            set(gca,'XLim',[14.01,65.99],'FontSize',25);
            set(gca,'YLim',[14.01,65.99],'FontSize',25);
            xlabel('Stimulus','FontSize',25);
            ylabel('Estimate','FontSize',25);
            yticks([20 40 60]);
            axis square
            
            
        case 'fig2b'
            
            for i = 1:2
                if i == 1
                    ic = data.Confidence<=3;
                else ic = data.Confidence>=7;
                end
                max_stim = max(data.Stimulus); min_stim = min(data.Stimulus);
                N=6; n = (max_stim-min_stim)/N;
                edges = min_stim:n:max_stim;
                
                m = []; ci = []; x = [];
                for t = 1:N
                    u = unique(data.Subject(ic));
                    dis = zeros(length(u),1);
                    for s = 1:length(u)
                        is = data.Subject==u(s);
                        Y = discretize(data.Stimulus(ic&is),edges);
                        res = data.Response(ic&is);
                        dis(s) = mean(res(Y==t));
                    end
                    dis = dis(isnan(dis)==0);
                    [m(t),~,int] = normfit(dis); ci(t) = diff(int)/2;
                    x = [x,min_stim+n*t-n/2];
                end
                colormap linspecer
                errorbar(x,m,ci,'.-','LineWidth',3,'MarkerSize',15,'CapSize',0);
                hold on
            end

            legend({'Low Confidence','High Confidence'},'Location','northwest','FontSize',20);
            legend('boxoff'); legend('AutoUpdate','off');
            plot(0:66,0:66,'--','color',[0.5,0.5,0.5]);
            set(gca,'XLim',[14.01,65.99],'FontSize',25);
            set(gca,'YLim',[14.01,65.99],'FontSize',25);
            xlabel('Stimulus','FontSize',25);
            ylabel('Estimate','FontSize',25);
            yticks([20 40 60]);
            axis square

            
        case 'fig2c'
            
            for i = 1:2
                ic = data.Condition==i-1;
                max_stim = max(data.Stimulus); min_stim = min(data.Stimulus);
                N=6; n = (max_stim-min_stim)/N;
                edges = min_stim:n:max_stim;
                
                m = []; ci = []; x = [];
                for t = 1:N
                    u = unique(data.Subject(ic));
                    dis = zeros(length(u),1);
                    for s = 1:length(u)
                        is = data.Subject==u(s);
                        Y = discretize(data.Stimulus(ic&is),edges);
                        conf = data.Confidence(ic&is);
                        dis(s) = mean(conf(Y==t));
                    end
                    dis = dis(isnan(dis)==0);
                    [m(t),~,int] = normfit(dis); ci(t) = diff(int)/2;
                    x = [x,min_stim+n*t-n/2];
                end
                colors = [0.5 0.5 0.5; 0.96 0.6 0.2];
                errorbar(x,m,ci,'.-','LineWidth',3,'MarkerSize',15,'CapSize',0,'Color',colors(i,:));
                hold on
            end
            
            legend({'100 ms','2000 ms'},'Location','northwest','FontSize',20);
            legend('boxoff');
            set(gca,'XLim',[14.01,65.99],'FontSize',25);
            set(gca,'YLim',[0,10],'FontSize',25);
            xlabel('Stimulus','FontSize',25);
            ylabel('Confidence','FontSize',25);
            axis square
     
            
        case 'fig2d'

            for i = 1:2
                ic = data.Condition==i-1;
                max_stim = max(data.Stimulus); min_stim = min(data.Stimulus);
                N=6; n = (max_stim-min_stim)/N;
                edges = min_stim:n:max_stim;
                
                m = []; ci = []; x = [];
                for t = 1:N
                    u = unique(data.Subject(ic));
                    dis = zeros(length(u),1);
                    for s = 1:length(u)
                        is = data.Subject==u(s);
                        Y = discretize(data.Stimulus(ic&is),edges);
                        res = data.Response(ic&is);
                        dis(s) = mean(res(Y==t));
                    end
                    dis = dis(isnan(dis)==0);
                    [m(t),~,int] = normfit(dis);
                    ci(t) = diff(int)/2;
                    x = [x,min_stim+n*t-n/2];
                end
                colors = [0.5 0.5 0.5; 0.96 0.6 0.2];
                errorbar(x,m,ci,'.-','LineWidth',3,'MarkerSize',15,'CapSize',0,'Color',colors(i,:));
                hold on
            end
            
            legend({'100 ms','2000 ms'},'Location','northwest','FontSize',20);
            legend('boxoff');
            legend('AutoUpdate','off')
            plot(0:66,0:66,'--','color',[0.5,0.5,0.5]);
            set(gca,'XLim',[14.01,65.99],'FontSize',25);
            set(gca,'YLim',[14.01,65.99],'FontSize',25);
            xlabel('Stimulus','FontSize',25);
            ylabel('Estimate','FontSize',25);
            yticks([20 40 60]);
            axis square
            
            
        case 'fig2e'
            
            % get table from lme_regression.m model 4
            subject = []; variability = []; confidence = [];
            u = unique(data.Subject);
            for i = 1:length(u)
                is = data.Subject == u(i);
                mag = unique(data.Stimulus(is));
                vari = zeros(length(mag),1);
                conf = zeros(length(mag),1);
                for j = 1:length(mag)
                    jm = data.Stimulus==mag(j);
                    f = find(jm&is);
                    if length(f) == 1
                        vari(j) = NaN;
                    else vari(j) = std(data.Response(jm&is));
                         conf(j) = mean(data.Confidence(jm&is));
                    end
                end
                conf = conf(isnan(vari)==0); confidence = [confidence;conf];
                vari = vari(isnan(vari)==0); variability = [variability;vari];
                sub = zeros(length(vari),1)+u(i); subject = [subject;sub];
            end 
            tbl = table(subject,confidence,variability,...
            'VariableNames',{'Subject','Confidence','Variability'});
            
            max_conf = max(tbl.Confidence); min_conf = min(tbl.Confidence);
            N = 10; n = (max_conf-min_conf)/N;
            edges = min_conf:n:max_conf;
            
            x = [];
            Y = discretize(tbl.Confidence,edges);
            for t = 1:N
                u = unique(tbl.Subject);
                dis = zeros(length(u),1);
                for i = 1:length(u)
                    is = tbl.Subject==u(i);
                    f = find(tbl.Variability(is&Y==t));
                    if length(f) == 1
                        dis(i) = NaN;
                    else dis(i) = mean(tbl.Variability(is&Y==t));
                    end
                end
                dis = dis(isnan(dis)==0);
                [m(t),~,int] = normfit(dis); ci(t) = diff(int)/2;
                x = [x,min_conf+n*t-n/2];
            end
            
            errorbar(x,m,ci,'.-','LineWidth',3,'MarkerSize',30,'CapSize',0,'Color','k');
            set(gca,'XLim',[-0.5,10.5],'FontSize',25);
            set(gca,'YLim',[3,7],'FontSize',25);
            xlabel('Confidence','FontSize',25);
            ylabel('Response Variability (SD)','FontSize',25);
            xticks([0 2 4 6 8 10]);
            yticks([3 4 5 6 7]);
            axis square
            
            
        case 'fig2f'
            
            m = []; ci = [];
            for i = 1:2
                ic = data.Condition==i-1;
                dis = zeros(max(data.Subject),1);
                u = unique(data.Subject(ic));
                for s = 1:length(u)
                    is = data.Subject==u(s);
                    stim = unique(data.Stimulus(ic&is));
                    variability = zeros(length(stim),1);
                    for z = 1:length(stim)
                        istim = data.Stimulus==stim(z);
                        f = find(ic&is&istim);
                        if length(f) == 1
                            variability(z) = NaN;
                        else variability(z) = std(data.Response(ic&is&istim));
                        end
                    end
                    dis(s) = mean(variability(isnan(variability)==0));
                end
                [m(i),~,int] = normfit(dis); ci(i) = diff(int)/2;
                colors = [0.5 0.5 0.5; 0.96 0.6 0.2];
                errorbar(1+(i-1)*2,m(i),ci(i),'.-','LineWidth',3,'MarkerSize',30,'CapSize',0,'Color',colors(i,:));
                hold on
            end      
            
            legend({'100 ms','2000 ms'},'Location','northwest','FontSize',20);
            legend('boxoff'); legend('AutoUpdate','off');
            plot([1.07,2.93],m,'--','color',[0.5,0.5,0.5]);
            set(gca,'XLim',[0.5,3.5],'FontSize',25);
            set(gca,'YLim',[3,7],'FontSize',25);
            xlabel('Stimulus Duration','FontSize',25);
            ylabel('Response Variability (SD)','FontSize',25);
            xticks([1 3]); xticklabels({' ',' '}); yticks([3 4 5 6 7]);
            axis square
            
            
    end
    