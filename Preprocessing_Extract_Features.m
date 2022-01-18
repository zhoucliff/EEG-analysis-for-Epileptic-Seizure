clc;clear;
%% 2. Preprocessinng

% 2.1 Augment and balance data
win_len = 5;    % window size for features, seconds
hop_sz = 1;     % hop length for seizures, seconds
hop_cc = 5;     % hop length for controls, seconds
load('seizs.mat')
load('ctrls_sz.mat')
% slide and cut
seqs_sz = [];   % sliced sequences of seizures
for k = 1:length(seizs)
    num = floor((size(seizs{k},1) - win_len) / hop_sz) + 1;
    seq = cell(num, 1);
    for j = 1:num
        seq{j} = seizs{k}((j-1)*hop_sz+1:(j-1)*hop_sz+win_len, :);
    end
    seqs_sz = [seqs_sz; seq];
end
seqs_cc = [];   % sliced sequences of controls
num = ceil(length(seqs_sz) / length(ctrls_sz));
for k = 1:length(ctrls_sz)
    seq = cell(num, 1);
    for j = 1:num
        seq{j} = ctrls_sz{k}((j-1)*hop_cc+1:(j-1)*hop_cc+win_len, :);
    end
    seqs_cc = [seqs_cc; seq];
end
% 2.2 Bandpass filtering
bp = 1;


%% 3. Extract features
F = 128;        % Frequency dim with default `stft`
T = 37;         % Time dim with default `stft`
ch = 23;        % Channels

fs = 256;       % sampling rate
hz_low = 0.5;   % bandpass low frequency, Hz
hz_high = 50;   % banndpass high frequency, Hz

feats_sz = zeros(length(seqs_sz), F, T, ch);
feats_cc = zeros(length(seqs_cc), F, T, ch);
for k = 1:length(seqs_sz)
    seq = reshape(cat(1, seqs_sz{k}{:}), [], ch);
    % 2.2 Bandpass filtering
    if bp
        seq = bandpass(seq, [hz_low, hz_high], fs);
    end
    % Extract TF features
    feats_sz(k,:,:,:) = stft(seq, fs);
end

for k = 1:length(seqs_cc)
    seq = reshape(cat(1, seqs_cc{k}{:}), [], ch);
    % 2.2 Bandpass filtering
    if bp
        seq = bandpass(seq, [hz_low, hz_high], fs);
    end
    % Extract TF features
    feats_cc(k,:,:,:) = stft(seq, fs);
end
save('feats_sz.mat', 'feats_sz')
save('feats_cc.mat', 'feats_cc')
