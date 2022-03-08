%% Special cases contrasts
clear all
addpath('/Volumes/LASA/Aphasia_project/code/L1')
code_path='/Volumes/LASA/Aphasia_project/code/L1/';
load(fullfile(code_path, 'subjects_s1_diff.mat')); load(fullfile(code_path, 'subjects_s2_diff.mat')); load(fullfile(code_path, 'subjects_s3_diff.mat')); 

%% Session 1 (change session parameter to ses-001 in the corresponding SPM function)
% sub-02 
C2_SPM_Contrasts_4reg_incorrect_5reg (subjects_s1_diff(1))
%sub-03
C1_SPM_Contrasts_5reg_4reg_incorrect(subjects_s1_diff(2))
%sub-04
C5_SPM_Contrasts_4reg_nolisten(subjects_s1_diff(3))
%sub-05 & sub-22
C2_SPM_Contrasts_4reg_incorrect_5reg(subjects_s1_diff([4 9]))
%sub-07
C4_SPM_Contrasts_4reg_incorrect (subjects_s1_diff([15]))
%sub-17
C12_SPM_Contrasts_4reg_nosingm_4reg_nolisten(subjects_s1_diff(6)) 
%sub-21 & sub-23
C3_SPM_Contrasts_4reg_nolisten_5reg(subjects_s1_diff([8 10])) 
%sub-25
C8_SPM_Contrasts_4reg_nosingm_5reg(subjects_s1_diff(11)) 
%sub-27
C6_SPM_Contrasts_3reg_nolisten_nobase(subjects_s1_diff(12)) 
%sub-28
C17_SPM_Contrasts_3reg_nolisten_nosingm_4reg_nolisten(subjects_s1_diff(13)) 
%sub-30
C14_SPM_Contrasts_4reg_nosingm_3reg_nolisten_nosingm(subjects_s1_diff(14)) 

%% Session 2 (change session parameter to ses-002 in the corresponding SPM function)
%sub-03 & sub-05 & sub-07
C4_SPM_Contrasts_4reg_incorrect(subjects_s2_diff([1 3 5])) 
%sub-04
C7_SPM_Contrasts_5reg_4reg_nolisten(subjects_s2_diff(2)) 
%sub-22 && sub-26
C1_SPM_Contrasts_5reg_4reg_incorrect(subjects_s2_diff([8 10])) 
%sub-06
C16_SPM_Contrasts_3reg_nolisten_nobase_4reg_incorrect(subjects_s2_diff(4))
%sub-17
C13_SPM_Contrasts_4reg_nobase(subjects_s2_diff(6))
%sub-21
C2_SPM_Contrasts_4reg_incorrect_5reg(subjects_s2_diff(7))
%sub-25
C10_SPM_Contrasts_4reg_nolisten_4reg_nosingm(subjects_s2_diff(9)) 
%sub-27
C11_SPM_Contrasts_4reg_nosinga_4reg_nobase(subjects_s2_diff(11)) 
%sub-28
C6_SPM_Contrasts_3reg_nolisten_nobase(subjects_s2_diff(12)) 
%sub-30
C5_SPM_Contrasts_4reg_nolisten(subjects_s2_diff(13)) 

%% Session 3 (change session parameter to ses-003 in the corresponding SPM function)
%sub-02
C2_SPM_Contrasts_4reg_incorrect_5reg(subjects_s3_diff(1)) 
%sub-07 & sub-26
C4_SPM_Contrasts_4reg_incorrect(subjects_s3_diff([2 8])) 
%sub-22 & sub-23
C1_SPM_Contrasts_5reg_4reg_incorrect(subjects_s3_diff([6 7])) 
%sub-27
C9_SPM_Contrasts_4reg_nolisten_4reg_nobase(subjects_s3_diff(9)) 
%sub-28
C15_SPM_Contrasts_3reg_nolisten_nobase_4reg_nobase(subjects_s3_diff(10))
%sub-30
C5_SPM_Contrasts_4reg_nolisten(subjects_s3_diff(11))

