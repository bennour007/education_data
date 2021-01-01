# import the librariries

library(tidyverse)
library(tabulizer)

# determine the pages for each table in the document 

# the document url 

link <- "http://www.edunet.tn/article_education/statistiques/stat2018_2019/stat_scolaire.pdf"

# a function that extract the data from the link 

primary_time <- extract_tables(link, pages = 24)

primary_state <- extract_tables(link, pages = 40)

################################################################################

write_rds(primary_time, "data_primary_schools/raw_data/primary_time_raw.rds")

write_rds(primary_state, "data_primary_schools/raw_data/primary_state_raw.rds")






# this line needs a fix, figure it out later.
# secondary_mixed_state <- extract_tables(link, pages = 151)
# secondary_mixed_time <- extract_tables(link, pages = 132)
