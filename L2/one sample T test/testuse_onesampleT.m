clear all
 %% Initialise inputs, pathnames 
rawdir = '/Volumes/LASA/Aphasia_project/data/raw_data/';
subjects = build_dataset((rawdir));
outdir = '/Volumes/LASA/Aphasia_project/data/stats/one sample T test/';
% Load group file
 group_path='/Volumes/LASA/Aphasia_project/code/L2/one sample T test/';
 cd(group_path); [num,txt,raw] =xlsread('LASA_group_BIDS.xlsx',1);
 % Add group to dataset
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
%Remove sub-18 (missing ses-002,3, missing Uulaa ses-001) & sub-17&sub-19 (missing ses-003) 
subjects_s1(ismember({subjects_s1.name}, {'sub-18'})) = [];
subjects_s2(ismember({subjects_s2.name}, {'sub-18'})) = [];
subjects_s3(ismember({subjects_s3.name}, {'sub-17','sub-18', 'sub-19'})) = [];

% Do
%L2_PairedT_SingaVSRest_Trained(subjects_s3,outdir)