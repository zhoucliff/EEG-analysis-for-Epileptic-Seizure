clc;clear
%% 4. Training
% Split data, leave some to test, set labels: sz as 1, and cc as 0.
load('feats_sz.mat')
load('feats_cc.mat')

F = 128;        % Frequency dim with default `stft`
T = 37;         % Time dim with default `stft`
ch = 23;        % Channels

test_ratio = 0.2;
min_len = min(length(feats_cc), length(feats_sz));
n_test = ceil(test_ratio * min_len);
p = randperm(min_len, n_test);	% randomly select samples
X_test = abs([feats_cc(p, :, :, :); feats_sz(p, :, :, :)]);
y_test = categorical([zeros(n_test, 1); ones(n_test, 1)]);
p = randperm(length(y_test));	% randomize samples
X_test = X_test(p, :, :, :);
y_test = y_test(p);
X_test = permute(X_test, [2,3,4,1]);

feats_cc(p, :, :, :) = [];
feats_sz(p, :, :, :) = [];
X_train = abs([feats_cc; feats_sz]);
y_train = categorical([zeros(length(feats_cc), 1); ones(length(feats_sz), 1)]);
p = randperm(length(y_train));	% randomize samples
X_train = X_train(p, :, :, :);
y_train = y_train(p);
X_train = permute(X_train, [2,3,4,1]);

% Neural Network architecture
% Input size: [F, T, ch, N], eg. [128, 37, 23, 1]
layers = [ ...
    imageInputLayer([F, T, ch])
    convolution2dLayer(5, 20)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];
% training options
options = trainingOptions('adam', ...
    'ExecutionEnvironment','auto', ...
    'MaxEpochs',20,...
    'InitialLearnRate',1e-4, ...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'Plots','training-progress');
% training
net = trainNetwork(X_train,y_train,layers,options);

%% Evaluation
y_pred = classify(net, X_test);
accuracy = mean(y_pred == y_test);
% Result: accuracy = 1.