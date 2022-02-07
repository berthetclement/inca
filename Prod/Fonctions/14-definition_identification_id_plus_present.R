identification_id_plus_present <- function() {
  ## liste des id charges
  suivi_id_fetch <- read.csv2(paste0(DIR_OUTPUT, FILE_SUIVI_PUBMED))
  id_integres <- suivi_id_fetch %>%  
    filter(fetch_id==TRUE) %>%
    select(recherche_id)
  
  ## liste des id à charger
  r_search <- searchAPI(base_name= "pubmed", 
                        search_term= "(ClinicalTrials.gov[Secondary Source ID])",
                        opt_history= TRUE)
  ## liste des id en écart
  id_plus_present <- id_integres[id_integres$recherche_id %!in% r_search$ids,]
  
  return(id_plus_present) 
}