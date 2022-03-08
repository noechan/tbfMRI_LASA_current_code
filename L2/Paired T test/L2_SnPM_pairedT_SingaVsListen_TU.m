function L2_SnPM_PairedT_SingaVSRest_TU_Age(subjects, outdir, varargin)
%L2_SnPM_PairedT_SingaVsRest_TU
%----------------------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct);
p.addRequired('outdir', @ischar);
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('L1dir', 'SPM_first_level', @ischar)
p.addParameter('L1folder', 'L1_dur0_explbase_microres72_art_explmask_TU_missed', @ischar)
p.addParameter('L2folder', 'singa_vs_listen_TU_wo_3_14_19_27_28', @ischar)

p.parse(subjects, outdir, varargin{:});
Arg = p.Results;

%% Model specification
matlabbatch{1}.spm.tools.snpm.des.PairT.DesignName = 'MultiSub: Paired T test; 2 conditions, 1 scan per condition';
matlabbatch{1}.spm.tools.snpm.des.PairT.DesignFile = 'snpm_bch_ui_PairT';
matlabbatch{1}.spm.tools.snpm.des.PairT.dir ={fullfile(outdir, Arg.L2folder)};

%Select pair of scans for each group
n=1; a=1;
for sbj = 1:size(subjects, 1)
    disp(subjects(sbj).name)
    if subjects(sbj).group==1
        ses_pre='ses-001'; ses_post='ses-002';
    elseif subjects(sbj).group==2
        ses_pre='ses-002'; ses_post='ses-003';
    end
sub_path_pre= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_pre, Arg.derdir,Arg.L1dir, Arg.L1folder);
    cd(sub_path_pre), load('SPM.mat')
        con_idx_pre=find(ismember({SPM.xCon.name}, {'Sing_along>listen'}));
        if ~isempty(con_idx_pre)
            if con_idx_pre >9
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_00' num2str(con_idx_pre) '.*\.nii$']);
            elseif ~isempty(con_idx_pre) && con_idx_pre <10
                con_pre{sbj,1}=spm_select('List', fullfile(sub_path_pre),['^con_000' num2str(con_idx_pre) '.*\.nii$']);
            end
            con_fnames_pre{sbj,1}=fullfile(sub_path_pre, con_pre{sbj,1});
        end
        clear SPM
        sub_path_post= fullfile(subjects(sbj).folder, subjects(sbj).name, ses_post, Arg.derdir,Arg.L1dir, Arg.L1folder);
        cd (sub_path_post), load('SPM.mat')
        con_idx_post=find(ismember({SPM.xCon.name}, {'Sing_along>listen'}));
        if ~isempty(con_idx_post)
            if con_idx_post >9
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_00' num2str(con_idx_post) '.*\.nii$']);
            elseif con_idx_post <10
                con_post{sbj,1}=spm_select('List', fullfile(sub_path_post),['^con_000' num2str(con_idx_post) '.*\.nii$']);
            end
            con_fnames_post{sbj,1}=fullfile(sub_path_post, con_post{sbj,1});
        end
        clear SPM

    if ~isempty(con_idx_pre) && ~isempty( con_idx_post)
        
matlabbatch{1}.spm.tools.snpm.des.PairT.fsubject(n).scans =  vertcat(con_fnames_post(sbj,1), con_fnames_pre(sbj,1));
matlabbatch{1}.spm.tools.snpm.des.PairT.fsubject(n).scindex = [1 2];
        n=n+1;
    else 
        idx_Age(a,1)=sbj;
        exclude_sbj{a,1}= subjects(sbj).name;
        a=a+1;
    end 
end

matlabbatch{1}.spm.tools.snpm.des.PairT.nPerm = 5000;
matlabbatch{1}.spm.tools.snpm.des.PairT.vFWHM = [0 0 0]; % Without smoothing variance
matlabbatch{1}.spm.tools.snpm.des.PairT.bVolm = 1;
matlabbatch{1}.spm.tools.snpm.des.PairT.ST.ST_later = -1;
matlabbatch{1}.spm.tools.snpm.des.PairT.masking.tm.tm_none = 1;
matlabbatch{1}.spm.tools.snpm.des.PairT.masking.im = 0;
matlabbatch{1}.spm.tools.snpm.des.PairT.masking.em ={'/Users/noeliamartinezmolina/spm12/tpm/tpm_grey_thr15.nii,1'};
matlabbatch{1}.spm.tools.snpm.des.PairT.globalc.g_omit = 1;
matlabbatch{1}.spm.tools.snpm.des.PairT.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.tools.snpm.des.PairT.globalm.glonorm = 1;
%% Compute
matlabbatch{2}.spm.tools.snpm.cp.snpmcfg(1) = cfg_dep('MultiSub: Paired T test; 2 conditions, 1 scan per condition: SnPMcfg.mat configuration file', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','SnPMcfg'));
%% Inference
matlabbatch{3}.spm.tools.snpm.inference.SnPMmat(1) = cfg_dep('Compute: SnPM.mat results file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','SnPM'));
matlabbatch{3}.spm.tools.snpm.inference.Thr.Clus.ClusSize.CFth = 0.0001;
matlabbatch{3}.spm.tools.snpm.inference.Thr.Clus.ClusSize.ClusSig.FWEthC = 0.05;
matlabbatch{3}.spm.tools.snpm.inference.Tsign = 1;
matlabbatch{3}.spm.tools.snpm.inference.WriteFiltImg.name = 'SnPM_filtered';
matlabbatch{3}.spm.tools.snpm.inference.Report = 'MIPtable';
spm_jobman('interactive', matlabbatch)