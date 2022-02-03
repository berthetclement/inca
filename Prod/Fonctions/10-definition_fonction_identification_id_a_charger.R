
identification_id_a_charger <- function() {
  ## liste des id charges
  suivi_id_fetch <- read.csv2(paste0(chemin_output, nom_fichier_suivi_id))
  id_integres <- suivi_id_fetch %>%  
    filter(fetch_id==TRUE) %>%
    select(recherche_id)
  
  ## liste des id à charger
  r_search <- searchAPI(base_name= "pubmed", 
                        search_term= "(ClinicalTrials.gov[Secondary Source ID])",
                        opt_history= TRUE)
  ## liste des id en écart
  id_a_charger <- r_search$ids[!r_search$ids %in% id_integres$recherche_id]
  
  return(id_a_charger) 
}