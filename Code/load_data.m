function data = load_data(dataset)
    
    % Load data sets.
    %
    % USAGE: data = load_data(dataset)
    %
    % INPUTS:
    %   dataset - 'AB17','DB18','DB19','DB20','RZ14','SP17', or 'Experiment'
    
    switch dataset
        
        case 'AB17'
            
            for i = 1:3
                tbl = readtable(['../Data/data_Akdogan_2017_Exp',num2str(i),'.csv']);
                if i > 1
                    tbl.Subject = tbl.Subj_idx + max(data.Subject);
                    data = [data; tbl];
                else
                    tbl.Subject = tbl.Subj_idx;
                    data = tbl;
                end
            end
            
            
        case 'DB18'
            
            for i = 1:2
                tbl = readtable(['../Data/data_Duyan_2018_Exp',num2str(i),'.csv']);
                if i > 1
                    tbl.Subject = tbl.Subj_idx + max(data.Subject);
                    data = [data; tbl];
                else
                    tbl.Subject = tbl.Subj_idx;
                    data = tbl;
                end
            end
            data(data.Response==999 | isnan(data.Response)==1,:) = [];
            
            
        case 'DB19'
            
            tbl = readtable('../Data/data_Duyan_2019.csv');
            tbl.Subject = tbl.Subj_idx;
            data = tbl;
            data(data.Response==999 | data.Response==9999,:) = [];

            
        case 'DB20'
            
            for i = 1:2
                tbl = readtable(['../Data/data_Duyan_unpub_Exp',num2str(i),'.csv']);
                try tbl.MADFilter = []; end
                try tbl.madFilter = []; end
                if i > 1
                    tbl.Subject = tbl.Subj_idx + max(data.Subject);
                    data = [data; tbl];
                else
                    tbl.Subject = tbl.Subj_idx;
                    data = tbl;
                end
            end
            data(data.trialFilter==0 | data.Confidence==0,:) = []; 
            % trialFilter = 0 indicates that the participant didn't report estimate.
            % Confidence=0 indicates that the participant didn't report confidence.
            
            
        case 'RZ14'
            
            tbl = readtable(['../Data/data_Rausch_2014.csv']);
            tbl.Subject = tbl.Subj_idx;
            tbl.Scale = [];
            data = tbl;
            data(data.Training==1,:) = [];

            
        case 'SP17'
            
            for i = 1:2
                tbl = readtable(['../Data/data_Samaha_2017_exp',num2str(i),'.csv']);
                try tbl.Task = []; end
                try tbl.Block = []; end
                try tbl.Delay = []; end
                if i > 1
                    tbl.Subject = tbl.Subj_idx + max(data.Subject);
                    data = [data; tbl];
                else
                    tbl.Subject = tbl.Subj_idx;
                    data = tbl;
                end
            end
           
            
        case 'Experiment'
            
            load('../Data/Experiment.mat');
                

    end