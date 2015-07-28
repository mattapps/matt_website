
%This takes the output of the initial Marsbar analysis, and estimates
%percent signal change for each regressor of interest.

clear;
%the labels for each sub
subjects = {'S1','S2','S3','S4','S6','S7','S8','S9','S10','S11','S12','S13','S14','S15','S16','S17','S18','S19','S20','S21','S22','S23','S25','S26','S27','S28','S29','S30','S32','S33'};
%the labels for each ROI
regions = {'LHC' 'RHC' 'LEC' 'REC' 'LPHG' 'RPHG' 'LRSC' 'RRSC' 'Pos_LHC' 'Ant_LHC' 'Pos_RHC' 'Ant_RHC'};
keepdata = 1;  %if 1, the design and results for each subject and region, and a summary at the group level will be saved. If zero, nothing is saved.

for r = 1:8 %for loop for regions
    for s = 1:30 %for loop for subjects
        regions{r}
        subjects{s}
        
        %this file needs to be the output of the first Marsbar script
        filename =  strcat('C:\Users\mchad\BE_Analysis\June_Analysis\MarsBar\Categorical_FixReg_smoothed\',subjects{s},'\',regions{r},'.mat');
        load(filename);
        
        % Get definitions of all events in model
        [e_specs, e_names] = event_specs(E);
        n_events = size(e_specs, 2);
        dur = 0;
        
        % Return percent signal esimate for the first four events (i.e.
        % regressors) in design. If you want to extract an estimate for all
        % the regressors, this should be e_s = 1:n_events
        
        for e_s = 1:4
            pct{r}(s,e_s) = event_signal(E, e_specs(:,e_s), dur);
        end
        
        
    end
end




'running stats'
for r = 1:8
    clear h p ci stats

    %This will perform a 2-way paired ttest comparing (in this case) the
    %signal change for regressors 1 and 3 at the group level for each ROI.
    
    [h,p,ci,stats]=ttest( pct{r}(:,1),pct{r}(:,3));
   
    res(r)=p;
end
res

if keepdata == 1
    savename =  'C:\Users\mchad\BE_Analysis\June_Analysis\MarsBar\Categorical_FixReg_Smoothed\signalchange.mat';
    save(savename,'pct','res');
end