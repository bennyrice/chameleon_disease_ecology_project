# CODE (R)
#### gps_data_cleaning.R
R script to process GPX files from Garmin GPSMAP67 device
- Input: File paths to locally stored GPX files
- Output: CSV file of latitude and longitude coordinates for waypoints taken during fieldwork
#### gps_data_joining.R
R script for joining lat and lon coordinates (the output of `gps_data_cleaning.R` above) to data entry of frog and chameleon captures
- Input: CSV file with lat and lon data + Google Sheets link to sheet with capture information
- Output: CSV file of capture information and lat and lon coordinates of the capture
#### gps_data_mapping.R
R script for plotting GPS coordinates using the `leaflet` package, for checking for valid GPS points
- Input: CSV file with lat and lon data and associated label
- Output: A series of `leaflet` maps by locality

# DATA
#### Chameleon Capture Data
- CSV file (dated) downloaded from active google sheet used for data entry (for back up and offline use)
#### Frog Capture Data
- CSV file (dated) downloaded from active google sheet used for data entry (for back up and offline use)
#### GPS Data
- GPX files offloaded from Garmin GPSMAP67 devices (note as of 2026_01 there were 2 devices; labeled `FROG` and `CHAM`)

#

Initialized by Benny Rice (b.rice@princeton.edu)
2026_01_16
