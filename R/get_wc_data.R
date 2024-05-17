get_wc_data <- function(deployids) {
  
  ids <- purrr::map_dfr(
    deployids,~ wcUtils::wcGetDeployID(wcUtils::wcPOST(), 
                                                 deployid = .x)
  ) |> pull(ids)
  
  res <- purrr::map(ids, wcGetDownload)
  
  all_locs_tbl <- purrr::map(res,"all_locations") %>% 
    bind_rows() %>% 
    drop_na(any_of(c("latitude", "longitude")))
  
  locs_tbl <- purrr::map(res,"locations") %>% 
    bind_rows() %>% 
    drop_na(any_of(c("latitude", "longitude")))
  
  locs_tbl <- bind_rows(locs_tbl,all_locs_tbl)
  
  ecdf_tbl <- purrr::map(res,"ecdf") %>% 
    bind_rows()
  
  pdt_tbl <- purrr::map(res,"pdt") %>% 
    bind_rows()
  
  behav_tbl <- purrr::map(res,"behavior") |> 
    bind_rows()
  
  histos <- purrr::map(res,"histos")
  
  null_histos <- purrr::map(histos,is.null) |> unlist()
  
  histos <- histos[!null_histos]
  
  tad_tbl <- purrr::map(histos,tidyTimeAtDepth) |> 
    bind_rows()
  
  haul_out <- purrr::map(histos,tidyTimelines) |> 
    bind_rows()
  
  return(list(locs=locs_tbl,ecdf=ecdf_tbl,pdt=pdt_tbl,behav=behav_tbl,
              tad=tad_tbl,haul_out=haul_out))
}
