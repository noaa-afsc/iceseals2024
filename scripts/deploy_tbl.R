library(googlesheets4)
library(dplyr)
library(lubridate)
library(readr)

read_sheet(
  "1qdItHYew9a-6xkUpIjnmauv-rP09FPg3rIzdjalX8xU"
) %>% 
  select(1,2,5,6,10,15) %>% 
  janitor::clean_names() %>% 
  rename(deployid = deploy_id,
         speno = animal_tag_id) %>% 
  mutate(deploy_date_time_gmt = lubridate::force_tz(deploy_date_time_gmt,"UTC")) %>% 
  readr::write_rds(file = here::here('data/deploy_tbl.rds'))

read_sheet(
  "1zt_rtQFaEQluoJuyBkcIQvNSkFWVpgtbOWKuFd9Z2uc"
) %>% 
  janitor::clean_names() %>% 
  readr::write_rds(file = here::here('data/summary_tbl.rds'))
