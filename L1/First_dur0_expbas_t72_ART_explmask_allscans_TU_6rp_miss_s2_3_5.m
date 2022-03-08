clear all
data_path='C:\Users\CBRU\Aphasia_project\preprocessing\';
aux= ls(data_path);
names=aux(3:end,:);

%-----------------------------------------------------------------------
% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');

%% Loop for subjects
for suje=[2 3 5]
    sub_path1=fullfile(data_path, (names(suje,:)), [(names(suje,:)) '_1']);
    cd (sub_path1)
    run1=ls('*run1*');
    run2=ls('*run2*');
    f_run1 = spm_select('FPList', fullfile(sub_path1, run1), '^swrorf.*\.nii$');
    f_run2 = spm_select('FPList', fullfile(sub_path1, run2), '^swrorf.*\.nii$');
    rp_ART_run1=spm_select('FPList', fullfile(sub_path1, run1), '^art_regression_outliers_and_movement.*\.mat$');
    rp_ART_run2=spm_select('FPList', fullfile(sub_path1, run2), '^art_regression_outliers_and_movement.*\.mat$');
    aux2=cellstr(f_run1);
    aux3=cellstr(f_run2);
    aux4=spm_select('FPList',fullfile(sub_path1, '\Triggers\run1\'), '^aphasia.*\.mat$');
    multi_cond_run1=aux4(1,:);
    aux5=spm_select('FPList',fullfile(sub_path1, '\Triggers\run2\'), '^aphasia.*\.mat$');
    multi_cond_run2=aux5(2,:);
    if ~exist ('First_Level_dur0_expl_base_microres_72_ART_explmasktpmgrey_allscans_TU_6rp_missed')
        mkdir First_Level_dur0_expl_base_microres_72_ART_explmasktpmgrey_allscans_TU_6rp_missed
    end
    cd(run1)
    art_run1=ls('*art_regression_outliers_and_movement*');
    aux6=load(art_run1);
    ze_run1=size(aux6.R,2);
    cd(fullfile(sub_path1,run2))
    art_run2=ls('*art_regression_outliers_and_movement*');
    aux7=load(art_run2);
    ze_run2=size(aux7.R,2);
    clear matlabbatch a i
    
    %% Model specification
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = {fullfile(sub_path1, 'First_Level_dur0_expl_base_microres_72_ART_explmasktpmgrey_allscans_TU_6rp_missed')};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 9;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 72; %8 time bins/second (default) so TR*8=72
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;%SPM.T0 = (TA/2)/TR * SPM.T so (1.5/2)/9*72=6
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = cellstr(f_run1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = cellstr(multi_cond_run1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg =cellstr(rp_ART_run1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = cellstr(f_run2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = cellstr(multi_cond_run2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg =cellstr(rp_ART_run2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.1;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {'C:\Program Files\spm12\tpm\tpm_grey_thr15.nii,1'};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'none';
    
    %% Model estimation
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    %% Contrast manager
    matlabbatch{3}.spm.stats.con.spmmat = cellstr(fullfile(sub_path1,'First_Level_dur0_expl_base_microres_72_ART_explmasktpmgrey_allscans_TU_6rp_missed','SPM.mat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Listen>sing_along';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1 0 0 0 zeros(1,ze_run1) 1 -1 0 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Listen>sing_mem';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 0 -1 0 0 zeros(1,ze_run1) 1 0 -1 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Sing_along> sing_mem';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 1 -1 0 0 zeros(1,ze_run1) 0 1 -1 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Sing_mem>sing_along';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 -1 1 0 0 zeros(1,ze_run1) 0 -1 1 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Sing_along>listen';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-1 1 0 0 0 zeros(1,ze_run1) -1 1 0 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Sing_mem>listen';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-1 0 1 0 0 zeros(1,ze_run1) -1 0 1 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Listen>baseline';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [1 0 0 -1 0 zeros(1,ze_run1) 1 0 0 -1 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Sing_along>baseline';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 1 0 -1 0 zeros(1,ze_run1) 0 1 0 -1 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Sing_mem>baseline';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [0 0 1 -1 0 zeros(1,ze_run1) 0 0 1 -1 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Baseline>listen';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [-1 0 0 1 0 zeros(1,ze_run1) -1 0 0 1 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Baseline>sing_along';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [0 -1 0 1 0 zeros(1,ze_run1)  0 -1 0 1 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Baseline>sing_mem';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 -1 1 0 zeros(1,ze_run1) 0 0 -1 1 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'Listening';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.weights = [1 0 0 0 0 zeros(1,ze_run1) 1 0 0 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 'Sing along';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.weights = [0 1 0 0 0 zeros(1,ze_run1) 0 1 0 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 'Sing from memory';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 1 0 0 zeros(1,ze_run1)  0 0 1 0 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 'Baseline';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 1 0 zeros(1,ze_run1)  0 0 0 1 zeros(1,ze_run2)];
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;
    
    
    spm_jobman('run',matlabbatch); %choose 'interactive' to load the batch without executing
    
end

    
    
