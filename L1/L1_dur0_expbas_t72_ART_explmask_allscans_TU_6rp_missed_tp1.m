clear all
data_path='F:\Aphasia_project\Preprocessing\LASA2019\';
aux= ls(data_path);
names=aux(3:end,:);

%-----------------------------------------------------------------------
% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');

%% Loop for subjects
for suje=[3:4 6 10 13 17:19]%Only patients with 2 runs ok were included, N=8
    clear ze_run1 ze_run2
    sub_path1=fullfile(data_path, (names(suje,:)), [(names(suje,:)) '_1']);
    cd (sub_path1)
    run1=ls('*run1*');
    run2=ls('*run2*');
    %%% Scans
    f_run1 = spm_select('FPList', fullfile(sub_path1, run1), '^swror.*\.nii$');aux2=cellstr(f_run1);
    f_run2 = spm_select('FPList', fullfile(sub_path1, run2), '^swror.*\.nii$'); aux3=cellstr(f_run2);
    %%% Realignment parameters after scrubbing in ART
    rp_ART_run1=spm_select('FPList', fullfile(sub_path1, run1), '^art_regression_outliers_and_movement.*\.mat$');
    rp_ART_run2=spm_select('FPList', fullfile(sub_path1, run2), '^art_regression_outliers_and_movement.*\.mat$');
    %%% Triggers
    aux4=spm_select('FPList',fullfile(sub_path1, '\Triggers\run1\'), '^aphasia.*\.mat$');
    multi_cond_run1=aux4(1,:);
    if suje==6 %patient ID140 (suje=6) all trials correct in Tyddy run 2
        aux5=spm_select('FPList',fullfile(sub_path1, '\Triggers\run2\'), 'aphasia_sing_conditions_Tydyy_dur0_explbase.mat');
    else
        aux5=spm_select('FPList',fullfile(sub_path1, '\Triggers\run2\'), '^aphasia.*\.mat$');
    end
    multi_cond_run2=aux5(1,:);
    %%% Number of outlier scans in each run
    cd(run1)
    art_run1=ls('*art_regression_outliers_and_movement*');
    aux6=load(art_run1);
    ze_run1=size(aux6.R,2);
    cd(fullfile(sub_path1,run2))
    art_run2=ls('*art_regression_outliers_and_movement*');
    aux7=load(art_run2);
    ze_run2=size(aux7.R,2);
    %%% Create L1 output folder
    if ~exist ('First_Level_dur0_expl_base_microres_72__ART_explmasktpmgrey_allscans_TU_6rp_missed')
        mkdir First_Level_dur0_expl_base_microres_72_ART_explmasktpmgrey_allscans_TU_6rp_missed
    end
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

    

    spm_jobman('run',matlabbatch); %choose 'interactive' to load the batch without executing
    
end

    
    
