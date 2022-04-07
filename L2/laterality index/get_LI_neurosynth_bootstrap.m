clear con con_fnames
%% Specify paths and list subjects
input_path='/Volumes/LaCie/Aphasia_project/data/raw_data/'; %Path for L1
output_path='/Volumes/LaCie/Aphasia_project/data/stats/laterality_index/'; %Path for LI files
names= dir(input_path);
names(ismember({names.name},{'.','..', 'PPA', 'excluded'}))=[];
ses='ses-001';
der='derivatives';
L1='SPM_first_level';
L1_folder='L1_dur0_explbase_microres72_art_explmask_TU_missed';
%% Prepare inputs
n=1;
for sbj = 1:size(subjects_s1, 1) %Dataset from session 1
    disp(subjects_s1(sbj).name)
    sub_path= fullfile(subjects_s1(sbj).folder, subjects_s1(sbj).name, ses, der,L1, L1_folder);
    cd(sub_path), load('SPM.mat')
    con_idx=find(ismember({SPM.xCon.name}, {'Listen>baseline'}));
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

cd (output_path)

% Calculate Laterality Index
matlabbatch{1}.spm.tools.LI_cfg.spmT = spmT_fnames;
matlabbatch{1}.spm.tools.LI_cfg.inmask.im8 = 1; %grey matter
matlabbatch{1}.spm.tools.LI_cfg.exmask.em1 = 1; %midline +/-5mm
matlabbatch{1}.spm.tools.LI_cfg.method.thr7 = 1; %bootstrap
matlabbatch{1}.spm.tools.LI_cfg.pre = 0;
matlabbatch{1}.spm.tools.LI_cfg.op = 4;
matlabbatch{1}.spm.tools.LI_cfg.vc = 0;
matlabbatch{1}.spm.tools.LI_cfg.ni = 1;
matlabbatch{1}.spm.tools.LI_cfg.outfile = 'li.txt';
spm_jobman('interactive', matlabbatch)



