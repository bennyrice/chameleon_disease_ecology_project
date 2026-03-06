#CHAMELEON MASS DATA (CHAM AND FROG PARASITE PROJECT)
# Benny Rice 20260202

## Loading libraries ###################################################################################################################
library(tidyverse)
library(patchwork)
library(googlesheets4)

########################################################################################################################################

#Reading in as a google sheet
dfi <- read_sheet("https://docs.google.com/spreadsheets/d/1QdQmfcqOHntI34-g37yAAfTqP2LcoboQ_fm8EXZv-NA/edit?gid=0#gid=0")
str(dfi)

# PROBLEMS:
#   Some mass values over 10,000 g
#   Usual google sheet issues with reading columns as lists



#Tidying the data frame
df1 <- dfi %>%
  #Converting list columns (annoying) to character columns)
  mutate(across(where(is.list), as.character)) %>%
  #Dropping blank rows
  filter(!is.na(unique_ind_id)) %>%
  #Converting "NA" strings to NAs
  mutate(across(where(is.character), ~as.character(.) %>% na_if("NA"))) %>%
  mutate(across(where(is.character), ~as.character(.) %>% na_if("NA"))) %>%
  #Converting to numerics
  #Height above ground of animal when spotted column (height_m): Convert to numeric
  mutate(height_m = as.numeric(height_m)) %>%
  #Mass (in grams)
  mutate(mass_g = as.numeric(mass_g))
str(df1)

df1 <- df1 %>% 
  #Dropping unbelievably high mass values
  filter(mass_g < 5000)

hist(df1$mass_g)
hist(df1$length_SVL_mm)


# Plot 1: All species
p1 <- df1 %>%
  ggplot(aes(x = site_code, y = mass_g, color = age_cat, shape = sex)) +
  geom_jitter(height = 0) +
  facet_grid(cols = vars(species), scales = "free", space = "free") +
  scale_color_viridis_d(na.value = "gray50") +
  scale_shape_discrete(na.value = 18) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white"),
        strip.text = element_text(angle = 90))
p1

# Furcifer rhinoceratus
p.rhino <- df1 %>%
  filter(species == "Furcifer rhinoceratus") %>%
  ggplot(aes(x = sex, y = mass_g, color = age_cat)) +
  geom_jitter(height = 0, width = 0.3) +
  #facet_grid(rows = vars(sex)) +
  scale_color_viridis_d(na.value = "gray50") +
  scale_shape_discrete(na.value = 18) +
  theme_bw() +
  theme(strip.background = element_rect(fill = "white"),
        strip.text = element_text(angle = 90))
p.rhino


