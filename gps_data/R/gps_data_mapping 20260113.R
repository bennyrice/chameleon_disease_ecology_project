#GPS DATA (CHAM AND FROG PARASITE PROJECT)
# Benny Rice 20250911

## Loading libraries ###################################################################################################################
library(tidyverse)
#Using the sf package
library(sf)
#Mapping with the leaflet package
library(leaflet)
#*Note needs internet connection to load maps

########################################################################################################################################

## Reading GPS data in from the processed GPS data CSV file ####################################################################################

#Specifying the file path to the CSV file
fp.csv <- '/Users/blrice/Library/CloudStorage/Dropbox/Lab Projects/2025 Projects/2025_chameleons/2025_MISSIONS/20260105_GPS_FILES/processed_gpx_files_20260108.CSV'
#Reading in as a data frame
df.gps1 <- read_csv(fp.csv)
#NOTE: Time will be in UTC / Zulu time zone

#Creating an sf object for plotting
sf.gps <- st_as_sf(df.gps1, coords = c("lon", "lat"), crs = 4326)

#Leaflet
map.all <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1, 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~name)
map.all

map.NMB <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "NMB"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~name)
map.NMB
#***Note: T0 point is in Tana (likely GPS had not connected to satellite yet)
#***Note: Need to rename points and associate with captures and transects

map.MTA <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "MTA"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~name)
map.MTA
#***Note: Check for duplicate GPS points (e.g., same exact coordinates)

map.MTF <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "MTF"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~name)
map.MTF


map.MAK <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "MAK"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~as.character(name))
map.MAK


map.MAK.C <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "MAK") %>% filter(device == "CHAM"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~as.character(name))
map.MAK.C

map.MAK.F <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "MAK") %>% filter(device == "FROG"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~as.character(name))
map.MAK.F



map.TDB <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "TDB"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~as.character(name))
map.TDB

map.TDB.C <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "TDB") %>% filter(device == "CHAM"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~as.character(name))
map.TDB.C

map.TDB.F <- leaflet() %>%
  addTiles() %>% # Adds default OpenStreetMap tiles
  addMarkers(data = df.gps1 %>% filter(site_code == "TDB") %>% filter(device == "FROG"), 
             lat = ~lat, lng = ~lon, popup = ~name, label = ~as.character(name))
map.TDB.F
















