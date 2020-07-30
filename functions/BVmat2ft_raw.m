function [data] = BVmat2ft_raw(filepath)
% Imports .mat files from brainvision analyzer into Fieldtrip as ft_raw

    %% load metadata and channel data
    load(filepath, 'Channels', 'Markers', 'SampleRate', ...
        'SegmentCount', 't');
    chans = load(filepath, Channels.Name);
    
    %% aggregate channel data into trial-by-trial cell structure
    fn = fieldnames(chans);
    trials = cell(1, SegmentCount);
    for trial_num = 1:SegmentCount
        trial = zeros(numel(fn), length(t));
        for k = 1:numel(fn)
            chan = chans.(fn{k});
            trial(k, :) = chan(trial_num, :);
        end
        trials{trial_num} = trial;
    end
    
    %% compile into fieldtrip ft_raw format to return
    d.label = fn;
    time = cell(1, SegmentCount);
    for i = 1:SegmentCount
        time{i} = t'/1000; % convert to seconds
    end
    d.time = time; 
    d.trial = trials;
    %d.elec = electrode_coordinate_file; 
    
    %% return
    data = d;
    
    

end