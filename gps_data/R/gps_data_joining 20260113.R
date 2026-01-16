#GPS DATA (CHAM AND FROG PARASITE PROJECT)
# Benny Rice 20250911

## Loading libraries ###################################################################################################################
library(tidyverse)
#Using the sf package
library(sf)
#Mapping with the leaflet package
#*Note needs internet connection to load maps
library(leaflet)
#Reading data from a google sheet
library(googlesheets4)
########################################################################################################################################

########################################################################################################################################
# Reading in data

# 1 # Reading GPS data in from the processed GPS data CSV file ####################################################################################

#Specifying the file path to the CSV file
fp.csv <- '/Users/blrice/Library/CloudStorage/Dropbox/Lab Projects/2025 Projects/2025_chameleons/2025_MISSIONS/20260105_GPS_FILES/processed_gpx_files_20260108.CSV'
#Reading in as a data frame
df.gps.i <- read_csv(fp.csv)
#NOTE: Time will be in UTC / Zulu time zone

#Tidying
df.gps <- df.gps.i %>%
  #Add GPS prefix to column names
  rename(capture_gps_code = name,
         gps.site_code = site_code,
         gps.date = date,
         gps.time = time,
         gps.device = device)

# 2 # Reading in chameleon capture data from google sheets ####################################################################################

df.chams.i <- read_sheet("https://docs.google.com/spreadsheets/d/19uJaZpW6x7Jafh1vimZzL6ADEWRxaDYg9iEkv4HSmFw/edit?usp=sharing")
#Tidying the data frame
df.chams <- df.chams.i %>%
  #Converting list columns (annoying) to character columns)
  mutate(across(where(is.list), as.character)) %>%
  #Dropping blank rows
  filter(!is.na(unique_ind_id)) %>%
  #Converting "NA" strings to NAs
  mutate(across(where(is.character), ~as.character(.) %>% na_if("NA"))) %>%
  mutate(across(where(is.character), ~as.character(.) %>% na_if("NA"))) %>%
  #Height above ground of animal when spotted column (height_m): Convert to numeric
  mutate(height_m = as.numeric(height_m))

# 3 # Reading in frog capture data from google sheets ####################################################################################

df.frogs.i <- read_sheet("https://docs.google.com/spreadsheets/d/1A1dS6rqnJpUQfqi4DoHt7gv7OWeySphEk1xTeeGSkOw/edit?usp=sharing")
#Tidying the data frame
df.frogs <- df.frogs.i %>%
  #Tidying capture/release/venipuncture and date
  #Converting to character then converting NAs then converting back to date
  #Dividing timestamp (seconds since origin in 1970) by 86400 seconds in a day
  mutate(capture_date = as.character(capture_date),
         capture_date = na_if(capture_date, "NA"),
         capture_date = as.Date(as.numeric(capture_date) / 86400, origin = "1970-01-01", format = "%Y-%m-%d")) %>%
  mutate(release_date = as.character(release_date),
         release_date = na_if(release_date, "NA"),
         release_date = as.Date(as.numeric(release_date) / 86400, origin = "1970-01-01", format = "%Y-%m-%d")) %>%
  mutate(processing_date = as.character(processing_date),
         processing_date = na_if(processing_date, "NA"),
         processing_date = as.Date(as.numeric(processing_date) / 86400, origin = "1970-01-01", format = "%Y-%m-%d")) %>%
  #Converting list columns (annoying) to character columns)
  mutate(across(where(is.list), as.character)) %>%
  #Renaming id code column
  rename(unique_ind_id = code_ind) %>%
  #Dropping blank rows
  filter(!is.na(unique_ind_id)) %>%
  #Converting "NA" strings to NAs
  mutate(across(where(is.character), ~as.character(.) %>% na_if("NA"))) %>%
  mutate(across(where(is.character), ~as.character(.) %>% na_if("NA")))


########################################################################################################################################
# Joining capture data with GPS data

# CHAMELEONS
df.chams.gps <- df.chams %>% left_join(df.gps, by = join_by(capture_gps_code))

# PROBLEMS: Individuals without matching GPS data
df.problems1 <- df.chams.gps %>% filter(is.na(lat))
df.problems1
#1 problem case: NMB.C.2025.07.008 (no capture_gps_code)
# A likely problem case: GPS point for animal captured at Phare seems wrong



# FROGS
df.frogs.gps <- df.frogs %>% left_join(df.gps, by = join_by(capture_gps_code))

# PROBLEMS: Individuals without matching GPS data
df.problems2 <- df.frogs.gps %>% filter(is.na(lat))
df.problems2
#264 problem cases:
# NMB - capitalization/naming?
# MTA - missing data
# MTF - prefix issue?
# MAK - missing data
# ISL - 1 weird name (GPS ISL.C.F.0001 from individual ISL.F.2025.09.141)



########################################################################################################################################
# Mapping with Leaflet to check
map.chams <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.chams.gps, 
             lat = ~lat, lng = ~lon, popup = ~unique_ind_id, label = ~unique_ind_id)
map.chams

map.frogs <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.frogs.gps, 
             lat = ~lat, lng = ~lon, popup = ~unique_ind_id, label = ~unique_ind_id)
map.frogs

########################################################################################################################################
# Error checking (in addition to the missing data above)

# Duplicate GPS points (same exact coordinates)
# Imopssibly far distance from transect/locality
# GPS date/time does not match capture date and time

########################################################################################################################################
# Plotting elevation data
df.chams.ele <- df.chams.gps %>% dplyr::select(unique_ind_id, site_code, species, capture_gps_code, gps.site_code, ele, lat, lon, gps.device)
df.frogs.ele <- df.frogs.gps %>% dplyr::select(unique_ind_id, site_code, species, capture_gps_code, gps.site_code, ele, lat, lon, gps.device)

df.ele <- bind_rows(df.chams.ele, df.frogs.ele)

p1.scatter <- df.ele %>%
  filter(!is.na(ele)) %>%
  ggplot() +
  geom_jitter(aes(x = site_code, y = ele), height = 0, alpha = 0.5) +
  #facet_wrap(vars(species), scales = "free_x") +
  facet_wrap(vars(species), scales = "free") +
  theme_bw()
p1.scatter

########################################################################################################################################
# Exporting as a csv file











