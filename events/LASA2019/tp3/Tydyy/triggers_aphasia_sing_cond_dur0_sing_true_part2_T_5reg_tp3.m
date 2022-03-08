clear all
file_path='\\Neuro_NAS\homes\nomamoli\LASA_project\archive\Preprocessing\LASA2019\';
data_path='G:\Aphasia_project\Recordings\LASA2019\Noise_reduction\Tydyy\';
aux= ls(file_path);
fnames=aux([3:9 11:16],:);% ID143 excluded, ID154 && ID155 && ID157 PPA, ID158 dropout
for sub=10
    %sub1 (ID135) wrong recordings, sub2(ID136) some lis, base, singa &
    %singm false, sub3(ID137) wrong recordings, sub4(ID138) some lis false,
    %sub5(ID139) some lis, singa, singm false; sub6(ID140)some lis false,
    %sub7(ID142) some lis false, sub8(ID145) some singm false, sub9(D146)
    %all trials true, sub10(ID148) some base false, all lis false, sub11(ID149) all base and lis false, sub12(ID150)
    %some lis false, sub 13(ID153) some singm false, all lis false
    clearvars -except file_path data_path aux fnames sub
        %% Load corrected trials
    sub_path1=fullfile(data_path,(fnames(sub,:)),[(fnames(sub,:)) '_3']);
    sub_path2=fullfile(file_path,(fnames(sub,:)),[(fnames(sub,:)) '_3'], 'Triggers\');
    cd (sub_path1)
    if sub~= 11
    load(['baseline_true_index_Tydyy_' (fnames(sub,:)) '.mat'])
    end
    if sub~=10 && sub~=11 && sub~=13
    load(['listen_true_index_Tydyy_' (fnames(sub,:)) '.mat'])
    end
    load(['sing_along_true_index_Tydyy_' (fnames(sub,:)) '.mat'])
    load(['sing_memo_true_index_Tydyy_' (fnames(sub,:)) '.mat'])
    cd (sub_path2)
    load ('aphasia_sing_conditions_Tydyy_dur0_explbase.mat')
     %% Calculate correct trials onsets and durations
     if sub~=10 && sub~=11 && sub~=13
         onsets_lis=zeros(1,length(listen_true_index));
         dur_lis=zeros(1,length(listen_true_index));
         for i=1:length(listen_true_index)
             onsets_lis(1,i)=onsets{1,1} (1,listen_true_index(i));
         end
     end
    
    onsets_singa=zeros(1,length(sing_along_true_index));
    dur_singa=zeros(1,length(sing_along_true_index));
    for j=1:length(sing_along_true_index)
        onsets_singa(1,j)=onsets{1,2} (1,sing_along_true_index(j));
    end
    
    onsets_singm=zeros(1,length(sing_memo_true_index));
    dur_singm=zeros(1,length(sing_memo_true_index));
    for k=1:length(sing_memo_true_index)
        onsets_singm(1,k)=onsets{1,3} (1,sing_memo_true_index(k));
    end
    
    if sub~=11
        onsets_base=zeros(1,length(baseline_true_index));
        dur_base=zeros(1,length(baseline_true_index));
        for l=1:length(baseline_true_index)
            onsets_base(1,l)=onsets{1,4} (1,baseline_true_index(l));
        end
    end
    
    %% Calculate missed trial onsets and durations
    
  check30=(1:1:30)';check20=(1:1:20)';
  if sub~=10 && sub~=11 && sub~=13
      lis_missed_idx=setxor(check30, listen_true_index);
  end
  singa_missed_idx=setxor(check30, sing_along_true_index);
  singm_missed_idx=setxor(check30, sing_memo_true_index);
  if sub~=11
      base_missed_idx=setxor(check20, baseline_true_index);
  end
  
  if sub~=10 && sub~=11 && sub~=13
      if ~isempty(lis_missed_idx)
          for ii=1:length(lis_missed_idx)
              missed_onsets_lis (1,ii)=onsets{1,1} (1,lis_missed_idx(ii));
          end
          missed_duration_lis=zeros(1,length(lis_missed_idx));
          s.missed_onsets_lis= missed_onsets_lis;
      end
  elseif sub==10  || sub==11  || sub==13
      missed_duration_lis=zeros(1,30);
      s.missed_onsets_lis=onsets{1,1};
  end
  
  if ~isempty(singa_missed_idx)
      for jj=1:length(singa_missed_idx)
          missed_onsets_singa(1,jj)=onsets{1,2} (1,singa_missed_idx(jj));
      end
       missed_duration_singa=zeros(1,length(singa_missed_idx));
      s.missed_onsets_singa=missed_onsets_singa;
  end
  if ~isempty(singm_missed_idx)
      for kk=1:length(singm_missed_idx)
          missed_onsets_singm(1,kk)=onsets{1,3} (1,singm_missed_idx(kk));
      end
      missed_duration_singm=zeros(1,length(singm_missed_idx));
      s.missed_onsets_singm=missed_onsets_singm;
  end
  
  if sub~=11
      if ~isempty(base_missed_idx)
          for ll=1:length(base_missed_idx)
              missed_onsets_base(1,ll)=onsets{1,4} (1,base_missed_idx(ll));
          end
          missed_duration_base=zeros(1,length(base_missed_idx));
          s.missed_onsets_base=missed_onsets_base;
      end
  elseif sub==11
      missed_duration_base=zeros(1,20);
      s.missed_onsets_base=onsets{1,4};
  end
  
  if sub~=9
      if ~isempty(s)
          ss=struct2cell(s);
          for iii=1:size(ss,1)
              ss{iii,1}=ss{iii,1}';
          end
          missed_onsets_all=sortrows(vertcat(ss{1:end,1}));
          missed_dur_all=zeros(1,length(missed_onsets_all));
      end
  end
  clear onsets durations names s
  
  if sub~=9 && sub~=10 && sub~=11 && sub~=13
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; names{5}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; onsets{1,5}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; durations{1,5}= missed_dur_all;
      save([sub_path2 'aphasia_sing_conditions_Tydyy_dur0_expl_base_5reg.mat'],'names','onsets','durations');
  elseif sub==9
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base;
      save([sub_path2 'aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat'],'names','onsets','durations');
  elseif sub==10 || sub==13
      names{1}='singalong';names{2}='singmem'; names{3}='baseline'; names{4}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm;onsets{1,3}=onsets_base; onsets{1,4}=missed_onsets_all;
      durations{1,1}=dur_singa;durations{1,2}=dur_singm; durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
      save([sub_path2 'aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat'],'names','onsets','durations');
  elseif sub==11
      names{1}='singalong'; names{2}='singmem'; names{3}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm; onsets{1,3}=missed_onsets_all;
      durations{1,1}=dur_singa;durations{1,2}=dur_singm; durations{1,3}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_3reg.mat','names','onsets','durations');
  end
end

