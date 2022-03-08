clear all
%% Initialise inputs, pathnames 
rawdir = '/Volumes/LASA/Aphasia_project/data/raw_data/';
subjects = build_dataset(rawdir);
outdir = '/Volumes/LASA/Aphasia_project/data/raw_data/';
codedir='/Volumes/LASA/Aphasia_project/code/L1/'; addpath(codedir)
utilsdir='/Volumes/LASA/Aphasia_project/code/utils'; addpath(utilsdir)


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
%sub-18 ses-001 & ses-003 No Uulaa (didn´t sing)
%sub-17 ses-003 No Tydyy (wrong recordings)
%sub-19 ses-003 No Tydyy (wrong recordings)
cd(codedir)
save('subjects_s1.mat', 'subjects_s1')
save('subjects_s2.mat', 'subjects_s2')
save('subjects_s3.mat', 'subjects_s3')
%Call SPM function for model estimation & specification
SPM_Model_spec_est(subjects_s2_diff(10))

