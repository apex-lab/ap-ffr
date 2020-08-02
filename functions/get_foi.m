function [foi] = get_foi(f0)

    foi = [f0];
    h = 2;
    while f0*h < 1500 % 1500 is where brainstem stops phase locking
        foi = [foi f0*h];
        h = h + 1;
    end

end