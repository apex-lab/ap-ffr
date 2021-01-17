addpath('functions');

% Load saved figures
a = hgload('figures/complex_fft.fig');
b = hgload('figures/piano_fft.fig');
c = hgload('figures/da_fft.fig');

% get frequencies of interest for each stimulus
foi_complex = get_foi(207.65);
foi_complex = round(foi_complex);
foi_piano = get_foi(262.67);
foi_piano = round(foi_piano);
foi_da = get_foi(100);
foi_da = round(foi_da);
foi_da = foi_da(1:2:end); 

% make graphics less awful than matlab's defaults
set(groot, ...
'DefaultFigureColor', 'w', ...
'DefaultAxesLineWidth', 0.5, ...
'DefaultAxesXColor', 'k', ...
'DefaultAxesYColor', 'k', ...
'DefaultAxesFontUnits', 'points', ...
'DefaultAxesFontSize', 8, ...
'DefaultAxesFontName', 'Helvetica', ...
'DefaultLineLineWidth', 1, ...
'DefaultTextFontUnits', 'Points', ...
'DefaultTextFontSize', 8, ...
'DefaultTextFontName', 'Helvetica', ...
'DefaultAxesBox', 'off', ...
'DefaultAxesTickLength', [0.02 0.025]);
% order is important for these two
set(groot, 'DefaultAxesTickDir', 'out');
set(groot, 'DefaultAxesTickDirMode', 'manual');

% Prepare subplots
%ylimits_stim = [0 14e10];
%ylimits_eeg = [0 150];
figure
h(1) = subplot(2, 3, 1);
title('Complex Tone');
ylabel('Stimulus', 'fontweight','bold');
%ylim(ylimits_stim);
xticks(foi_complex);
grid on
h(2) = subplot(2, 3, 2);
title('Piano Tone');
ylabel('log(uV^2/Hz)');
%ylim(ylimits_stim);
xticks(foi_piano);
grid on
h(3) = subplot(2, 3, 3);
title('Speech: /da/')
ylabel('log(uV^2/Hz)');
%ylim(ylimits_stim);
xticks(foi_da);
grid on
h(4) = subplot(2, 3, 4);
ylabel('EEG', 'fontweight','bold');
xlabel('Hz')
%ylim(ylimits_eeg);
xticks(foi_complex);
grid on
h(5) = subplot(2, 3, 5);
ylabel('uV^2/Hz (corrected)');
xlabel('Hz')
%ylim(ylimits_eeg);
xticks(foi_piano);
grid on
h(6) = subplot(2, 3, 6);
ylabel('uV^2/Hz (corrected)');
xlabel('Hz')
%ylim(ylimits_eeg);
xticks(foi_da);
grid on
% Paste figures on the subplots
copyobj(allchild(get(a(2),'CurrentAxes')),h(1));
copyobj(allchild(get(b(2),'CurrentAxes')),h(2));
copyobj(allchild(get(c(2),'CurrentAxes')),h(3));
copyobj(allchild(get(a(1),'CurrentAxes')),h(4));
copyobj(allchild(get(b(1),'CurrentAxes')),h(5));
copyobj(allchild(get(c(1),'CurrentAxes')),h(6));
