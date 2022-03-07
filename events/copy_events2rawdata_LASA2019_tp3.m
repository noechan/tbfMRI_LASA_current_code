clear all
% Define paths and triggers' names
source_path='\\Neuro_NAS\homes\nomamoli\LASA_project\archive\Preprocessing\LASA2019\'; 
dest_path='G:\Aphasia_project\data\raw_data\';

%List patients cohort 2019 session 3
aux= ls(source_path);
names=aux([3:9 11:16],:); %ID136 Uulaa empty recordings, ID143 excluded, ID154 && ID155 && ID157 PPA, ID158 dropout

for n=10%2:length(names)
    if strcmp(names(n,:),'ID135')==1
        sub=17;
    elseif strcmp(names(n,:),'ID136')==1
        sub=18;
    elseif strcmp(names(n,:),'ID137')==1
        sub=19;
    elseif strcmp(names(n,:),'ID138')==1
        sub=20;
    elseif strcmp(names(n,:),'ID139')==1
        sub=21;
    elseif strcmp(names(n,:),'ID140')==1
        sub=22;
    elseif strcmp(names(n,:),'ID142')==1
        sub=23;
    elseif strcmp(names(n,:),'ID143')==1
        sub=24;
    elseif strcmp(names(n,:),'ID145')==1
        sub=25;
    elseif strcmp(names(n,:),'ID146')==1
        sub=26;
    elseif strcmp(names(n,:),'ID148')==1
        sub=27;
    elseif strcmp(names(n,:),'ID149')==1
        sub=28;
    elseif strcmp(names(n,:),'ID150')==1
        sub=29;
    elseif strcmp(names(n,:),'ID153')==1
        sub=30;
    elseif strcmp(names(n,:),'ID158')==1
        sub=34;
    end

    uulaa_events=strcat('sub-',num2str(sub),'_ses-003_task-uulaa_acq-multiband_events.mat');
    tydyy_events=strcat('sub-',num2str(sub),'_ses-003_task-tydyy_acq-multiband_events.mat');
    
    sub_path2=fullfile(dest_path, ['sub-' num2str(sub)],'ses-003','derivatives', 'SPM_prepro','func','events');
    
    sub_path1=fullfile(source_path, (names(n,:)), [(names(n,:)) '_3'], 'Triggers');
    cd(sub_path1)

    Uulaa=ls('*Uulaa*'); Tydyy=ls('*Tydyy*');
    if sub~=18
        for i=1:size(Uulaa,1)
            uulaa_source=char(regexp(Uulaa(i,:), '.*reg.*', 'match'));
            if ~isempty(uulaa_source)
                break
            end
        end
        copyfile(fullfile(sub_path1,uulaa_source), fullfile(sub_path2,uulaa_events))
    end
   
    if sub~=17
        for j=1:size(Tydyy,1)
            tydyy_source= char(regexp(Tydyy(j,:), '.*reg.*', 'match'));
            if ~isempty(tydyy_source)
                break
            end
        end
        copyfile(fullfile(sub_path1,tydyy_source), fullfile(sub_path2,tydyy_events))
    end
    
end



