clear all
data_path='E:\Aphasia_project\preprocessing\';
aux= ls(data_path);
names=aux(3:end,:);

%-----------------------------------------------------------------------
% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');

%% Loop for subjects
for suje=[7] % sub 4 excluded, sub 2 5 7 all trials correct
    clear ze_Tyd
    sub_path1=fullfile(data_path, (names(suje,:)), [(names(suje,:)) '_1']);
    cd (sub_path1)
    Tydyy=ls('*Tydyy_run*');
    run1=ls('*run1*');
    run2=ls('*run2*');
    if Tydyy(end)=='1'
        f_Tyd = spm_select('FPList', fullfile(sub_path1, run1), '^swrorf.*\.nii$');
        rp_ART_Tyd=spm_select('FPList', fullfile(sub_path1, run1), '^art_regression_outliers_and_movement.*\.mat$');
        aux2=cellstr(f_Tyd);
        if suje==2 || suje==5 || suje==7
            aux4=fullfile(sub_path1, '\Triggers\run1\', 'aphasia_sing_conditions_Tydyy_dur0_explbase.mat');
            multi_cond_Tyd=aux4(1,:);
        else
            aux4=spm_select('FPList',fullfile(sub_path1, '\Triggers\run1\'), '^aphasia.*\.mat$');
            multi_cond_Tyd=aux4(1,:);
        end
        cd(run1)
        art_Tyd=ls('*art_regression_outliers_and_movement*');
        aux6=load(art_Tyd);
        ze_Tyd=size(aux6.R,2);
    elseif Tydyy(end)=='2'
        f_Tyd = spm_select('FPList', fullfile(sub_path1, run2), '^swrorf.*\.nii$');
        rp_ART_Tyd=spm_select('FPList', fullfile(sub_path1, run2), '^art_regression_outliers_and_movement.*\.mat$');
        aux2=cellstr(f_Tyd);
        if suje==2 || suje==5 || suje==7
            aux4=fullfile(sub_path1, '\Triggers\run2\', 'aphasia_sing_conditions_Tydyy_dur0_explbase.mat');
            multi_cond_Tyd=aux4(1,:);
        else
            aux4=spm_select('FPList',fullfile(sub_path1, '\Triggers\run2\'), '^aphasia.*\.mat$');
            multi_cond_Tyd=aux4(1,:);
        end
        cd(run2)
        art_Tyd=ls('*art_regression_outliers_and_movement*');
        aux6=load(art_Tyd);
        ze_Tyd=size(aux6.R,2);
    end
    if ~exist ('First_Level_dur0_expl_base_microres_72__ART_explmasktpmgrey_allscans_Tyd_6rp_missed')
        mkdir First_Level_dur0_expl_base_microres_72_ART_explmasktpmgrey_allscans_Tyd_6rp_missed
    end
    clear matlabbatch a i 
    %% Model specification
    matlabbatch{1}.spm.stats.fmri_spec.dir = {fullfile(sub_path1, 'First_Level_dur0_expl_base_microres_72_ART_explmasktpmgrey_allscans_Tyd_6rp_missed')};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 9;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 72; %8 time bins/second (default) so TR*8=72
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;%SPM.T0 = (TA/2)/TR * SPM.T so (1.5/2)/9*72=6
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(f_Tyd);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = cellstr(multi_cond_Tyd);
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg =cellstr(rp_ART_Tyd);
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
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
    matlabbatch{3}.spm.stats.con.spmmat = cellstr(fullfile(sub_path1,'First_Level_dur0_expl_base_microres_72_ART_explmasktpmgrey_allscans_Tyd_6rp_missed','SPM.mat'));
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Listen>sing_along';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1 0 0 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1 0 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Listen>sing_mem';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 0 -1 0 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 0 -1 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Sing_along> sing_mem';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 1 -1 0 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 1 -1 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Sing_mem>sing_along';
    if suje==2 || suje==5 || suje==7
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 -1 1 0 zeros(1,ze_Tyd)];
    else
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 -1 1 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Sing_along>listen';
    if suje==2 || suje==5 || suje==7
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-1 1 0 0 zeros(1,ze_Tyd)];
    else
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-1 1 0 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Sing_mem>listen';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-1 0 1 0 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [-1 0 1 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Listen>baseline';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [1 0 0 -1 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [1 0 0 -1 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Sing_along>baseline';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 1 0 -1 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0 1 0 -1 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Sing_mem>baseline';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [0 0 1 -1 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [0 0 1 -1 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Baseline>listen';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [-1 0 0 1 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [-1 0 0 1 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Baseline>sing_along';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [0 -1 0 1 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [0 -1 0 1 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Baseline>sing_mem';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 -1 1 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 -1 1 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'Listening';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{13}.tcon.weights = [1 0 0 0 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{13}.tcon.weights = [1 0 0 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 'Sing along';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{14}.tcon.weights = [0 1 0 0 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{14}.tcon.weights = [0 1 0 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 'Sing from memory';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 1 0 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{15}.tcon.weights = [0 0 1 0 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 'Baseline';
    if suje==2 || suje==5 || suje==7
        matlabbatch{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 1 zeros(1,ze_Tyd)];
    else
        matlabbatch{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 1 0 zeros(1,ze_Tyd)];
    end
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;    
        
    spm_jobman('run',matlabbatch); %choose 'interactive' to load the batch without executing
    
end

    
    
