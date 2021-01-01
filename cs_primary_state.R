# reading the rds file of the states data

library(tidyverse)

primary_state <- read_rds("data_primary_schools/raw_data/primary_state_raw.rds")
# cleaning the data extracted

primary_state_ready <- primary_state[[1]] %>% 
  .[-c(1:7,9,29,36),] %>%
  as_tibble() %>%
  separate(V1, sep= " ", 
           into = c("pupil_to_teacher",
                    "teachers_female",
                    "teachers_all",
                    "pupils_female_prop",
                    "pupils_female",
                    "pupils_all",
                    "pupil_to_class",
                    "number_taught_classes")) %>%
  rename(number_classerooms = "V2",
         number_schools = "V3") %>%
  separate(number_schools, sep = " ",
           into = c("number_schools",
                    "state")) %>%
  select(-V4) %>%
  sapply(str_replace, ",", ".")  %>%
  as_tibble()

primary_state_ready[c(1,2,20,21),11] <- c("Tunis1", "Tunis2", "Sfax1", "Sfax2") 
  
primary_state_ready[,-11] <- primary_state_ready[,-11] %>% 
  apply(2, as.numeric)%>%
  as_tibble()

primary_state_ready <- primary_state_ready %>%
  select(-pupils_female_prop) %>%
  mutate(pupils_male = pupils_all - pupils_female) %>%
  mutate(teachers_male = teachers_all - teachers_female)

################################################################################

primary_state_clean <- primary_state_ready %>%
  pivot_longer(cols = c("pupil_to_teacher", 
                        "pupil_to_class"),
               names_to = "ratios", 
               values_to = "ratios_value") %>% 
  pivot_longer(cols =  number_taught_classes:number_schools,
               names_to = "schools_char",
               values_to = "char_count") %>%
  pivot_longer(cols = c("teachers_female", "teachers_male", "teachers_all"),
               names_to = "teachers_gender",
               values_to = "teachers_gender_count") %>%
  pivot_longer(cols = c("pupils_female","pupils_all", "pupils_male"),
               names_to = "pupils_gender",
               values_to = "pupils_gender_count")


write_csv(primary_state_clean, "data_primary_schools/primary_state_clean.csv")
