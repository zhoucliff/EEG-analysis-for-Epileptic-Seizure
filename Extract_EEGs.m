clc;clear
%% 1. Load data and extract EEGs
datapath = 'G:\EEG data\chb01';
sz_files = {'chb01_03.edf', 'chb01_04.edf', 'chb01_15.edf', ...
    'chb01_16.edf', 'chb01_18.edf', 'chb01_21.edf', 'chb01_26.edf'}; %sz files
t_starts = [2996, 1467, 1732, 1015, 1720, 327, 1862];
t_ends = [3036, 1494, 1772, 1066, 1810, 420, 1963];
ctrls_sz = cell(length(sz_files), 1);    % non-sz data in sz_files
seizs = cell(length(sz_files), 1);      % sz data

% loda seizures and controls in sz_files
for k = 1:length(sz_files)
    f = edfread(fullfile(datapath, sz_files{k}));
    seizs{k} = [f{t_starts(k):t_ends(k), :}];
    ctrls_sz{k} = [f{1:t_starts(k)-1, :}; f{t_ends(k)+1:end, :}];
    % % reshape cells (T, Channels) to array (T*fs, Channels)
    % sz_samples = reshape(cat(1, seizs{k}{:}), [], 23);
end

% files = dir(fullfile(datapath,'*.edf'));
% ctrls = cell(length(files), 1);         % non-sz data in all files
% j = 1;
% % load controls in all files
% for k = 1:length(files)
%     if ismember(files(k).name, sz_files)
%         ctrls{k} = ctrls_sz{j};
%         j = j + 1;
%     else
%         f = edfread(fullfile(datapath, files(k).name));
%         ctrls{k} = [f{:, :}];
%     end
% end

% For the warnings: SignalLabels 15 and 23 are same.
clc;
save('seizs.mat', 'seizs')
save('ctrls_sz.mat', 'ctrls_sz')
%save('ctrls.mat', 'ctrls')

