%% Initialise inputs, pathnames 
rawdir = '\\Neuro_NAS\homes\nomamoli\LASA_project\raw_data\';
subjects = build_dataset(rawdir);
outdir = 'G:\Aphasia_project\raw_data\';
der='derivatives';
prep='SPM_prepro';
func='func';
anat='anat';

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

for sbji_s1 = 3:size(subjects_s1,1)
    sub_path_func_der = fullfile(subjects(sbji_s1).folder, subjects(sbji_s1).name,'ses-001',der, prep, func);
    sub_path_anat_der = fullfile(subjects(sbji_s1).folder, subjects(sbji_s1).name,'ses-001',der, prep, anat);
    dst=fullfile(outdir,subjects(sbji_s1).name,'ses-001',der, prep);
    if ~isfolder(fullfile(dst,func))
        mkdir(fullfile(dst,func))
    end
    copyfile(sub_path_func_der, fullfile(dst,func))
    if ~isfolder(fullfile(dst,anat))
        mkdir(fullfile(dst,anat))
    end
    copyfile(sub_path_anat_der, fullfile(dst,anat))
end

for sbji_s2 = 25:size(subjects_s2,1)
    sub_path_func_der = fullfile(subjects(sbji_s2).folder, subjects(sbji_s2).name,'ses-002',der, prep, func);
    sub_path_anat_der = fullfile(subjects(sbji_s2).folder, subjects(sbji_s2).name,'ses-002',der, prep, anat);
    dst=fullfile(outdir,subjects(sbji_s2).name,'ses-002',der, prep);
    if ~isfolder(fullfile(dst,func))
        mkdir(fullfile(dst,func))
    end
    copyfile(sub_path_func_der, fullfile(dst,func))
    if ~isfolder(fullfile(dst,anat))
        mkdir(fullfile(dst,anat))
    end
    copyfile(sub_path_anat_der, fullfile(dst,anat))
end

for sbji_s3 =25:size(subjects_s3,1)
    sub_path_func_der = fullfile(subjects(sbji_s3).folder, subjects(sbji_s3).name,'ses-003',der, prep, func);
    sub_path_anat_der = fullfile(subjects(sbji_s3).folder, subjects(sbji_s3).name,'ses-003',der, prep, anat);
    dst=fullfile(outdir,subjects(sbji_s3).name,'ses-003',der, prep);
    if ~isfolder(fullfile(dst,func))
        mkdir(fullfile(dst,func))
    end
    copyfile(sub_path_func_der, fullfile(dst,func))
    if ~isfolder(fullfile(dst,anat))
        mkdir(fullfile(dst,anat))
    end
    copyfile(sub_path_anat_der, fullfile(dst,anat))
end

