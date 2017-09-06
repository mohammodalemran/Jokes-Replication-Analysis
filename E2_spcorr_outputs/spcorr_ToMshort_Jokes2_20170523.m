%This script calculates per-subject spatial correlations between runs of activation in
%multiple runs of the same set of parcels. In this case, we use it to check
%localizer quality by looking at within-task correlation for participants
%who did (at least 2 runs of) that task on the day of the critical session.

%%%
%mk addition! Add the version of spm that you intend to use right here, possibly
addpath('/users/evelina9/fMRI_PROJECTS/spm_ss_vE/') %The usual one

experiments(1)=struct(...
    'name','ToMshort',...% localizer 
    'pwd1','/mindhive/evlab/u/Shared/SUBJECTS',...  % path to the data directory
    'pwd2','firstlevel_ToMshort',... % path to the first-level analysis directory for the lang localizer
    'data',{{ ... %These are the subjects who did TWO RUNS OF ToMLoc during the critical session
        '521_FED_20161228a_3T2', ...
        '473_FED_20170210b_3T2', ...
        '551_FED_20170412a_3T2', ...
        '555_FED_20170426c_3T2', ...
        '577_FED_20170414c_3T2', ...
        '578_FED_20170414d_3T2', ...
        '596_FED_20170426b_3T2', ...
        '576_FED_20170414b_3T2', ...
        '498_FED_20170210c_3T2', ...
        '571_FED_20170412c_3T2'
        }});
experiments(2)=struct(...
    'name','ToMshort',...% localizer 
    'pwd1','/mindhive/evlab/u/Shared/SUBJECTS',...  % path to the data directory
    'pwd2','firstlevel_ToMshort',...  % path to the first-level analysis directory for the critical task
    'data',{{ ... %These are the subjects who did TWO RUNS OF ToMLoc during the critical session
        '521_FED_20161228a_3T2', ...
        '473_FED_20170210b_3T2', ...
        '551_FED_20170412a_3T2', ...
        '555_FED_20170426c_3T2', ...
        '577_FED_20170414c_3T2', ...
        '578_FED_20170414d_3T2', ...
        '596_FED_20170426b_3T2', ...
        '576_FED_20170414b_3T2', ...
        '498_FED_20170210c_3T2', ...
        '571_FED_20170412c_3T2'
        }});

localizer_spmfiles={};
for nsub=1:length(experiments(1).data),
    localizer_spmfiles{nsub}=fullfile(experiments(1).pwd1,experiments(1).data{nsub},experiments(1).pwd2,'SPM.mat');
end

effectofinterest_spmfiles={};
for nsub=1:length(experiments(1).data),
    effectofinterest_spmfiles{nsub}=fullfile(experiments(1).pwd1,experiments(1).data{nsub},experiments(1).pwd2,'SPM.mat');
end

bcc=struct(...
    'swd',['/mindhive/evlab/u/mekline/Documents/Projects/Jokes_Study2/Jokes_Replication_Repo/spcorr/spcorr_results_' experiments(1).name],...   % output directory
    'EffectOfInterest1_spm',{effectofinterest_spmfiles},...
    'EffectOfInterest2_spm',{localizer_spmfiles},...
    'EffectOfInterest1_contrasts',{{'bel-pho'}},...    % contrasts of interest
	'EffectOfInterest2_contrasts',{{'bel-pho'}},... % localizer contrast 
    'ManualROIs','/users/evelina9/fMRI_PROJECTS/ROIS/ToMparcels_Mar2015.img',...
    'model',1,...                                           % can be 1 (one-sample t-test), 2 (two-sample t-test), or 3 (multiple regression)
    'ask','missing', ...
    'ExplicitMasking', []); % can be 'none' (any missing information is assumed to take default values), 'missing' (any missing information will be asked to the user), 'all' (it will ask for confirmation on each parameter)
bcc=spm_bcc_design(bcc);  % see help spm_ss_design for additional information
bcc=spm_bcc_estimate(bcc);