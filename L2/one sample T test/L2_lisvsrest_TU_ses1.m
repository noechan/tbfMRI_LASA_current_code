clear con con_fnames
%% Specify paths and list subjects
input_path='/Volumes/LASA/Aphasia_project/data/raw_data/'; %Path for L1
%covbeh_dir='G:\Aphasia_project\VBM_v4\analysis\covariates\behaviour\speech\'; %Path to the behavioural covariate
L2_path='/Volumes/LASA/Aphasia_project/data/stats/one sample T test/'; %Path to save the analysis
names= dir(input_path);
names(ismember({names.name},{'.','..', 'PPA', 'excluded'}))=[];
ses='ses-001';
der='derivatives';
L1='SPM_first_level';
L1_folder='L1_dur0_explbase_microres72_art_explmask_TU_missed';
L2_folder='listening_vs_ rest_TU_ses1';
%% Prepare inputs
n=1;
for sbj = 1:size(subjects_s1, 1) %Dataset from session 1
    disp(subjects_s1(sbj).name)
    sub_path= fullfile(subjects_s1(sbj).folder, subjects_s1(sbj).name, ses, der,L1, L1_folder);
    cd(sub_path), load('SPM.mat')
    con_idx=find(ismember({SPM.xCon.name}, {'Listen>baseline'}));
    if ~isempty(con_idx)
        if con_idx>9
            con{n,1}=spm_select('List', fullfile(sub_path),['^con_00' num2str(con_idx) '.*\.nii$']);
        elseif con_idx <10
            con{n,1}=spm_select('List', fullfile(sub_path),['^con_000' num2str(con_idx) '.*\.nii$']);
        end
        con_fnames{n,1}=fullfile(sub_path, con{n,1});
        n=n+1;
    end
    clear SPM
end
    
%% Model specification    
matlabbatch{1}.spm.stats.factorial_design.dir = {fullfile(L2_path,L2_folder)};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = con_fnames;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/Users/noeliamartinezmolina/spm12/tpm/tpm_grey_thr15.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% Model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%% Contrast specification
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Listening vs Rest TU';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('run', matlabbatch)