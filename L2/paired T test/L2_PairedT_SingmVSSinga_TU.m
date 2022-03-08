function L2_PairedT_LisVSRest_TU(subjects, outdir, varargin)
%L2_PairedT_LisVsRest_TU
%----------------------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addRequired('outdir', @ischar);
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('L1dir', 'SPM_first_level', @ischar)
p.addParameter('L1folder', 'L1_dur0_explbase_microres72_art_explmask_TU_missed', @ischar)
p.addParameter('L2folder', 'singm_vs_ singa_TU', @ischar)

p.parse(subjects, outdir, varargin{:});
Arg = p.Results;
 
%% Model specification    
matlabbatch{1}.spm.stats.factorial_design.dir = {fullfile(outdir, Arg.L2folder)};
%Select pair of scans for each group
n=1;
for sbj = 1:size(subjects, 1)
    disp(subjects(sbj).name)
    if subjects(sbj).group==1
        ses_pre='ses-001'; ses_post='ses-002';
    elseif subjects(sbj).group==2
        ses_pre='ses-002'; ses_post='ses-003';
    end
    sub_path_pre= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_pre, Arg.derdir,Arg.L1dir, Arg.L1folder);
    con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre), '^con_0004.*\.nii$');
    con_fnames_pre{sbj,1}=fullfile(sub_path_pre, con_pre{sbj,1});
    sub_path_post= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_post, Arg.derdir,Arg.L1dir, Arg.L1folder);
    con_post{sbj,1}=spm_select('List', fullfile(sub_path_post), '^con_0004.*\.nii$');
    con_fnames_post{sbj,1}=fullfile(sub_path_post, con_post{sbj,1});
    
    if ~isempty(con_pre{sbj,1}) && ~isempty( con_post{sbj,1})
        matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(n).scans = vertcat(con_fnames_pre(sbj,1), con_fnames_post(sbj,1));
        n=n+1;
    end
    
end

matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em =  {'/Users/noeliamartinezmolina/spm12/tpm/tpm_grey_thr15.nii,1'};;
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% Model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%% Contrast specification
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Sing mem vs Sing along TU AB/BA Pre vs Post';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Sing mem vs Sing along TU AB/BA Post vs Pre';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('interactive', matlabbatch)