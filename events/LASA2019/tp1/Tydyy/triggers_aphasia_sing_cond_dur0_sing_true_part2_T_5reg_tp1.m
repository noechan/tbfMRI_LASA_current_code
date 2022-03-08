clear all
file_path='\\Neuro_NAS\homes\nomamoli\LASA_project\archive\Preprocessing\LASA2019\';
data_path='G:\Aphasia_project\Recordings\LASA2019\Noise_reduction\Tydyy\';
aux= ls(data_path);
fnames=aux([3:end-1],:);
for sub=7%14:length(fnames)
    %sub 1 (ID135) & 8 (ID145) & 13 (ID153) all sing memo false... 
    ...5 (ID139) &7 (ID142) all listen false, 6 (ID140) all trials correct ...
    ...11 (ID149) all listen and sing memo false
    ...10(ID148) all listen and baseline false 
    clearvars -except file_path data_path aux fnames sub
        %% Load corrected trials
    sub_path1=fullfile(data_path,(fnames(sub,:)),[(fnames(sub,:)) '_1']);
    cd (sub_path1)
    if sub~=10 
    load(['baseline_true_index_Tydyy_' [(fnames(sub,:)) '_1'] '.mat'])
    end
    if sub~=5 && sub~=7 && sub~=10 && sub~=11
    load(['listen_true_index_Tydyy_' [(fnames(sub,:)) '_1'] '.mat'])
    end
    load(['sing_along_true_index_Tydyy_' [(fnames(sub,:)) '_1'] '.mat'])
    if sub~=1 && sub~=8 && sub~=11 && sub~=13 
    load(['sing_memo_true_index_Tydyy_' [(fnames(sub,:)) '_1'] '.mat'])
    end

    sub_path2=fullfile(file_path,(fnames(sub,:)),[(fnames(sub,:)) '_1'], 'func');
    cd(sub_path2)
    trigger_path=fullfile(sub_path2, 'Triggers');
    cd (trigger_path)
    load ('aphasia_sing_conditions_Tydyy_dur0_explbase.mat')
     %% Calculate correct trials onsets and durations
     if sub~=5 && sub~=7 && sub~=10 && sub~=11 
         dur_lis=zeros(1,length(listen_true_index));
         for i=1:length(listen_true_index)
             onsets_lis(1,i)=onsets{1,1} (1,listen_true_index(i));
         end
     end
    
    dur_singa=zeros(1,length(sing_along_true_index));
    for j=1:length(sing_along_true_index)
        onsets_singa(1,j)=onsets{1,2} (1,sing_along_true_index(j));
    end
    if sub~=1 && sub~=8 && sub~=11 && sub~=13  
        dur_singm=zeros(1,length(sing_memo_true_index));
        for k=1:length(sing_memo_true_index)
            onsets_singm(1,k)=onsets{1,3} (1,sing_memo_true_index(k));
        end
    end
    
    if sub~=10
        dur_base=zeros(1,length(baseline_true_index));
        for l=1:length(baseline_true_index)
            onsets_base(1,l)=onsets{1,4} (1,baseline_true_index(l));
        end
    end
    
    %% Calculate missed trial onsets and durations
    
  check30=(1:1:30)';check20=(1:1:20)';
  if sub~=5 && sub~=6 && sub~=7 && sub~=10 && sub~=11 
      lis_missed_idx=setxor(check30, listen_true_index);
  end
  if sub~=6
  singa_missed_idx=setxor(check30, sing_along_true_index);
  end
  if sub~=1 && sub~=6 && sub~=8 && sub~=11 && sub~=13
      singm_missed_idx=setxor(check30, sing_memo_true_index);
  end
  if sub~=6 && sub~=10
      base_missed_idx=setxor(check20, baseline_true_index);
  end
  
  if sub~=5 && sub~=6 && sub~=7 && sub~=10 && sub~=11 
      if ~isempty(lis_missed_idx)
          for ii=1:length(lis_missed_idx)
              missed_onsets_lis (1,ii)=onsets{1,1} (1,lis_missed_idx(ii));
          end
          missed_duration_lis=zeros(1,length(lis_missed_idx));
          s.missed_onsets_lis= missed_onsets_lis;
      end
  else
      missed_duration_lis=zeros(1,30);
      s.missed_onsets_lis= onsets{1,1};
  end
  
  if sub~=6
  if ~isempty(singa_missed_idx)
      for jj=1:length(singa_missed_idx)
          missed_onsets_singa(1,jj)=onsets{1,2} (1,singa_missed_idx(jj));
      end
       missed_duration_singa=zeros(1,length(singa_missed_idx));
      s.missed_onsets_singa=missed_onsets_singa;
  end
  end
  
  if sub~=1 && sub~=6 && sub~=8 && sub~=11 && sub~=13  
  if ~isempty(singm_missed_idx)
      for kk=1:length(singm_missed_idx)
          missed_onsets_singm(1,kk)=onsets{1,3} (1,singm_missed_idx(kk));
      end
      missed_duration_singm=zeros(1,length(singm_missed_idx));
      s.missed_onsets_singm=missed_onsets_singm;
  end
  else
      missed_duration_singm=zeros(1,30);
      s.missed_onsets_singm=onsets{1,3};
  end
  if sub~=6 && sub~=10
      if ~isempty(base_missed_idx)
          for ll=1:length(base_missed_idx)
              missed_onsets_base(1,ll)=onsets{1,4} (1,base_missed_idx(ll));
          end
          missed_duration_base=zeros(1,length(base_missed_idx));
          s.missed_onsets_base=missed_onsets_base;
      end
  else
      missed_duration_base=zeros(1,20);
      s.missed_onsets_base=onsets{1,4};
  end
  if ~isempty(s)
      ss=struct2cell(s);
      for iii=1:size(ss,1)
          ss{iii,1}=ss{iii,1}';
      end
      missed_onsets_all=sortrows(vertcat(ss{1:end,1}));
      missed_dur_all=zeros(1,length(missed_onsets_all));
  end
  clear onsets durations names s
  if sub~=1 && sub~=5 && sub~=6 && sub~=7 && sub~=8 && sub~=10 && sub~=11 && sub~=13
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; names{5}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; onsets{1,5}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; durations{1,5}= missed_dur_all;
      cd (trigger_path)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_5reg.mat','names','onsets','durations');
  elseif sub==1 || sub==8 || sub==13
      names{1}='listen';names{2}='singalong';names{3}='baseline'; names{4}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_base; onsets{1,4}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
      cd(trigger_path)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
  elseif sub==5 || sub==7
      names{1}='singalong';names{2}='singmem'; names{3}='baseline'; names{4}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm;onsets{1,3}=onsets_base; onsets{1,4}=missed_onsets_all;
      durations{1,1}=dur_singa;durations{1,2}=dur_singm; durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
      cd (trigger_path)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
  elseif sub==6
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; 
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; 
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; 
      cd (trigger_path)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
  elseif sub==11
      names{1}='singalong'; names{2}='baseline'; names{3}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_base; onsets{1,3}=missed_onsets_all;
      durations{1,1}=dur_singa;durations{1,2}=dur_base; durations{1,3}= missed_dur_all;
      cd (trigger_path)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_3reg.mat','names','onsets','durations');
  elseif sub==10 
      names{1}='singalong'; names{2}='singmem'; names{3}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm; onsets{1,3}=missed_onsets_all;
      durations{1,1}=dur_singa;durations{1,2}=dur_singm; durations{1,3}= missed_dur_all;
      cd (trigger_path)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_3reg.mat','names','onsets','durations');
  end
end

