
experiments(1)=struct(...
    'name','loc',...% ToM (reg) 
    'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...
    'pwd2','firstlevel_ToMshort',...
    'data',{{ ...
        '288_FED_20160411a_3T1',...
    '301_FED_20150708c_3T2',...
    '426_FED_20161107c_3T2',...
    '430_FED_20170110b_3T2',...
    '555_FED_20170426c_3T2',...
    '576_FED_20170414b_3T2',...
    '577_FED_20170414c_3T2',...
    '334_FED_20160204c_3T2',...
    '343_FED_20160204b_3T2',...
    '521_FED_20161228a_3T2',...
    '551_FED_20170412a_3T2',...
    '571_FED_20170412c_3T2',...
    '520_FED_20161227a_3T2',...
    '596_FED_20170426b_3T2'
        }}); % subject IDs
experiments(2)=struct(...
    'name','crit',...% non-lang expt
    'pwd1','/mindhive/evlab/u/Shared/SUBJECTS/',...
    'pwd2','firstlevel_ToMshort',...
    'data',{{ ...
        '288_FED_20160411a_3T1',...
    '301_FED_20150708c_3T2',...
    '426_FED_20161107c_3T2',...
    '430_FED_20170110b_3T2',...
    '555_FED_20170426c_3T2',...
    '576_FED_20170414b_3T2',...
    '577_FED_20170414c_3T2',...
    '334_FED_20160204c_3T2',...
    '343_FED_20160204b_3T2',...
    '521_FED_20161228a_3T2',...
    '551_FED_20170412a_3T2',...
    '571_FED_20170412c_3T2',...
    '520_FED_20161227a_3T2',...
    '596_FED_20170426b_3T2'
        }}); % subject IDs

exp1_spmfiles={};
for nsub=1:length(experiments(1).data),
    exp1_spmfiles{nsub}=fullfile(experiments(1).pwd1,experiments(1).data{nsub},experiments(1).pwd2,'SPM.mat');
end

exp2_spmfiles={};
for nsub=1:length(experiments(2).data),
    exp2_spmfiles{nsub}=fullfile(experiments(2).pwd1,experiments(2).data{nsub},experiments(2).pwd2,'SPM.mat');
end

ss=struct(...
    'swd','/mindhive/evlab/u/mekline/Documents/Projects/Jokes_Study2/Jokes_Replication_Repo/E2_voxel_overlap/ToMfROIs_voxcount_ToMfROIs_20180226/',...   % output directory
    'Localizer_spm',{cat(1,exp1_spmfiles,exp2_spmfiles)},...
    'Localizer_contrasts',{{'bel-pho','bel-pho'}},...               % localizer contrasts (overlap will be computed across these contrasts)
    'Localizer_thr_type',{{'percentile-ROI-level','percentile-ROI-level'}},...
    'Localizer_thr_p',[.1,.1],... 	  
    'ExplicitMasking',[],...   
	'overwrite',true,...                             
    'ManualROIs','/users/evelina9/fMRI_PROJECTS/ROIS/ToMparcels.img',...
    'ask','missing');
    
if isempty(which('spm')), addpath /software/spm12; end
if isempty(which('spm_ss')), addpath /software/spm_ss; end
addpath /software/spm12; 
addpath /software/spm_ss; 

ss=spm_ss_overlap(ss);                                      % see help spm_ss_overlap for additional information





