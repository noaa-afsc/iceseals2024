library(dplyr)
library(readr)
library(ggplot2)
library(scico)


dive_pdt <- readr::read_csv(
  '/Users/josh.london/Downloads/174794/174794-DivePDT.csv'
  ) |> 
  dplyr::mutate(Date = lubridate::parse_date_time(Date,orders = 'HMSdmy')) |> 
  group_by(Date) |> 
  arrange(Date,Depth)

ggplot(data = dive_pdt, aes(x = Date, y = Depth * -1, color = Temperature )) +
  geom_point(shape = 15,size =1) +
  scale_color_scico(palette = "roma", direction = -1,
                    guide = guide_colorbar(
                      title = 'reported water temperature (C)',
                      title.position = 'bottom',
                      title.hjust = 0.5,
                      barwidth = unit(75, units = "mm"),
                      barheight = unit(2, units = "mm"))) +
  labs(y = "Depth (meters)",
       x = "",
       title = stringr::str_wrap("Measurements of temperature at depth from a bio-logger deployed on a spotted seal in the western Bering Sea",60),
       subtitle = "approximate location: 60.946, -177.332") +
  theme_minimal() +
  theme(legend.position = "bottom")
