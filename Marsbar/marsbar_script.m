
%This takes your pre-estimated SPM design for each subject, and for
%multiple ROIs (which have to be pre-imported into MarsBar) will run a 1st
%level

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
        %the next line is the file with the 1st level SPM designs
        spm_name = strcat('C:\Users\mchad\BE_Analysis\First_Level\categorical_0s0s_TD\',subjects{s},'\SPM.mat');
        %this is the file with the ROI files - this needs to be in the
        %correct format for MarsBar (i.e. they need to be imported in using
        %the gui)
        roi_file = strcat('C:\Users\mchad\BE_Analysis\June_Analysis\MarsBar\',regions{r},'_roi.mat');
        
        % Make marsbar design object
        D  = mardo(spm_name);
        % Make marsbar ROI object
        R  = maroi(roi_file);
        % Fetch data into marsbar data object
        Y  = get_marsy(R, D, 'mean');
        % Get contrasts from original design
        xCon = get_contrasts(D);
        % Estimate design on ROI data
        E = estimate(D, Y);
        % Put contrasts from original design back into design object
        E = set_contrasts(E, xCon);
        % get design betas
        b = betas(E);
        % get stats and stuff for the first contrasts into statistics
        % structure. If you want to run this for a specific contrast, then
        % find out which number contrast this is within your SPM design,
        % and change the "1" to that number contrast in the following line:
        marsS = compute_contrasts(E, 1)
        
        %alternatively, if you want to run MarsBar for all your contrasts
        %from the SPM design, then I think the following line should do
        %this, but I haven't tested it yet:
        %marsS = compute_contrasts(E, 1:length(xCon)); 
        
        cons(s,r)=marsS.con;
        
        %Again, if you are running this for multiple contrasts, I think something like this
        %should work instead:
        %cons{r}(s,:)=mars.con(:);
        
        
        if keepdata == 1
            savename =  strcat('C:\Users\mchad\BE_Analysis\June_Analysis\MarsBar\Categorical_FixReg_Smoothed\',subjects{s},'_',regions{r},'.mat');
            save(savename,'D','R','Y','xCon','E','b','marsS');
        end
        
    end
end



%%%%%%%this will now have estimated the ROI MarsBar design for all subs and
%%%%%%%all regions. The next section takes the contrast values for each sub
%%%%%%%and region, and peforms a one-way ttest against zero, which gives
%%%%%%%your group level result. Note that this is currently only set up to
%%%%%%%run with a single contrast, but could easily be adapted to run
%%%%%%%multiple.


'running stats'
for r = 1:8
    clear h p ci stats
    
    [h,p,ci,stats]=ttest(cons(:,r),0,0.05,'right');
    fixation{fix}
    smooth{sm}
    res(r)=p;
end
res

if keepdata == 1
    savename =  'C:\Users\mchad\BE_Analysis\June_Analysis\MarsBar\Categorical_FixReg_Smoothed\Group_Cons.mat';
    save(savename,'cons','res');
end