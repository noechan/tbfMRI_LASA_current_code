clear all
logfile_path='G:\Aphasia_project\Logfiles\LASA2019\Uulaa\';
data_path='\\Neuro_NAS\homes\nomamoli\LASA_project\archive\Preprocessing\LASA2019\';
aux=ls(data_path);
fnames=aux([3:9 11:end],:);
name{1}='ID135_1_fMRI_singing_aphasia_Uulaa_male.log';res(1)=2;
name{2}='ID136_1_fMRI_singing_aphasia_Uulaa_female.log';res(2)=2;
name{3}='ID137_1_fMRI_singing_aphasia_Uulaa_male.log';res(3)=2;
name{4}='ID138_1_fMRI_singing_aphasia_Uulaa_female.log';res(4)=2;
name{5}='ID139_1_fMRI_singing_aphasia_Uulaa_male.log';res(5)=2;
name{6}='ID140_1_fMRI_singing_aphasia_Uulaa_male.log';res(6)=2;
name{7}='ID142_1_fMRI_singing_aphasia_Uulaa_male.log';res(7)=2;
name{8}='ID145_1_fMRI_singing_aphasia_Uulaa_female.log';res(8)=2;
name{9}='ID146_1_fMRI_singing_aphasia_Uulaa_female.log';res(9)=2;
name{10}='ID148_1_fMRI_singing_aphasia_Uulaa_male.log';res(10)=2;
name{11}='ID149_1_fMRI_singing_aphasia_Uulaa_male.log';res(11)=2;
name{12}='ID150_1_fMRI_singing_aphasia_Uulaa_female.log';res(12)=2;
name{13}='ID153_1_fMRI_singing_aphasia_Uulaa_male.log';res(13)=2;
name{14}='ID154_1_fMRI_singing_aphasia_Uulaa_female.log';res(14)=2;
name{15}='ID155_1_fMRI_singing_aphasia_Uulaa_female.log';res(15)=2;
name{16}='ID157_1_fMRI_singing_aphasia_Uulaa_female.log';res(16)=2;
name{17}='ID158_1_fMRI_singing_aphasia_Uulaa_male.log';res(17)=2;
name{18}='ID159_1_fMRI_singing_aphasia_Uulaa_female.log';res(18)=2;

for s=2:length(fnames)
   
        names=cell(1,4);onsets=cell(1,4);durations=cell(1,4);
        names{1}='listen';names{2}='singalong';names{3}='singmem';names{4}='baseline';
        k1=[];k2=[];k3=[];k4=[];
        d1=[];d2=[];d3=[];d4=[];
                
        nn=fullfile(logfile_path, name{s});
        [C1 C2 C3 C4 C5]=textread(nn,'%s %s %s %s %f%*[^\n]','headerlines',5);
        C5=C5-C5(res(s));%reset start time to 0
      
        for k=1:length (C5)
            if (C4{k}(1)~= '0' && (C4{k}(8))~= 'T') 
            if strcmp((C4{k}(8:11)),'lis_') 
                k1=[k1 ((C5 (k))/10000)];
                d1=[d1 0];
            elseif strcmp((C4{k}(8:11)),'phra')
                k2=[k2 ((C5(k))/10000)];
                d2=[d2 0];
            elseif strcmp((C4{k} (8:11)),'sing')
                k3=[k3 ((C5(k))/10000)];
                d3=[d3 0];
            elseif strcmp(C4{k}(8:11),'base')
                k4=[k4 ((C5(k))/10000)];
                d4=[d4 0];
            end
            end
        end
              
        onsets{1}=k1;durations{1}=d1;
        onsets{2}=k2;durations{2}=d2;
        onsets{3}=k3;durations{3}=d3;
        onsets{4}=k4;durations{4}=d4;
        

        direc=fullfile(data_path,(fnames(s,:)),[(fnames(s,:)) '_1'],'func','Triggers\');
        if ~exist(direc,'dir')
            mkdir(direc);
        end
        save([direc 'aphasia_sing_conditions_Uulaa_dur0_explbase.mat'],'names','onsets','durations');
end
