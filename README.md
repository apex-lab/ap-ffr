# Absolute Pitch Perception and the Frequency Following Response

The following scripts are used, after data is exported from Brainvision Analyzer, to compute the features of interest (frequency following response power at fundamental frequency and harmonics of the stimulus).

* `average_and_extract_harmonics.m`: Performs further preprocessing (trial subsampling, averaging) on `.mat` files output by brainvision analyzer. Then, calculates power spectra for frequencies of interest for all subjects and exports to `.csv`. To use, make sure hard coded values in first code chunk are correct and press run. Depends on functions `BVmat2ft_raw` and `get_file`,
* `functions/BVmat2ft_raw.m`: Imports brainvision analyzer `.mat` output into fieldtrip. Should work generally in future projects.
* `functions/get_file.m`: Grabs (inverted and non-inverted stimulus) filenames for a given subject and condition from given directory. Written just for this project, and may not work for future projects.

