get_wc_data <- function(deployids) {
  
  ids <- purrr::map_dfr(
    deployids,~ wcUtils::wcGetDeployID(wcUtils::wcPOST(), 
                                                 deployid = .x)
  ) |> dplyr::pull(ids)
  
  res <- purrr::map(ids, wcGetDownload)
  
  all_locs_tbl <- purrr::map(res,"all_locations") %>% 
    dplyr::bind_rows() %>% 
    dplyr::drop_na(any_of(c("latitude", "longitude")))
  
  locs_tbl <- purrr::map(res,"locations") %>% 
    dplyr::bind_rows() %>% 
    tidyr::drop_na(any_of(c("latitude", "longitude")))
  
  locs_tbl <- dplyr::bind_rows(locs_tbl,all_locs_tbl)
  
  ecdf_tbl <- purrr::map(res,"ecdf") %>% 
    dplyr::bind_rows()
  
  pdt_tbl <- purrr::map(res,"pdt") %>% 
    dplyr::bind_rows()
  
  behav_tbl <- purrr::map(res,"behavior") |> 
    dplyr::bind_rows()
  
  histos <- purrr::map(res,"histos")
  
  null_histos <- purrr::map(histos,is.null) |> unlist()
  
  histos <- histos[!null_histos]
  
  tad_tbl <- purrr::map(histos,tidyTimeAtDepth) |> 
    dplyr::bind_rows()
  
  haul_out <- purrr::map(histos,tidyTimelines) |> 
    dplyr::bind_rows()
  
  return(list(locs=locs_tbl,ecdf=ecdf_tbl,pdt=pdt_tbl,behav=behav_tbl,
              tad=tad_tbl,haul_out=haul_out))
}
