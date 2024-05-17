library(RPostgres)
library(dplyr)
library(lubridate)
library(ggplot2)


tryCatch({
  con <- dbConnect(RPostgres::Postgres(),
                   dbname = 'pep', 
                   host = Sys.getenv('PEP_PG_IP'),
                   user = keyringr::get_kc_account("pgpep_londonj"),
                   password = keyringr::decrypt_kc_pw("pgpep_londonj"))
},
error = function(cond) {
  print("Unable to connect to Database.")
})
on.exit(dbDisconnect(con))

captures_qry <- "select *
from capture.geo_captures
where common_name in ('Ribbon seal','Spotted seal')
and capture_dt > '2006-01-01' AND
project is not null AND
project not in ('2012_Everett')
order by speno;"

captures_data <- dbGetQuery(con, captures_qry) 
  
captures_data <- captures_data |> 
  dplyr::mutate(doy = lubridate::yday(capture_dt),
                y = lubridate::year(capture_dt),
                month_day = as.Date('2010-12-31') + doy) |> 
  dplyr::filter(between(doy,100,200),
                !project %in% c('2008_Bering','2007_Russia','2009_Russia',
                                '2014_Japan'))

ggplot(data = captures_data,aes(month_day,color=common_name)) +
  geom_rect(aes(xmin=ymd('2011-04-15'),
                xmax = ymd('2011-05-28'),
                ymin = -Inf,
                ymax = Inf), fill = 'grey90', 
            color = NA, alpha = 0.05) +
  geom_freqpoly(binwidth = 1, linewidth=1,
                ) + 
  facet_grid( y ~ .) +
  theme_minimal() +
  labs( title = "Captures of Ribbon and Spotted Seals",
        subtitle = "daily number of captures by species across all ages",
        caption = "shaded area represents duration of 2024 expedition",
        y = "number of captures") +
  xlab('') +
  scale_color_discrete(name = '')
