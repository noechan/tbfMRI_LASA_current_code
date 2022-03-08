clear all
 %% Initialise inputs, pathnames 
rawdir = '/Volumes/LASA/Aphasia_project/data/raw_data/';
subjects = build_dataset((rawdir));
outdir = '/Volumes/LASA/Aphasia_project/data/stats/flexible factorial/';
% Load group file
 group_path='/Volumes/LASA/Aphasia_project/code/L2/paired T test/';
 cd(group_path); [num,txt,raw] =xlsread('LASA_group_BIDS.xlsx',1);
  % Add group and covariates to dataset
 group=num2cell(num(:,1)); age=num2cell(num(:,3));
 [subjects.group] =group{:}; [subjects.age] =age{:}; 
%% Build datasets for multiple sessions
s1=1;s2=1;s3=1;
for sbji = 1:size(subjects, 1)
    sub_path=fullfile(subjects(sbji).folder, subjects(sbji).name);
    ses=dirflt(sub_path);
    if numel(ses)==3
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; %#ok<SAGROW>
            s1=s1+1;
        end
        if ismember({ses(2).name}, {'ses-002'})
            Idx_s2(s2,1)=sbji; %#ok<SAGROW>
            s2=s2+1;
        end
        if ismember({ses(3).name}, {'ses-003'})
            Idx_s3(s3,1)=sbji; %#ok<SAGROW>
            s3=s3+1;
        end
    end
    if numel(ses)==2
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; %#ok<SAGROW>
            s1=s1+1;
        end
        if ismember({ses(2).name}, {'ses-002'})
            Idx_s2(s2,1)=sbji; %#ok<SAGROW>
            s2=s2+1;
        end
        if ismember({ses(2).name}, {'ses-003'})
            Idx_s3(s3,1)=sbji; %#ok<SAGROW>
            s3=s3+1;
        end
    end
    if numel(ses)==1
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; %#ok<SAGROW>
            s1=s1+1;
        end
    end
end
   
subjects_s1=subjects(Idx_s1); subjects_s2=subjects(Idx_s2); subjects_s3=subjects(Idx_s3); 
%Remove sub-18 (missing ses-002,3) & sub-17&sub-19 (missing ses-003) 
subjects_s3(ismember({subjects_s3.name}, {'sub-17','sub-18', 'sub-19'})) = [];
%cd(group_path)
%save('subjects_s3.mat','subjects_s3')

% Do second-level

L2_Flex_LisVSRest_TU_2x3_Age(subjects_s3,outdir)
L2_Flex_LisVSSinga_TU_2x3_Age(subjects_s3,outdir)
L2_Flex_LisVSSingm_TU_2x3_Age(subjects_s3,outdir)

L2_Flex_SingaVSRest_TU_2x3_Age(subjects_s3,outdir)
L2_Flex_SingaVSListen_TU_2x3_Age(subjects_s3,outdir)
L2_Flex_SingaVSSingm_TU_2x3_Age(subjects_s3,outdir)

L2_Flex_SingmVSRest_TU_2x3_Age(subjects_s3,outdir)
L2_Flex_SingmVSListen_TU_2x3_Age(subjects_s3,outdir)
L2_Flex_SingmVSSinga_TU_2x3_Age(subjects_s3,outdir)






% %Remove sub-25 (missing contrast in ses-002) & sub-27 (missing contrast in
% %ses-001)& sub-28 (missing contrast in ses-001 & ses-002)& sub-30 (missing
% %contrast in 3 sessions)
% subjects_s3(ismember({subjects_s3.name}, {'sub-25','sub-27','sub-28','sub-30'})) = [];
% L2_Flex_LisVSSingm_TU_2x3_Age(subjects_s3,outdir)
% clear subjects_s3; cd(group_path); load subjects_s3
% %Remove sub-28 (missing contrast in ses-00X) & sub-30
% subjects_s3(ismember({subjects_s3.name}, {'sub-28','sub-30'})) = [];
% L2_Flex_SingaVSSingm_TU_2x3_Age(subjects_s3,outdir)
% clear subjects_s3; cd(group_path); load subjects_s3
% %Remove sub-28 (missing contrast in ses-00X) & sub-30
% subjects_s3(ismember({subjects_s3.name}, {'sub-28','sub-30'})) = [];
% L2_Flex_SingmVSSinga_TU_2x3_Age(subjects_s3,outdir)
% clear subjects_s3; cd(group_path); load subjects_s3
% %Remove sub-27 (missing contrast in ses-00X) & sub-28 & sub-30
% subjects_s3(ismember({subjects_s3.name}, {'sub-27','sub-28','sub-30'})) = [];
% L2_Flex_SingaVSListen_TU_2x3_Age(subjects_s3,outdir)
% clear subjects_s3; cd(group_path); load subjects_s3
% %Remove sub-25 (missing contrast in ses-00X) & sub-27 & sub-28 & sub-30
% subjects_s3(ismember({subjects_s3.name}, {'sub-25','sub-27','sub-28','sub-30'})) = [];
% L2_Flex_SingmVSListen_TU_2x3_Age(subjects_s3,outdir)
% clear subjects_s3; cd(group_path); load subjects_s3
% %Remove sub-27 (missing contrast in ses-001) & sub-28 (missing contrast in ses-001 & ses-002) & sub-30 (missing contrast in ses-002 & ses-003)
% subjects_s3(ismember({subjects_s3.name}, {'sub-27','sub-28','sub-30'})) = [];
% L2_Flex_LisVSSinga_TU_2x3(subjects_s3,outdir)
% clear subjects_s3; cd(group_path); load subjects_s3
% %Remove sub-27 (missing contrast in ses-001), sub-28 (missing contrast in ses-002)
% subjects_s3(ismember({subjects_s3.name}, {'sub-27','sub-28'})) = [];
% L2_Flex_SingaVSRest_TU_2x3_Age(subjects_s3,outdir)
% clear subjects_s3; cd(group_path); load subjects_s3
% %Remove sub-27 (missing contrast in ses-001)& sub-28 (missing contrast in
% %ses-002 & ses-003) & sub-30 (missing contrast in ses-001)
% subjects_s3(ismember({subjects_s3.name}, {'sub-27','sub-28','sub-30'})) = [];
% L2_Flex_SingmVSRest_TU_2x3_Age(subjects_s3,outdir)
% %Remove sub-27 (missing contrast in ses-001 & ses-003), sub-28 (missing contrast in 3 sessions) & sub-30 (missing contrast in ses-001 & ses-002)
% subjects_s3(ismember({subjects_s3.name}, {'sub-27','sub-28','sub-30'})) = [];
% L2_Flex_LisVSRest_TU_2x3_Age(subjects_s3,outdir)
% 
% 
