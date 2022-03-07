clear all
% Define paths and triggers' names
source_path='\\Neuro_NAS\homes\nomamoli\LASA_project\archive\Preprocessing\LASA2017\'; 
dest_path='G:\Aphasia_project\data\raw_data\';

%List patients cohort 2017 session 3
aux= ls(source_path);
names=aux([3:5 7:13 15:16 18],:);% sub4(ID109) sub12(ID123) & sub15(ID128) 17 dropouts; 

for n=5%:length(names)
    if strcmp(names(n,:),'ID102')==1
        sub=1;
    elseif strcmp(names(n,:),'ID104')==1
        sub=2;
    elseif strcmp(names(n,:),'ID106')==1
        sub=3;
    elseif strcmp(names(n,:),'ID109')==1
        sub=4;
    elseif strcmp(names(n,:),'ID110')==1
        sub=5;
    elseif strcmp(names(n,:),'ID112')==1
        sub=6;
    elseif strcmp(names(n,:),'ID113')==1
        sub=7;
    elseif strcmp(names(n,:),'ID114')==1
        sub=8;
    elseif strcmp(names(n,:),'ID116')==1
        sub=9;
    elseif strcmp(names(n,:),'ID121')==1
        sub=10;
    elseif strcmp(names(n,:),'ID122')==1
        sub=11;
    elseif strcmp(names(n,:),'ID123')==1
        sub=12;
    elseif strcmp(names(n,:),'ID124')==1
        sub=13;
    elseif strcmp(names(n,:),'ID127')==1
        sub=14;
    elseif strcmp(names(n,:),'ID128')==1
        sub=15;
    elseif strcmp(names(n,:),'ID134')==1
        sub=16;
    end

    if sub<=9
        uulaa_events=strcat('sub-0',num2str(sub),'_ses-003_task-uulaa_acq-multiband_events.mat');
        tydyy_events=strcat('sub-0',num2str(sub),'_ses-003_task-tydyy_acq-multiband_events.mat');
    else
        uulaa_events=strcat('sub-',num2str(sub),'_ses-003_task-uulaa_acq-multiband_events.mat');
        tydyy_events=strcat('sub-',num2str(sub),'_ses-003_task-tydyy_acq-multiband_events.mat');
    end
    
    if sub<=9
        sub_path2=fullfile(dest_path, ['sub-0' num2str(sub)],'ses-003','derivatives', 'SPM_prepro','func','events');
    else
        sub_path2=fullfile(dest_path, ['sub-' num2str(sub)],'ses-003','derivatives', 'SPM_prepro','func','events');
    end
    
    sub_path1=fullfile(source_path, (names(n,:)), [(names(n,:)) '_3'], 'func','Triggers');
    cd(sub_path1)

    Uulaa=ls('*Uulaa*'); Tydyy=ls('*Tydyy*');
        for i=1:size(Uulaa,1)
            uulaa_source=char(regexp(Uulaa(i,:), '.*reg.*', 'match'));
            if ~isempty(uulaa_source)
                break
            end
        end
        copyfile(fullfile(sub_path1,uulaa_source), fullfile(sub_path2,uulaa_events))
   

        for j=1:size(Tydyy,1)
            tydyy_source= char(regexp(Tydyy(j,:), '.*reg.*', 'match'));
            if ~isempty(tydyy_source)
                break
            end
        end
        copyfile(fullfile(sub_path1,tydyy_source), fullfile(sub_path2,tydyy_events))
 
    
end
