%% filepaths and constants
addpath('~/repos/fieldtrip')
ft_defaults % sets paths required for fieldtrip
addpath('functions')
DIR = '~/Documents/ap-ffr/export/2000';

% subject info
SUBJ = 1:50;
BAD_SUBJ = [5 19 28 39]; 

% filter info
LP_FILTER = 2000;

% condition specific info
COND = 'complex';
F0 = 207.65;
TIME_WINDOW = [0 .2]; % in seconds

s = RandStream('mlfg6331_64'); % set random seed for reproducible results

%% load data, subsample trials, and average
subj = SUBJ(~ismember(SUBJ, BAD_SUBJ));

allSubj_timelock = cell(1, length(subj));
j = 1; % keeps track of where we are in allSubj_timelock
for i = subj % for each subject
    % load their data
    [fname_inv, fname_noninv] = get_file(i, COND, DIR, LP_FILTER);
    inv = BVmat2ft_raw(fname_inv);
    noninv = BVmat2ft_raw(fname_noninv);
    % subsample from larger datafile to make trial counts equal
    if length(inv.trial) > length(noninv.trial)
        cfg = [];
        cfg.trials = randsample(length(inv.trial), length(noninv.trial));
        inv = ft_selectdata(cfg, inv);
    elseif length(inv.trial) < length(noninv.trial)
        cfg = [];
        cfg.trials = randsample(length(noninv.trial), length(inv.trial));
        noninv = ft_selectdata(cfg, noninv);
    end
    assert(length(inv.trial) == length(noninv.trial));
    % average over trials within inverted and noninverted
    cfg = [];
    cfg.channel = 'EP1';
    inv = ft_timelockanalysis(cfg, inv);
    noninv = ft_timelockanalysis(cfg, noninv);
    % and finally average the inverted with the noninverted
    cfg = [];
    allSubj_timelock{j} = ft_timelockgrandaverage(cfg, inv, noninv);
    j = j + 1; % updates for next iteration
end

%% shove all subjects' timelocked data into one ft_raw struct
% to trick fieldtrip into doing an FFT ;-)
n = length(allSubj_timelock);
data = cell(1, n);
time = cell(1, n);
for i = 1:n
    data{i} = allSubj_timelock{i}.avg;
    time{i} = allSubj_timelock{i}.time;
end
all_data_raw.trial = data;
all_data_raw.time = time;
all_data_raw.label = allSubj_timelock{1}.label;

%% compute fourier transform and pull out power values of interest

% we want all harmonics up to 1500 Hz
foi = [F0];
h = 1;
while F0*h < 1500 % 1500 is where brainstem stops phase locking
    foi = [foi F0*h];
    h = h + 1;
end

cfg = [];
cfg.channel    = 'EP1';
cfg.method     = 'mtmfft'; % does an FFT across specified time interval
cfg.output     = 'pow'; % computes the power spectra
cfg.toilim    = TIME_WINDOW;
cfg.foi     = foi; % frequencies of interest
cfg.taper      = 'hanning'; % applies hanning taper on window before FFT
cfg.keeptrials  = 'yes';
all_data_freq = ft_freqanalysis(cfg, all_data_raw);

%% export FFT results as .csv
pow = squeeze(all_data_freq.powspctrm);
writematrix(pow, strcat(COND, '_harmonics.csv'));

%% compute time-frequency representation
cfg = [];
cfg.channel = 'EP1';
cfg.method = 'wavelet';
cfg.width = 7;
cfg.output = 'pow';
cfg.detrend = 'yes';
cfg.demean = 'yes';
cfg.foi = 85:1:1500; % frequencies of interest
cfg.toi = 'all';

TFR = ft_freqanalysis(cfg, all_data_raw);

% and plot
cfg = [];
cfgcfg.baseline = [-.25 0];
cfg.baselinetype = 'relative';
figure;
ft_singleplotTFR(cfg, TFR);

%% plot first ten milliseconds
cfg = [];
cfg.channel = 'EP1';
grandavg = ft_timelockanalysis(cfg, all_data_raw);

cfg = [];
cfg.channel = 'EP1';
cfg.xlim = [-.005 .015];
cfg.parameter = 'avg';
figure;
ft_singleplotER(cfg, grandavg);








