function [data_raw] = ft_timelock2ft_raw(timelock)

    n = length(timelock);
    data = cell(1, n);
    time = cell(1, n);
    for i = 1:n
        data{i} = timelock{i}.avg;
        time{i} = timelock{i}.time;
    end
    data_raw.trial = data;
    data_raw.time = time;
    data_raw.label = timelock{1}.label;

end