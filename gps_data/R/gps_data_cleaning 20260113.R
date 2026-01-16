#GPS DATA (CHAM AND FROG PARASITE PROJECT)
# Benny Rice 20250911

## Loading libraries ###################################################################################################################
library(tidyverse)
#Using the sf package
library(sf)
########################################################################################################################################

## Example: Using 1 GPX file ###########################################################################################################

#Example file path
#***Note: will need to change the file path to match your computer
# '/Users/blrice/Library/CloudStorage/Dropbox/Lab Projects/2025 Projects/2025_chameleons/2025_MISSIONS/20250909 GPS_FILES/GPS_FILES_CHAM/CHAM_Waypoints_2025-08-13.gpx'
fp.gpx1 <- "/Users/blrice/Library/CloudStorage/Dropbox/Lab Projects/2025 Projects/2025_chameleons/2025_MISSIONS/20260105_GPS_FILES/GPS_FILES_CHAMS/Waypoints_2025-12-24.gpx"

#Using st_layers() to check layer names
st_layers(fp.gpx1)

#Using st_read() to extract as an sf object
sf.gpx1 <- st_read(fp.gpx1, layer = "waypoints") 

sf.gpx1 <- sf.gpx1 %>%
  #Selecting relevant columns
  dplyr::select(name, time, ele, geometry) %>%
  #Extracting lat and lon to coolumns
  mutate(lat = st_coordinates(sf.gpx1)[,2]) %>%
  mutate(lon = st_coordinates(sf.gpx1)[,1])

#Use st_drop_geometry() to convert sf object to data frame if needed



## Writing a function to process multiple GPX files ####################################################################################

#First, creating a vector of gpx file names [DONE]
#Second, loop through each gpx file: [DONE]
#   Read in as an sf object to extract the lat, lon, and metadata [DONE]
#   Select relevant columns [DONE]
#   Extract lat and lon to columns [DONE]
#   Tidy dates and times [DONE]
#Third, combine all into a sf object [DONE]
#Fourth, drop geometry (ie convert to a data frame) and export as a CSV [DONE]


#Writing a function to read and clean gpx files
f.gpx_cleaner <- function(v.gpx.file_paths){
  
  #Initiate a blank list
  sf.list <- list(NA)
  
  #Loop through
  for(i in 1:length(v.gpx.file_paths)){
    sf.i <- st_read(v.gpx.file_paths[i], layer = "waypoints") %>%
      #Selecting relevant columns
      dplyr::select(name, time, ele, geometry)
    #Extracting lat and lon to coolumns
    sf.i <- sf.i %>%
      mutate(lat = st_coordinates(sf.i)[,2]) %>%
      mutate(lon = st_coordinates(sf.i)[,1]) %>%
      #Tidying dates
      mutate(date = ymd(paste0(year(time), "-", month(time), "-", day(time)))) %>%
      #Adding site codes based on dates
      mutate(site_code = case_when(
        date >= ymd("2025-07-07") & date <= ymd("2025-07-14") ~ "NMB",
        date >= ymd("2025-07-19") & date <= ymd("2025-07-24") ~ "MTA",
        date >= ymd("2025-07-25") & date <= ymd("2025-07-31") ~ "MTF",
        date >= ymd("2025-08-13") & date <= ymd("2025-08-22") ~ "MAK",
        date >= ymd("2025-08-24") & date <= ymd("2025-08-26") ~ "TDB",
        
        date >= ymd("2025-09-12") & date <= ymd("2025-09-16") ~ "ADG",
        date >= ymd("2025-09-17") & date <= ymd("2025-09-23") ~ "ISL",
        
        date >= ymd("2025-12-16") & date <= ymd("2025-12-27") ~ "ADG"))
    #Adding i to the growing list
    sf.list[[i]] <- sf.i
  }
  
  sf.all <- bind_rows(sf.list)
  #arranging columns and rows
  sf.all <- sf.all %>%
    dplyr::select("name", "site_code", "date", "time", "ele", "lat", "lon", "geometry") %>%
    arrange(time)
  
  return(sf.all)
}


## Calling the function on Chameleon and Frog GPS data GPX files ####################################################################################

#File paths
#CHAMS as of 20260105
gpx.file_paths.CHAM <- c(list.files('/Users/blrice/Library/CloudStorage/Dropbox/Lab Projects/2025 Projects/2025_chameleons/2025_MISSIONS/20260105_GPS_FILES/GPS_FILES_CHAMS', 
                                    full.names = TRUE, include.dirs = FALSE, recursive = TRUE))

#FROGS as of 20260105
gpx.file_paths.FROG <- c(list.files('/Users/blrice/Library/CloudStorage/Dropbox/Lab Projects/2025 Projects/2025_chameleons/2025_MISSIONS/20260105_GPS_FILES/GPS_FILES_FROGS', 
                                    full.names = TRUE, include.dirs = FALSE, recursive = TRUE))


#Calling the function
# ***Note will show an error (due to the GPX file labeled current from the Garmin GPS which does not contain waypoint data)
sf1.CHAM <- f.gpx_cleaner(gpx.file_paths.CHAM) %>%
  #Adding a label for the Chameleon vs Frog team GPS device
  mutate(device = "CHAM")
sf1.FROG <- f.gpx_cleaner(gpx.file_paths.FROG) %>%
  #Adding a label for the Chameleon vs Frog team GPS device
  mutate(device = "FROG")

#Binding CHAM and FROG together
sf1 <- bind_rows(sf1.CHAM, sf1.FROG) %>% arrange(date, device)


#Exporting as a csv

# write_csv(sf1 %>% st_drop_geometry(), "/Users/blrice/Library/CloudStorage/Dropbox/Lab Projects/2025 Projects/2025_chameleons/2025_MISSIONS/20260105_GPS_FILES/processed_gpx_files_20260108.CSV")










