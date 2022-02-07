identification_id_doublons <- function() {
  ## liste des id charges
  suivi_id_fetch <- read.csv2(paste0(DIR_OUTPUT, FILE_SUIVI_PUBMED))
  id_doublons <- suivi_id_fetch %>%  
    filter(fetch_id==TRUE) %>%
    select(recherche_id) %>% 
    group_by(recherche_id) %>%
    summarise(nb = n()) %>%
    filter( nb > 1)
  
  return(id_doublons) 
}