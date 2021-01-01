
# read the rds file of the time data

library(tidyverse)

primary_time <- read_rds("data_primary_schools/raw_data/primary_time_raw.rds")

###############################################################################

primary_time_ready <- primary_time[[1]] %>%
  .[-c(1:7),] %>% 
  as_tibble() %>%
  separate(V4, sep = " ", into = c("V41", "V42", "V43", "V44")) %>%
  rename(female_prop_per_calss = "V1",
         pupil_to_class = "V2",
         pupil_to_teacher = "V3",
         teachers_female = "V41",
         teachers_all = "V42",
         pupils_female = "V43",
         pupils_all = "V44",
         taught_classes = "V5", # check this out later
         number_classerooms = "V6",
         number_schools = "V7",
         year = "V8") %>%
  separate(year, sep = "/", into = c("year", "before")) %>%
  select(-before) %>%
  sapply(str_replace, ",", ".")  %>%
  apply(2, as.numeric)%>%
  as_tibble()

primary_time_clean <- primary_time_ready %>%
  mutate(teachers_male = teachers_all - teachers_female) %>%
  mutate(pupils_male = pupils_all - pupils_female) %>%
  pivot_longer(cols = c("pupil_to_class", "pupil_to_teacher"),
               names_to = "ratios", 
               values_to = "ratios_value") %>%
  pivot_longer(cols = taught_classes:number_schools,
               names_to = "schools_char",
               values_to = "char_count") %>%
  pivot_longer(cols = c("teachers_female", "teachers_male", "teachers_all"),
               names_to = "teachers_gender",
               values_to = "teachers_gender_count") %>%
  pivot_longer(cols = c("pupils_female", "pupils_male", "pupils_all"),
               names_to = "pupils_gender",
               values_to = "pupils_gender_count")

write_csv(primary_time_clean, "data_primary_schools/primary_time_clean.csv")
