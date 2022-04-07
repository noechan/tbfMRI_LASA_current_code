clear con con_fnames
%% Specify paths and list subjects
input_path='/Volumes/LASA/Aphasia_project/tb-fMRI/data/LASA/'; %Path for L1
output_path='/Volumes/LASA/Aphasia_project/tb-fMRI/results/laterality_index/LI_Neurosynth_speech_production/'; %Path for LI files
roi_path='/Volumes/LASA/Aphasia_project/tb-fMRI/results/laterality_index/rois/';
names= dir(input_path);
names(ismember({names.name},{'.','..', 'PPA', 'excluded'}))=[];
ses='ses-001';
der='derivatives';
L1='SPM_first_level';
L1_folder='L1_dur0_explbase_microres72_art_explmask_TU_missed';
neurosynth_speech='speech_production_association-test_z_FDR_0.01_bin.nii';

%% SING ALONG VERSUS BASELINE CONTRAST
% Prepare inputs
n=1;
for sbj = 1:size(subjects_s1, 1) %Dataset from session 1 after running testuse_SPM_prepro.m and deleting sub-18
    disp(subjects_s1(sbj).name)
    sub_path= fullfile(subjects_s1(sbj).folder, subjects_s1(sbj).name, ses, der,L1, L1_folder);
    cd(sub_path), load('SPM.mat')
    con_idx=find(ismember({SPM.xCon.name}, {'Sing_along>sing_mem'}));
    if ~isempty(con_idx)
        if con_idx>9
            spmT{n,1}=spm_select('List', fullfile(sub_path),['^spmT_00' num2str(con_idx) '.*\.nii$']);
        elseif con_idx <10
            spmT{n,1}=spm_select('List', fullfile(sub_path),['^spmT_000' num2str(con_idx) '.*\.nii$']);
        end
        spmT_fnames{n,1}=fullfile(sub_path, spmT{n,1});
        n=n+1;
    end
    clear SPM
end

cd (fullfile(output_path,'singavsrest'))

% Calculate Laterality Index
matlabbatch{1}.spm.tools.LI_cfg.spmT = spmT_fnames;
matlabbatch{1}.spm.tools.LI_cfg.inmask.im11 = {'/Volumes/LASA/Aphasia_project/tb-fMRI/results/laterality_index/rois/speech_production_association-test_z_FDR_0.01_bin.nii,1'};
%neurosynth speech production mask
matlabbatch{1}.spm.tools.LI_cfg.exmask.em1 = 1; %midline +/-5mm
matlabbatch{1}.spm.tools.LI_cfg.method.thr7 = 1; %bootstrap
matlabbatch{1}.spm.tools.LI_cfg.pre = 0;
matlabbatch{1}.spm.tools.LI_cfg.op = 4;
matlabbatch{1}.spm.tools.LI_cfg.vc = 0;
matlabbatch{1}.spm.tools.LI_cfg.ni = 1;
matlabbatch{1}.spm.tools.LI_cfg.outfile = 'li_neurosynth_speech_prod_singavsrest.txt';
spm_jobman('interactive', matlabbatch)
clear matlabbatch spmT spmT_fnames

%% SING MEMORY VERSUS BASELINE CONTRAST

% Prepare inputs
n=1;
for sbj = 1:size(subjects_s1, 1) %Dataset from session 1 after running testuse_SPM_prepro.m and deleting sub-18
    disp(subjects_s1(sbj).name)
    sub_path= fullfile(subjects_s1(sbj).folder, subjects_s1(sbj).name, ses, der,L1, L1_folder);
    cd(sub_path), load('SPM.mat')
    con_idx=find(ismember({SPM.xCon.name}, {'Sing_mem>baseline'}));
    if ~isempty(con_idx)
        if con_idx>9
            spmT{n,1}=spm_select('List', fullfile(sub_path),['^spmT_00' num2str(con_idx) '.*\.nii$']);
        elseif con_idx <10
            spmT{n,1}=spm_select('List', fullfile(sub_path),['^spmT_000' num2str(con_idx) '.*\.nii$']);
        end
        spmT_fnames{n,1}=fullfile(sub_path, spmT{n,1});
        n=n+1;
    end
    clear SPM
end

cd (fullfile(output_path,'singmvsrest'))

% Calculate Laterality Index
matlabbatch{1}.spm.tools.LI_cfg.spmT = spmT_fnames;
matlabbatch{1}.spm.tools.LI_cfg.inmask.im11 = {'/Volumes/LASA/Aphasia_project/tb-fMRI/results/laterality_index/rois/speech_production_association-test_z_FDR_0.01_bin.nii,1'};
%neurosynth speech production mask
matlabbatch{1}.spm.tools.LI_cfg.exmask.em1 = 1; %midline +/-5mm
matlabbatch{1}.spm.tools.LI_cfg.method.thr7 = 1; %bootstrap
matlabbatch{1}.spm.tools.LI_cfg.pre = 0;
matlabbatch{1}.spm.tools.LI_cfg.op = 4;
matlabbatch{1}.spm.tools.LI_cfg.vc = 0;
matlabbatch{1}.spm.tools.LI_cfg.ni = 1;
matlabbatch{1}.spm.tools.LI_cfg.outfile = 'li_neurosynth_speech_prod_singmvsrest.txt';
spm_jobman('interactive', matlabbatch)
clear matlabbatch spmT spmT_fnames

%% SING ALONG VERSUS SING MEMORY CONTRAST

% Prepare inputs
n=1;
for sbj = 1:size(subjects_s1, 1) %Dataset from session 1 after running testuse_SPM_prepro.m and deleting sub-18
    disp(subjects_s1(sbj).name)
    sub_path= fullfile(subjects_s1(sbj).folder, subjects_s1(sbj).name, ses, der,L1, L1_folder);
    cd(sub_path), load('SPM.mat')
    con_idx=find(ismember({SPM.xCon.name}, {'Sing_along>sing_mem'}));
    if ~isempty(con_idx)
        if con_idx>9
            spmT{n,1}=spm_select('List', fullfile(sub_path),['^spmT_00' num2str(con_idx) '.*\.nii$']);
        elseif con_idx <10
            spmT{n,1}=spm_select('List', fullfile(sub_path),['^spmT_000' num2str(con_idx) '.*\.nii$']);
        end
        spmT_fnames{n,1}=fullfile(sub_path, spmT{n,1});
        n=n+1;
    end
    clear SPM
end

cd (fullfile(output_path,'singavssingm'))

% Calculate Laterality Index
matlabbatch{1}.spm.tools.LI_cfg.spmT = spmT_fnames;
matlabbatch{1}.spm.tools.LI_cfg.inmask.im11 = {'/Volumes/LASA/Aphasia_project/tb-fMRI/results/laterality_index/rois/speech_production_association-test_z_FDR_0.01_bin.nii,1'};
%neurosynth speech production mask
matlabbatch{1}.spm.tools.LI_cfg.exmask.em1 = 1; %midline +/-5mm
matlabbatch{1}.spm.tools.LI_cfg.method.thr7 = 1; %bootstrap
matlabbatch{1}.spm.tools.LI_cfg.pre = 0;
matlabbatch{1}.spm.tools.LI_cfg.op = 4;
matlabbatch{1}.spm.tools.LI_cfg.vc = 0;
matlabbatch{1}.spm.tools.LI_cfg.ni = 1;
matlabbatch{1}.spm.tools.LI_cfg.outfile = 'li_neurosynth_speech_prod_singavssingm.txt';
spm_jobman('interactive', matlabbatch)
clear matlabbatch spmT spmT_fnames

%% SING MEMORY VERSUS SING ALONG CONTRAST

% Prepare inputs
n=1;
for sbj = 1:size(subjects_s1, 1) %Dataset from session 1 after running testuse_SPM_prepro.m and deleting sub-18
    disp(subjects_s1(sbj).name)
    sub_path= fullfile(subjects_s1(sbj).folder, subjects_s1(sbj).name, ses, der,L1, L1_folder);
    cd(sub_path), load('SPM.mat')
    con_idx=find(ismember({SPM.xCon.name}, {'Sing_mem>sing_along'}));
    if ~isempty(con_idx)
        if con_idx>9
            spmT{n,1}=spm_select('List', fullfile(sub_path),['^spmT_00' num2str(con_idx) '.*\.nii$']);
        elseif con_idx <10
            spmT{n,1}=spm_select('List', fullfile(sub_path),['^spmT_000' num2str(con_idx) '.*\.nii$']);
        end
        spmT_fnames{n,1}=fullfile(sub_path, spmT{n,1});
        n=n+1;
    end
    clear SPM
end

cd (fullfile(output_path,'singmvssinga'))

% Calculate Laterality Index
matlabbatch{1}.spm.tools.LI_cfg.spmT = spmT_fnames;
matlabbatch{1}.spm.tools.LI_cfg.inmask.im11 = {'/Volumes/LASA/Aphasia_project/tb-fMRI/results/laterality_index/rois/speech_production_association-test_z_FDR_0.01_bin.nii,1'};
%neurosynth speech production mask
matlabbatch{1}.spm.tools.LI_cfg.exmask.em1 = 1; %midline +/-5mm
matlabbatch{1}.spm.tools.LI_cfg.method.thr7 = 1; %bootstrap
matlabbatch{1}.spm.tools.LI_cfg.pre = 0;
matlabbatch{1}.spm.tools.LI_cfg.op = 4;
matlabbatch{1}.spm.tools.LI_cfg.vc = 0;
matlabbatch{1}.spm.tools.LI_cfg.ni = 1;
matlabbatch{1}.spm.tools.LI_cfg.outfile = 'li_neurosynth_speech_prod_singmvssinga.txt';
spm_jobman('interactive', matlabbatch)
clear matlabbatch spmT spmT_fnames
