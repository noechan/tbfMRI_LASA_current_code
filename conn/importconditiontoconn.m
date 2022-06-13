% import conditions into conn
clear all
%% Initialise inputs, pathnames 
codedir='/Volumes/LASA/Aphasia_project/tb-fMRI/code/L1/'; addpath(codedir)
utilsdir='/Volumes/LASA/Aphasia_project/tb-fMRI/code/utils/'; addpath(utilsdir)
rawdir = '/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
outdir = '/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/';
conndir='/Volumes/LASA/Aphasia_project/tb-fMRI/results/gPPI_conn/trained_song/';
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
cond_ses1=zeros(19,1); cond_ses2=zeros(19,1);
n1g1=1; n1g2=1;n2g1=1;n2g2=1;
for s=1:numel(subjects_s3)
    if subjects_s3(s).group==1 % Trained Song Uulaa
        ses_pre='ses-001'; ses_post='ses-002';
        for ses=1:2
            if ses==1
                events_path=fullfile(subjects_s3(s).folder, subjects_s3(s).name, ses_pre, 'derivatives','SPM_prepro','func','events');
                cd(events_path)
                fnames=dir('*uulaa_acq-multiband_events_renamed*');
                cond_g1_ses1(n1g1,1)=fnames;
                n1g1=n1g1+1;               
            elseif ses==2
                events_path=fullfile(subjects_s3(s).folder, subjects_s3(s).name, ses_post, 'derivatives','SPM_prepro','func','events');
                cd(events_path)
                fnames=dir('*uulaa*');
               fnames=dir('*uulaa_acq-multiband_events_renamed*');
                cond_g1_ses2(n2g1,1)=fnames;
                n2g1=n2g1+1; 
            end
        end
    elseif subjects_s3(s).group==2 % Trained Song Tydyy
        ses_pre='ses-002'; ses_post='ses-003';
        for ses=1:2
            if ses==1
                events_path=fullfile(subjects_s3(s).folder, subjects_s3(s).name, ses_pre, 'derivatives','SPM_prepro','func','events');
                cd(events_path)
                fnames=dir('*tydyy_acq-multiband_events_renamed*');
                cond_g2_ses1(n1g2,1)=fnames;
                n1g2=n1g2+1; 
            elseif ses==2
                events_path=fullfile(subjects_s3(s).folder, subjects_s3(s).name, ses_post, 'derivatives','SPM_prepro','func','events');
                cd(events_path)
                fnames=dir('*tydyy_acq-multiband_events_renamed*');
                cond_g2_ses2(n2g2,1)=fnames;
                n2g2=n2g2+1; 
            end
        end
    end
end

cond_g1_ses1(ismember({cond_g1_ses1.name}, {'sub-14_ses-001_task-uulaa_acq-multiband_events_renamed.mat','sub-28_ses-001_task-uulaa_acq-multiband_events_renamed.mat'})) = []; %not included in the pre post comparison in group 1 (AB)
cond_g1_ses2(ismember({cond_g1_ses2.name},  {'sub-14_ses-002_task-uulaa_acq-multiband_events_renamed.mat','sub-28_ses-002_task-uulaa_acq-multiband_events_renamed.mat'})) = []; %not included in the pre post comparison in group 1 (AB)
cond_g2_ses1(ismember({cond_g2_ses1.name}, {'sub-03_ses-002_task-tydyy_acq-multiband_events_renamed.mat','sub-27_ses-002_task-tydyy_acq-multiband_events_renamed.mat'})) = []; %not included in the pre post comparison in group 2 (BA)
cond_g2_ses2(ismember({cond_g2_ses2.name}, {'sub-03_ses-003_task-tydyy_acq-multiband_events_renamed.mat','sub-27_ses-003_task-tydyy_acq-multiband_events_renamed.mat'})) = []; %not included in the pre post comparison in group 2 (BA)

cd (conndir)
load ('conn_gppi_test.mat')
    conn_importcondition({{fullfile(rawdir, 'sub-01/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(1).name), fullfile(rawdir, 'sub-01/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(1).name)},...
    {fullfile(rawdir, 'sub-08/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(2).name), fullfile(rawdir, 'sub-08/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(2).name)},...
    {fullfile(rawdir, 'sub-09/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(3).name), fullfile(rawdir, 'sub-09/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(3).name)},...
    {fullfile(rawdir, 'sub-11/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(4).name), fullfile(rawdir, 'sub-11/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(4).name)},...
    {fullfile(rawdir, 'sub-13/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(5).name), fullfile(rawdir, 'sub-13/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(5).name)},...
    {fullfile(rawdir, 'sub-23/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(6).name), fullfile(rawdir, 'sub-23/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(6).name)},...
    {fullfile(rawdir, 'sub-25/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(7).name), fullfile(rawdir, 'sub-25/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(7).name)},...
    {fullfile(rawdir, 'sub-26/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(8).name), fullfile(rawdir, 'sub-26/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(8).name)},...
    {fullfile(rawdir, 'sub-30/ses-001/derivatives/SPM_prepro/func/events',cond_g1_ses1(9).name), fullfile(rawdir, 'sub-30/ses-002/derivatives/SPM_prepro/func/events',cond_g1_ses2(9).name)},...
    {fullfile(rawdir, 'sub-02/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(1).name), fullfile(rawdir, 'sub-02/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(1).name)},...
    {fullfile(rawdir, 'sub-05/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(2).name), fullfile(rawdir, 'sub-05/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(2).name)},...
    {fullfile(rawdir, 'sub-06/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(3).name), fullfile(rawdir, 'sub-06/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(3).name)},...
    {fullfile(rawdir, 'sub-07/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(4).name), fullfile(rawdir, 'sub-07/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(4).name)},...
    {fullfile(rawdir, 'sub-10/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(5).name), fullfile(rawdir, 'sub-10/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(5).name)},...
    {fullfile(rawdir, 'sub-16/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(6).name), fullfile(rawdir, 'sub-16/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(6).name)},...
    {fullfile(rawdir, 'sub-20/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(7).name), fullfile(rawdir, 'sub-20/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(7).name)},...
    {fullfile(rawdir, 'sub-21/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(8).name), fullfile(rawdir, 'sub-21/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(8).name)},...
    {fullfile(rawdir, 'sub-22/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(9).name), fullfile(rawdir, 'sub-22/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(9).name)},...
    {fullfile(rawdir, 'sub-29/ses-002/derivatives/SPM_prepro/func/events',cond_g2_ses1(10).name), fullfile(rawdir, 'sub-29/ses-003/derivatives/SPM_prepro/func/events',cond_g2_ses2(10).name)}});

save('conn_gppi_test.mat', 'CONN_x')
    