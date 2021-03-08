function output = lme_regression(model,data)

    % Run regression (linear mixed-effects models).
    %
    % USAGE: output = lme_regression(model,data)
    
    switch model

        case 'model1_exp'
            
            output = fitlme(data,'Response~Stimulus+AveStim+(1|Subject)+(Stimulus-1|Subject)+(AveStim-1|Subject)');
            disp(['Number of Observations: ',num2str(output.NumObservations)])
            
           
        case 'model2_exp'
            
            data.Condition = categorical(data.Condition);
            data.Confidence = zscore(data.Confidence); % to get standardized coefficient of confidence
            output = fitlme(data,['Response~Stimulus+AveStim+Confidence+Condition',...
                '+Stimulus:Confidence+AveStim:Confidence+Stimulus:Condition+AveStim:Condition',...
                '+(1|Subject)+(Stimulus-1|Subject)+(AveStim-1|Subject)+(Confidence-1|Subject)',...
                '+(Condition-1|Subject)+(Stimulus:Confidence-1|Subject)+(AveStim:Confidence-1|Subject)',...
                '+(Stimulus:Condition-1|Subject)+(AveStim:Condition-1|Subject)']);
            disp(['Number of Observations: ',num2str(output.NumObservations)])
            
            
        case 'model2_reanalysis'
            
            data.AveStim = zeros(length(data.Response),1);
            s = unique(data.Subject);
            for i = 1:length(s)
                stim = data.Stimulus(data.Subject==s(i));
                aveStim = zeros(length(stim),1);
                for j = 2:length(stim)
                    aveStim(j) = mean(stim(1:j-1));
                end
                data.AveStim(data.Subject==s(i)) = [NaN;aveStim(2:end)];
            end
            data = data(isnan(data.AveStim)==0,:);
            data.Confidence = zscore(data.Confidence);
            output = fitlme(data,['Response~Stimulus+AveStim+Confidence+Stimulus:Confidence+AveStim:Confidence',...
                '+(1|Subject)+(Stimulus-1|Subject)+(AveStim-1|Subject)',...
                '+(Confidence-1|Subject)+(Stimulus:Confidence-1|Subject)+(AveStim:Confidence-1|Subject)']);
            disp(['Number of Observations: ',num2str(output.NumObservations)])
            
            
        case 'model3_exp'
            
            data.lambda = (data.Response-data.AveStim)./(data.Stimulus-data.AveStim);
            data = data(data.lambda~=Inf & data.lambda~=-Inf & isnan(data.lambda)==0,:);
            output = fitlme(data,'lambda~Stimulus+(1|Subject)+(Stimulus-1|Subject)');
            
            
        case 'model3_reanalysis'
            
            data.AveStim = zeros(length(data.Response),1);
            s = unique(data.Subject);
            for i = 1:length(s)
                stim = data.Stimulus(data.Subject==s(i));
                aveStim = zeros(length(stim),1);
                for j = 2:length(stim)
                    aveStim(j) = mean(stim(1:j-1));
                end
                data.AveStim(data.Subject==s(i)) = [NaN;aveStim(2:end)];
            end
            data = data(isnan(data.AveStim)==0,:);
            data.lambda = (data.Response-data.AveStim)./(data.Stimulus-data.AveStim);
            data = data(data.lambda~=Inf & data.lambda~=-Inf & isnan(data.lambda)==0,:);
            output = fitlme(data,'lambda~Stimulus+(1|Subject)+(Stimulus-1|Subject)');

            
        case 'model4'
            
            subject = []; variability = []; confidence = [];
            u = unique(data.Subject);
            for i = 1:length(u)
                is = data.Subject == u(i);
                mag = unique(data.Stimulus(is));
                vari = zeros(length(mag),1);
                conf = zeros(length(mag),1);
                for j = 1:length(mag)
                    jm = data.Stimulus==mag(j);
                    f = length(data.Response(jm&is));
                    if f == 1
                        vari(j) = NaN;
                    else vari(j) = std(data.Response(jm&is));
                         conf(j) = mean(data.Confidence(jm&is));
                    end
                end
                conf = conf(isnan(vari)==0); confidence = [confidence;conf];
                vari = vari(isnan(vari)==0); variability = [variability;vari];
                sub = zeros(length(vari),1)+u(i); subject = [subject;sub];
            end
            tbl = table(subject,variability,confidence,'VariableNames',{'Subject','Variability','Confidence'});
            tbl.Confidence = zscore(tbl.Confidence);
            output = fitlme(tbl,'Variability~Confidence+(1|Subject)+(Confidence-1|Subject)');
            
            
        case 'model5_exp'
            
            subject = []; variability = []; condition = [];
            for z = 1:2 
                iz = data.Condition==z-1;
                u = unique(data.Subject(iz));
                for i = 1:length(u)
                    is = data.Subject == u(i);
                    mag = unique(data.Stimulus(is&iz));
                    vari = zeros(length(mag),1);
                    cond = zeros(length(mag),1);
                    for j = 1:length(mag)
                        jm = data.Stimulus==mag(j);
                        f = data.Response((jm&is&iz));
                        if f == 1
                            vari(j) = NaN;
                        else vari(j) = std(data.Response(jm&is&iz));
                             cond(j) = z-1;
                        end
                    end
                    cond = cond(isnan(vari)==0); condition = [condition;cond];
                    vari = vari(isnan(vari)==0); variability = [variability;vari];
                    sub = zeros(length(vari),1)+u(i); subject = [subject;sub];
                end
            end
            tbl = table(subject,variability,condition,'VariableNames',{'Subject','Variability','Condition'});
            tbl.Condition = categorical(tbl.Condition);
            output = fitlme(tbl,'Variability~Condition+(1|Subject)+(Condition-1|Subject)');
            
            
        case 'miscellaneous'

            data.Condition = categorical(data.Condition);
            data.Confidence = zscore(data.Confidence);
            output = fitlme(data,'Confidence~Stimulus+Condition+(1|Subject)+(Stimulus-1|Subject)+(Condition-1|Subject)');
            
            
    end
