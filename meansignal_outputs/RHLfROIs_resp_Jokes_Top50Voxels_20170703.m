%Before running you should make sure that you are using the correct version of the
%SPM toolbox if it is something other than the standard. I've moved all the common parameters we 
%usually set up to the top of the script; anything else you want you can
%change in the big struct if you want something else. It also assumes you'll provide a parcel file
%(manual ROI option)

%Some explanations:
%'swd' output folder for the results -DONT FORGET TO CHANGE THIS!!
%'EffectOfInterest_contrasts' - All or anything of the first-level cons that were calculated before
%'Localizer_contrasts' - Usually just one! How are you finding the subject-specific region.
%'Localizer_thr_type' and 'Localizer_thr_p' Various choices here: 
%   For top 10% of voxels found in the parcels: 'percentile-ROI-level' and .1
%   For top N voxels: 'Nvoxels-ROI-level' and 50 (for 50 voxels)
%'type' and 'ManualROIs' - the parcels to find the subject-specific activations in!  Usually we
%set 'type'='mROI', and then specify the path to the parcel you want to use. It will be an img file.

%TODO in this file
% Any kind of asserts for well formed input
% Give the general case for fullfiling all the paths (this assumes all 1st level data
% is in the same place)

%%%
%SET ALL FILEPATHS AND EXP INFO HERE 
DataFolder = '/mindhive/evlab/u/Shared/SUBJECTS/'; % path to the data directory
MyOutputPath = '/mindhive/evlab/u/mekline/Documents/Projects/Jokes_Study2/Jokes_Replication_Repo/meansignal_outputs/'; %Where should the results wind up? For testing this script, this is all u need to change and it should just work! Note: usually the scripts are good about this but this one actually does break if you put a slash at the end of your dir name.
MyOutputFolder = [MyOutputPath 'RHLfROIs_resp_Jokes_Top50Voxels_20170703']; %Change to match this analysis!!



firstlevel_loc = 'firstlevel_langlocSN'; % path to the first-level analysis directory for the lang localizer or whatever
firstlevel_crit = 'firstlevel_Jokes'; %path to 1st-level analysis directory for the critical task


loc_cons = {{'S-N'}}; %Which contrast used to localize issROIs?
crit_cons = {{'joke','lit','joke-lit'}}; %Effect of interest contrasts: cons of the crit. experiment do we want to measure there? It could be the same as the loc! In that case SPM will make ur data independent for you :)

what_parcels = '/users/evelina9/fMRI_PROJECTS/ROIS/LangParcels_n220_RH.img'; %specify the full path to the *img or *nii file that will constrain the search for top voxels

thresh_type = 'Nvoxels-ROI-level'; %percentile-ROI-level or Nvoxels-ROI-level
thresh_p = 50; %Fun fact! In percentile mode, p=proportion (.1=%10), In top-n mode p = n voxels (eg 50)

%Make sure participants are in the same order for loc and crit!!!!!!
loc_sessions = {{'168_KAN_evDB_20141020b',....
}}; %The subject IDs of individual subjects you'll analyze

%crit_sessions would be the same as loc_sessions if all localizers conducted on the same day
crit_sessions = {{'168_FED_20161228b_3T2',...
}};



%%%
%STANDARD TOOLBOX SPECS BELOW
%%%
%Specify the first level data that will be used for the loc (find the space) and crit (measure it)

experiments(1)=struct(...
    'name','loc',...% language localizer 
    'pwd1',DataFolder,...  % path to the data directory
    'pwd2',firstlevel_loc,...
    'data', loc_sessions); % subject IDs
experiments(2)=struct(...
    'name','crit',...% non-lang expt
    'pwd1',DataFolder,...
    'pwd2',firstlevel_crit,...  % path to the first-level analysis directory for the critical task
    'data', crit_sessions);
%%%

localizer_spmfiles={};
for nsub=1:length(experiments(1).data),
    localizer_spmfiles{nsub}=fullfile(experiments(1).pwd1,experiments(1).data{nsub},experiments(1).pwd2,'SPM.mat');
end

effectofinterest_spmfiles={};
for nsub=1:length(experiments(2).data),
    effectofinterest_spmfiles{nsub}=fullfile(experiments(2).pwd1,experiments(2).data{nsub},experiments(2).pwd2,'SPM.mat');
end

%%%%
%Specify the analysis that you will run. See above for a list of things
%definitely to check/modify!!!

ss=struct(...
    'swd', MyOutputFolder,...   % output directory
    'EffectOfInterest_spm',{effectofinterest_spmfiles},...
    'Localizer_spm',{localizer_spmfiles},...
	'EffectOfInterest_contrasts', crit_cons,...    % contrasts of interest
    'Localizer_contrasts',loc_cons,...                     % localizer contrast 
    'Localizer_thr_type',thresh_type,...
    'Localizer_thr_p',thresh_p,... 
    'type','mROI',...                                       % can be 'GcSS', 'mROI', or 'voxel'
    'ManualROIs', what_parcels,...
    'model',1,...                                           % can be 1 (one-sample t-test), 2 (two-sample t-test), or 3 (multiple regression)
    'estimation','OLS',...
    'overwrite',true,...
    'ExplicitMasking',[],... %No explicit mapping and NO POPPUP in matlab :)
    'overlap_thr_vox',0,...
    'overlap_thr_roi',0,... %and the 2 mean we don't require Ss activation to overlap with each other (typically used for...excluding participants? can't remember)
    'ask','missing');                                       % can be 'none' (any missing information is assumed to take default values), 'missing' (any missing information will be asked to the user), 'all' (it will ask for confirmation on each parameter)

%%%
%mk addition! Add the version of spm that you intend to use right here, possibly
%addpath('/users/evelina9/fMRI_PROJECTS/spm_ss_vE/') %The usual one
addpath('users/evelina9/fMRI_PROJECTS/spm_ss_Jun18-2015/') %This one has the N-top-voxels options (?)

%%%
%...and now SPM actually runs!
ss=spm_ss_design(ss);                                          % see help spm_ss_design for additional information
ss=spm_ss_estimate(ss);

%%%
%USEFUL INFO!
%%%

% Parcels 
% '/users/evelina9/fMRI_PROJECTS/ROIS/LangParcels_n220_LH.img' - the standard Lang parcels, use contrast {{'S-N'}} 
% '/users/evelina9/fMRI_PROJECTS/ROIS/MDfROIs.img' - the standard MD parcels, use contrast {{'H-E'}}
% '/users/evelina9/fMRI_PROJECTS/ROIS/ToMparcels_Mar2015.img'; - the 'new'
% ToM parcels, uses bel-pho




