clear all
 %% Initialise inputs, pathnames 
outdir = '/Volumes/LASA/Aphasia_project/data/stats/two samples T test/';
LASA_rawdir = '/Volumes/LASA/Aphasia_project/data/raw_data/';
BRAVE_rawdir = '/Volumes/LASA/Aphasia_project/data/raw_data_BRAVE/';
cov_dir='/Volumes/LASA/Aphasia_project/code/fMRI/L2/two samples T test/';
% LASA patients
LASA_subjects = build_dataset((LASA_rawdir));
idx_motion_outliers=find(ismember({LASA_subjects.name},{'sub-03','sub-14','sub-19','sub-27','sub-28'}));
LASA_subjects(idx_motion_outliers)=[];
LASA_group=num2cell(ones(numel(LASA_subjects),1));
[LASA_subjects.group]=LASA_group{:}; 
% BRAVE LASA-matched participants
BRAVE_subjects = build_dataset((BRAVE_rawdir));
BRAVE_subjects(startsWith({BRAVE_subjects.name}, {'._'})) = [];% remove dot underscore files
BRAVE_group=num2cell(repmat(2,numel(BRAVE_subjects),1));
[BRAVE_subjects.group]=BRAVE_group{:}; 

% Load cov file
cd(cov_dir); [num,txt,raw] =xlsread('LASA_group_BIDS_wo3_14_19_27_28.xlsx',1, 'A1:E24');
% Add cov to LASA dataset
age=num2cell(num(:,3)); TIV=num2cell(num(:,4));
[LASA_subjects.age]=age{:}; [LASA_subjects.TIV]=TIV{:};
clear num txt raw
% Add cov to BRAVE dataset
[num,txt,raw] =xlsread('BRAVE_BIDS.xlsx',1,'A1:D31');
age=num2cell(num(:,1)); TIV=num2cell(num(:,2));
[BRAVE_subjects.age] =age{:}; [BRAVE_subjects.TIV] =TIV{:}; 

 %% Build datasets for LASA patients
s1=1;s2=1;s3=1;
for sbji = 1:size(LASA_subjects, 1)
    sub_path=fullfile(LASA_subjects(sbji).folder, LASA_subjects(sbji).name);
    ses=dirflt(sub_path);
    if numel(ses)==3
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; 
            s1=s1+1;
        end
        if ismember({ses(2).name}, {'ses-002'})
            Idx_s2(s2,1)=sbji; 
            s2=s2+1;
        end
        if ismember({ses(3).name}, {'ses-003'})
            Idx_s3(s3,1)=sbji; 
            s3=s3+1;
        end
    end
    if numel(ses)==2
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; 
            s1=s1+1;
        end
        if ismember({ses(2).name}, {'ses-002'})
            Idx_s2(s2,1)=sbji;
            s2=s2+1;
        end
        if ismember({ses(2).name}, {'ses-003'})
            Idx_s3(s3,1)=sbji; 
            s3=s3+1;
        end
    end
    if numel(ses)==1
        if ismember({ses(1).name}, {'ses-001'})
            Idx_s1(s1,1)=sbji; 
            s1=s1+1;
        end
    end
end  
LASA_subjects_s1=LASA_subjects(Idx_s1); LASA_subjects_s2=LASA_subjects(Idx_s2); LASA_subjects_s3=LASA_subjects(Idx_s3); 
%Remove sub-18 (missing ses-001-3) & sub-17&sub-19 (missing ses-003) 
LASA_subjects_s3(ismember({LASA_subjects_s3.name}, {'sub-17','sub-18','sub-19'})) = [];
LASA_subjects_s2(ismember({LASA_subjects_s2.name}, {'sub-18'})) = [];
LASA_subjects_s1(ismember({LASA_subjects_s1.name}, {'sub-18'})) = [];

% Do second-level for BRAVE participants and LASA patients session 1

subjects_baseline=vertcat(LASA_subjects_s1, BRAVE_subjects);


L2_T2_LisVSSinga_age_TIV(subjects_baseline,outdir)
L2_T2_SingaVSRest_age_TIV(subjects_baseline,outdir)
L2_T2_SingaVSListen_age_TIV(subjects_baseline,outdir)
L2_T2_SingaVSSingm_age_TIV(subjects_baseline,outdir)
L2_T2_SingmVSSinga_age_TIV(subjects_baseline,outdir)




