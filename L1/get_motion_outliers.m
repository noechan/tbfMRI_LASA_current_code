function get_motion_outliers(subjects, outdir,varargin)

%--------------------------------------------------------------------------
% Initialise inputs and pathnames
p = inputParser;
p.addRequired('subjects', @isstruct)
p.addParameter('ses','ses-002', @ischar)
p.addParameter('derdir', 'derivatives', @ischar)
p.addParameter('prepdir', 'SPM_prepro', @ischar)
p.addParameter('funcdir', 'func', @ischar)
p.addParameter('norm','normalize', @ischar)
p.addParameter('smo','smoothing', @ischar)
p.addParameter('eve', 'events',@ischar)
p.addParameter('art','art',@ischar)
p.addParameter('L1','SPM_first_level',@ischar)

p.parse(subjects, varargin{:});
Arg = p.Results;


%% Loop for subjects
n=1;
for sbj = 1:numel(subjects)
    disp(sbj)
    sub_path = fullfile(subjects(sbj).folder, subjects(sbj).name, Arg.ses, Arg.derdir, Arg.prepdir, Arg.funcdir,Arg.norm);
   
    %Get number of outliers
    rp_art_Tydyy=horzcat( 'art_regression_outliers_wror',subjects(sbj).name, '_', Arg.ses, '_task-tydyy_acq-multiband_bold_00001.mat');
    rp_art_Uulaa=horzcat( 'art_regression_outliers_wror',subjects(sbj).name, '_', Arg.ses,'_task-uulaa_acq-multiband_bold_00001.mat');
    cd(sub_path)
    load(rp_art_Tydyy); num_outliers_Tydyy{n}=size(R,2); sub_outliers_Tydyy{n}={subjects(sbj).name};
    load(rp_art_Uulaa); num_outliers_Uulaa{n}=size(R,2); sub_outliers_Uulaa{n}={subjects(sbj).name};
    n=n+1;
end

sub_rp_art_Tydyy=vertcat(sub_outliers_Tydyy, num_outliers_Tydyy);
sub_rp_art_Uulaa=vertcat(sub_outliers_Uulaa, num_outliers_Uulaa);
cd (outdir)
save(['sub_rp_art_Tydyy_' Arg.ses '.mat'], 'sub_rp_art_Tydyy')
save(['sub_rp_art_Uulaa_' Arg.ses '.mat'], 'sub_rp_art_Uulaa')