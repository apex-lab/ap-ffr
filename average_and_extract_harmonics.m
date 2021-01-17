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
COND = 'piano';
F0 = 262.67;
TIME_WINDOW = [0 .2]; % in seconds

s = RandStream('mlfg6331_64'); % set random seed for reproducible results

%% load data, subsample trials, and average
subj = SUBJ(~ismember(SUBJ, BAD_SUBJ));
allSubj_timelock = cell(1, length(subj));
allSubj_noninv = cell(1, length(subj));
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
    inv = ft_timelockanalysis(cfg, inv);
    noninv = ft_timelockanalysis(cfg, noninv);
    % and finally average the inverted with the noninverted
    cfg = [];
    cfg.channel = 'EP1';
    allSubj_timelock{j} = ft_timelockgrandaverage(cfg, inv, noninv);
    allSubj_noninv{j} = noninv;
    j = j + 1; % updates for next iteration
end

%% shove all subjects' timelocked data into one ft_raw struct
% to trick fieldtrip into doing an FFT ;-)
all_data_raw = ft_timelock2ft_raw(allSubj_timelock);
all_noninv_raw = ft_timelock2ft_raw(allSubj_noninv);

%% compute fourier transform and pull out power values of interest

% we want all harmonics up to 1500 Hz
foi = get_foi(F0);

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

%% compute full power spectra
cfg = [];
cfg.method     = 'mtmfft'; % does an FFT across specified time interval
cfg.output     = 'pow'; % computes the power spectra
cfg.toilim    = TIME_WINDOW;
cfg.foilim     = [70 1500]; % frequencies of interest
cfg.taper      = 'hanning'; % applies hanning taper on window before FFT
cfg.keeptrials  = 'no';
all_data_fft = ft_freqanalysis(cfg, all_data_raw);
all_noninv_fft = ft_freqanalysis(cfg, all_noninv_raw);

cfg = [];
cfg.parameter = 'powspctrm';
cfg.operation = 'log10';
all_noninv_fft = ft_math(cfg, all_noninv_fft);

% correct for 1/f dropoff
all_data_fft.powspctrm = all_data_fft.powspctrm .* all_data_fft.freq.^2;

cfg = [];
cfg.channel      = 'EP1';
figs(1) = figure;
ft_singleplotER(cfg, all_data_fft); % plot eeg data
figs(2) = figure;
cfg.channel      = 'Aux1';
ft_singleplotER(cfg, all_noninv_fft); % plot stimulus
savefig(figs, strcat('figures/', COND, '_fft.fig'));










