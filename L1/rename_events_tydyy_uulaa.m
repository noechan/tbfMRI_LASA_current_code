clear all
%% Initialise inputs, pathnames 
codedir='/Volumes/LASA/Aphasia_project/tb-fMRI/code/L1/'; addpath(codedir)
utilsdir='/Volumes/LASA/Aphasia_project/tb-fMRI/code/utils/'; addpath(utilsdir)
rawdir = '/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
outdir = '/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
subjects = build_dataset(rawdir);
% Load group file
 group_path='/Volumes/LASA/Aphasia_project/tb-fMRI/code/L2/paired T test/';
 cd(group_path); [num,txt,raw] =xlsread('LASA_group_BIDS.xlsx',1,'B2:B29','basic');
 % Add group to dataset
 group=num2cell(num(:,1)); [subjects.group] =group{:}; 
 
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
subjects_s3(ismember({subjects_s3.name}, {'sub-17','sub-18', 'sub-19'})) = [];
%sub-18 ses-001 & ses-003 No Uulaa (didn´t sing)
%sub-17 ses-003 No Tydyy (wrong recordings)
%sub-19 ses-003 No Tydyy (wrong recordings)
cd(rawdir)

for s=1:numel(subjects_s3)
    if subjects_s3(s).group==1 % Trained Song Uulaa
        ses_pre='ses-001'; ses_post='ses-002';
        for ses=1:2
            if ses==1
                events_path=fullfile(subjects_s3(s).folder, subjects_s3(s).name, ses_pre, 'derivatives','SPM_prepro','func','events');
                cd(events_path)
                fnames=dir('*uulaa*');
                load(fnames.name) %%uulaa
                for i=1:numel(names)
                    if strcmp(names{i},'listen'), names{i}='listen_pre';
                    elseif strcmp(names{i},'singalong'), names{i}='singalong_pre';
                    elseif strcmp(names{i},'singmem'), names{i}='singmem_pre';
                    elseif strcmp(names{i},'baseline'), names{i}='baseline_pre';
                    elseif strcmp(names{i},'incorrect'), names{i}='incorrect_pre';
                    end
                end
                save (horzcat(subjects_s3(s).name, '_ses-001_task-uulaa_acq-multiband_events_renamed.mat'), 'names','onsets','durations');
                clear names onsets durations
            elseif ses==2
                events_path=fullfile(subjects_s3(s).folder, subjects_s3(s).name, ses_post, 'derivatives','SPM_prepro','func','events');
                cd(events_path)
                fnames=dir('*uulaa*');
                load(fnames.name) %%uulaa
                for i=1:numel(names)
                    if strcmp(names{i},'listen'), names{i}='listen_post';
                    elseif strcmp(names{i},'singalong'), names{i}='singalong_post';
                    elseif strcmp(names{i},'singmem'), names{i}='singmem_post';
                    elseif strcmp(names{i},'baseline'), names{i}='baseline_post';
                    elseif strcmp(names{i},'incorrect'), names{i}='incorrect_post';
                    end
                end
                save (horzcat(subjects_s3(s).name, '_ses-002_task-uulaa_acq-multiband_events_renamed.mat'), 'names','onsets','durations');
                clear names onsets durations
            end
        end
    elseif subjects_s3(s).group==2 % Trained Song Tydyy
        ses_pre='ses-002'; ses_post='ses-003';
        for ses=1:2
            if ses==1
                events_path=fullfile(subjects_s3(s).folder, subjects_s3(s).name, ses_pre, 'derivatives','SPM_prepro','func','events');
                cd(events_path)
                fnames=dir('*tydyy*');
                load(fnames.name) %%tydyy
                for i=1:numel(names)
                    if strcmp(names{i},'listen'), names{i}='listen_pre';
                    elseif strcmp(names{i},'singalong'), names{i}='singalong_pre';
                    elseif strcmp(names{i},'singmem'), names{i}='singmem_pre';
                    elseif strcmp(names{i},'baseline'), names{i}='baseline_pre';
                    elseif strcmp(names{i},'incorrect'), names{i}='incorrect_pre';
                    end
                end
                save (horzcat(subjects_s3(s).name, '_ses-002_task-tydyy_acq-multiband_events_renamed.mat'), 'names','onsets','durations');
                clear names onsets durations
            elseif ses==2
                events_path=fullfile(subjects_s3(s).folder, subjects_s3(s).name, ses_post, 'derivatives','SPM_prepro','func','events');
                cd(events_path)
                fnames=dir('*tydyy*');
                load(fnames.name) %%tydyy
                for i=1:numel(names)
                    if strcmp(names{i},'listen'), names{i}='listen_post';
                    elseif strcmp(names{i},'singalong'), names{i}='singalong_post';
                    elseif strcmp(names{i},'singmem'), names{i}='singmem_post';
                    elseif strcmp(names{i},'baseline'), names{i}='baseline_post';
                    elseif strcmp(names{i},'incorrect'), names{i}='incorrect_post';
                    end
                end
                save (horzcat(subjects_s3(s).name, '_ses-003_task-tydyy_acq-multiband_events_renamed.mat'), 'names','onsets','durations');
                clear names onsets durations
            end
        end
    end
end



