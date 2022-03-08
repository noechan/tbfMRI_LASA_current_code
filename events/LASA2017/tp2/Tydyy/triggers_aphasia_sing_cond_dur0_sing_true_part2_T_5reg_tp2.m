clear all
file_path='\\Neuro_NAS\homes\nomamoli\LASA_project\archive\Preprocessing\LASA2017\';
data_path='G:\Aphasia_project\Recordings\LASA2017\Noise_reduction\Tydyy\';
aux= ls(file_path);
fnames=aux(3:end,:);
for sub=16
    %sub1(ID102) some singm false; sub2(ID104) some singa & singm false;
    ...sub3(ID106) all trials correct, sub4(ID109) some lis, singa && singm false, all
    ...lis false, sub5(ID110) all trials correct, sub6(ID112) all base &&
    ...lis false, sub7(ID113) all trials correct, sub8(ID114) some lis & singa false,
    ...sub9(ID116) some lis, singa && singm false,
    ...sub10(ID121) some base false, sub11(ID122) some lis, singa & singm false,
    ...sub12(ID123) some base, lis & singa false, sub13(ID124) some 
    ...singa && singm false, sub14(ID127) some lis, singa && singm
    ...false, sub15(ID128) some lis false, sub16(ID134) some lis
    ...false
    clearvars -except file_path data_path aux fnames sub
        %% Load corrected trials
    sub_path1=fullfile(data_path,(fnames(sub,:)),[(fnames(sub,:)) '_2']);
    sub_path2=fullfile(file_path,(fnames(sub,:)),[(fnames(sub,:)) '_2'], 'func','Triggers');
    cd (sub_path1)
    if sub~=6
    load(['baseline_true_index_Tydyy_' (fnames(sub,:)) '.mat'])
    end
    if sub~=6
    load(['listen_true_index_Tydyy_' (fnames(sub,:)) '.mat'])
    end
    load(['sing_along_true_index_Tydyy_' (fnames(sub,:)) '.mat'])
    load(['sing_memo_true_index_Tydyy_' (fnames(sub,:)) '.mat'])
    cd (sub_path2) 
    load ('aphasia_sing_conditions_Tydyy_dur0_explbase.mat')
     %% Calculate correct trials onsets and durations
     if sub~=6
         onsets_listen=zeros(1,length(listen_true_index));
         dur_lis=zeros(1,length(listen_true_index));
         for i=1:length(listen_true_index)
             onsets_lis(1,i)=onsets{1,1} (1,listen_true_index(i));
         end
     end
    
    onsets_singal=zeros(1,length(sing_along_true_index));
    dur_singa=zeros(1,length(sing_along_true_index));
    for j=1:length(sing_along_true_index)
        onsets_singa(1,j)=onsets{1,2} (1,sing_along_true_index(j));
    end
    
    onsets_singmem=zeros(1,length(sing_memo_true_index));
    dur_singm=zeros(1,length(sing_memo_true_index));
    for k=1:length(sing_memo_true_index)
        onsets_singm(1,k)=onsets{1,3} (1,sing_memo_true_index(k));
    end
    
    if sub~=6
    onsets_base=zeros(1,length(baseline_true_index));
    dur_base=zeros(1,length(baseline_true_index));
    for l=1:length(baseline_true_index)
        onsets_base(1,l)=onsets{1,4} (1,baseline_true_index(l));
    end
    end
    
    %% Calculate missed trial onsets and durations
    
  check30=(1:1:30)';check20=(1:1:20)';
  if sub~=6
  lis_missed_idx=setxor(check30, listen_true_index);
  end
  singa_missed_idx=setxor(check30, sing_along_true_index);
  singm_missed_idx=setxor(check30, sing_memo_true_index);
  if sub~=6
  base_missed_idx=setxor(check20, baseline_true_index);
  end
  
  if sub~=6
      if ~isempty(lis_missed_idx)
          for ii=1:length(lis_missed_idx)
              missed_onsets_lis (1,ii)=onsets{1,1} (1,lis_missed_idx(ii));
          end
          missed_duration_lis=zeros(1,length(lis_missed_idx));
          s.missed_onsets_lis= missed_onsets_lis;
      end
  elseif sub==6
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
  
  if sub~=6
  if ~isempty(base_missed_idx)
      for ll=1:length(base_missed_idx)
          missed_onsets_base(1,ll)=onsets{1,4} (1,base_missed_idx(ll));
      end
      missed_duration_base=zeros(1,length(base_missed_idx));
      field='missed_onsets_base';
      s.missed_onsets_base=missed_onsets_base;
  end
    elseif sub==6
      missed_duration_base=zeros(1,20);
      s.missed_onsets_base=onsets{1,4};
  end
  
  if sub~=3 && sub~=5 && sub~=7
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
  if sub~=3 && sub~=5 && sub~=6 && sub~=7
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline'; names{5}='incorrect';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm;onsets{1,4}=onsets_base; onsets{1,5}=missed_onsets_all;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base; durations{1,5}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_5reg.mat','names','onsets','durations');
  elseif sub==3  || sub==5  || sub==7
      names{1}='listen';names{2}='singalong';names{3}='singmem'; names{4}='baseline';
      onsets{1,1}=onsets_lis;onsets{1,2}=onsets_singa;onsets{1,3}=onsets_singm; onsets{1,4}=onsets_base;
      durations{1,1}=dur_lis; durations{1,2}=dur_singa;durations{1,3}=dur_singm; durations{1,4}=dur_base;
      cd(sub_path2)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
  elseif sub==100
      names{1}='singalong';names{2}='singmem';names{3}='baseline'; names{4}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm;onsets{1,3}=onsets_base;onsets{1,4}=missed_onsets_all;
      durations{1,1}=dur_singa; durations{1,2}=dur_singm;durations{1,3}=dur_base; durations{1,4}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_4reg.mat','names','onsets','durations');
  elseif sub==6
         names{1}='singalong';names{2}='singmem';  names{3}='incorrect';
      onsets{1,1}=onsets_singa;onsets{1,2}=onsets_singm;onsets{1,3}=missed_onsets_all;
      durations{1,1}=dur_singa;durations{1,2}=dur_singm; durations{1,3}= missed_dur_all;
      cd (sub_path2)
      save('aphasia_sing_conditions_Tydyy_dur0_expl_base_3reg.mat','names','onsets','durations');
  end
end

