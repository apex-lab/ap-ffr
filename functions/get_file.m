function [fpath_inv fpath_noninv] = get_file(i, cond, directory)
% gets the filepaths for inverted/noninverted pairs of ABR files
% i: (number) subject ID
% cond: (char) condition name, as in filename (case sensitive!)
% directory: (char) where files can be found

    % grab all filenames in directory
    fnames = dir(directory);
    fnames = {fnames(:).name}; % convert struct array to cell
    
    % and get the ones that match our subject ID and condition
    for f = 1:length(fnames)      
        s = strcat('Subj', num2str(i));
        if contains(fnames{f}, s) && contains(fnames{f}, cond)
            if contains(fnames{f}, 'High')
                fpath_noninv = strcat(directory, '/', fnames{f});
            elseif contains(fnames{f}, 'Low')
                fpath_inv = strcat(directory, '/', fnames{f});
            end       
        end
    end

end