function L2_T2_LisVSSinga(subjects, outdir, varargin)
%L2_T2_LisVSSinga
%----------------------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addRequired('outdir', @ischar);
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('ses', 'ses-001', @ischar)
p.addParameter('L1dir', 'SPM_first_level', @ischar)
p.addParameter('L1folderLASA', 'L1_dur0_explbase_microres72_art_explmask_TU_missed', @ischar)
p.addParameter('L1folderBRAVE', 'L1_LASA-BRAVE_8mm_20210524_art_z4_mdiff3', @ischar)
p.addParameter('L2folder', 'listen_vs_singa_age_TIV_BRAVEvsLASA_wo_motion_outliers', @ischar)

p.parse(subjects, outdir, varargin{:});
Arg = p.Results;
 
%% Model specification      
matlabbatch{1}.spm.stats.factorial_design.dir ={fullfile(outdir, Arg.L2folder)};
%Select pair of scans for each group
g1=1; g2=1; a=1;
for sbj = 1:size(subjects, 1)
    disp(subjects(sbj).name)
    if subjects(sbj).group==1
        sub_path_LASA= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir,Arg.L1dir, Arg.L1folderLASA);
        cd(sub_path_LASA), load('SPM.mat')
        con_idx_LASA=find(ismember({SPM.xCon.name}, {'Listen>sing_along'}));
        if ~isempty(con_idx_LASA)
            if con_idx_LASA >9
                con_LASA{g1,1}=spm_select('List', fullfile(sub_path_LASA),['^con_00' num2str(con_idx_LASA) '.*\.nii$']);
            elseif ~isempty(con_idx_LASA) && con_idx_LASA <10
                con_LASA{g1,1}=spm_select('List', fullfile(sub_path_LASA),['^con_000' num2str(con_idx_LASA) '.*\.nii$']);
            end
            con_fnames_LASA{g1,1}=fullfile(sub_path_LASA, con_LASA{g1,1});
            g1=g1+1;
        else
            idx_Age(a,1)=sbj;
            exclude_sbj{a,1}= subjects(sbj).name;
            a=a+1;
        end
        clear SPM
    elseif subjects(sbj).group==2
        sub_path_BRAVE= fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.derdir, Arg.L1dir, Arg.L1folderBRAVE);
        cd (sub_path_BRAVE), load('SPM.mat')
        con_idx_BRAVE=find(ismember({SPM.xCon.name}, {'Listen>sing_along'}));
        if ~isempty(con_idx_BRAVE)
            if con_idx_BRAVE >9
                con_BRAVE{g2,1}=spm_select('List', fullfile(sub_path_BRAVE),['^con_00' num2str(con_idx_BRAVE) '.*\.nii$']);
            elseif con_idx_BRAVE <10
                con_BRAVE{g2,1}=spm_select('List', fullfile(sub_path_BRAVE),['^con_000' num2str(con_idx_BRAVE) '.*\.nii$']);
            end
            con_fnames_BRAVE{g2,1}=fullfile(sub_path_BRAVE, con_BRAVE{g2,1});
            g2=g2+1;
        end
    end
    clear SPM
end

matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = con_fnames_LASA;
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = con_fnames_BRAVE;
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
if exist('idx_Age'), subjects(idx_Age)=[]; end
age= [subjects(:).age]; TIV= [subjects(:).TIV];
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = age;
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'Age';
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).c = TIV;
matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'TIV';
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
matlabbatch{1}.spm.stats.factorial_design.masking.em =  {'/Users/noeliamartinezmolina/spm12/tpm/tpm_grey_thr15.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% Model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%% Contrast specification
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'BRAVE vs LASA Listen vs Sing along ses-1';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'LASA vs BRAVE Listen vs Sing along ses-1';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('interactive', matlabbatch)
end