function config = init()
% Load configuration structure

config = [];

% Paths
config.path.demographic = '../../excel';
config.path.plv = '../../data/plv';
config.path.ciplv = '../../data/ciplv';
config.path.pow = '../../data/pow';
config.path.strength = '../../data/strength';
config.path.stats = '../../results/stats';
config.path.figures = '../../results/figures';

% Create output folder if needed
if ~exist(config.path.stats), mkdir(config.path.stats), end
if ~exist(config.path.figures), mkdir(config.path.figures), end

% Bands
config.bands = {'delta','theta','alpha','low_beta','high_beta','gamma'};
config.bands_freqs = [2 4 ; 4 8 ; 8 13 ; 13 20 ; 20 30 ; 30 45];

% Channels
config.complete_channel_labels = {'Fp1', 'Fpz', 'Fp2', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC5', 'FC1', 'FC2', 'FC6',...
    'M1', 'T7', 'C3', 'Cz', 'C4', 'T8', 'M2', 'CP5', 'CP1', 'CP2', 'CP6', 'P7', 'P3',...
    'Pz', 'P4', 'P8', 'POz', 'O1', 'O2', 'AF7', 'AF3', 'AF4', 'AF8', 'F5', 'F1', 'F2',...
    'F6', 'FC3', 'FCz', 'FC4', 'C5', 'C1', 'C2', 'C6', 'CP3', 'CP4', 'P5', 'P1', 'P2',...
    'P6', 'F9', 'PO3', 'PO4', 'F10', 'FT7', 'FT8', 'TP7', 'TP8', 'PO7', 'PO8', 'FT9',...
    'FT10', 'TPP9h', 'TPP10h', 'PO9', 'PO10', 'P9', 'P10', 'AFF1', 'AFz', 'AFF2', 'FFC5h',...
    'FFC3h', 'FFC4h', 'FFC6h', 'FCC5h', 'FCC3h', 'FCC4h', 'FCC6h', 'CCP5h', 'CCP3h', 'CCP4h',...
    'CCP6h', 'CPP5h', 'CPP3h', 'CPP4h', 'CPP6h', 'PPO1', 'PPO2', 'I1', 'Iz', 'I2', 'AFp3h', 'AFp4h',...
    'AFF5h', 'AFF6h', 'FFT7h', 'FFC1h', 'FFC2h', 'FFT8h', 'FTT9h', 'FTT7h', 'FCC1h', 'FCC2h', 'FTT8h',...
    'FTT10h', 'TTP7h', 'CCP1h', 'CCP2h', 'TTP8h', 'TPP7h', 'CPP1h', 'CPP2h', 'TPP8h', 'PPO9h', 'PPO5h',...
    'PPO6h', 'PPO10h', 'POO9h', 'POO3h', 'POO4h', 'POO10h', 'OI1h', 'OI2h'};
config.occipital_channels = cellfun(@(x) contains(x, 'O'), config.complete_channel_labels);

% To find the pair of channels in the original 126 x 126 matrix
[row_idx, col_idx] = find(triu(true(126),1));
config.channls_original_index = [row_idx,col_idx];

% Visits
config.visits = {'1','2','3','4'};

% Neuro tests
config.neuro_names = {'cog_scale_score_v1_a_mano',	'cog_scale_score_v2',...
    'cog_scale_score_v3',	'cog_scale_score_v4'};


end

