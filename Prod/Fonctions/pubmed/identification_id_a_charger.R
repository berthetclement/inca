
identification_id_a_charger <- function() {
  
  temps <- as.data.frame(Sys.time())
  write.table(temps,file=paste0(chemin_tps_traitment,'Identification_id_a_charger_PUBMED_debut.txt'), col.names = TRUE, row.names = FALSE)  
  
  
  # 0 - Creation d'une log 
  journal("Identification_id_a_charger_PUBMED","01-Identification_id_a_charger_PUBMED")
  print(as.character(Sys.time()))
  
  
  
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
  id_a_charger <- r_search$ids[!r_search$ids %in% id_integres$recherche_id]
 
  ## on ferme la lig
  sink()
  
  
  # fin timer du programme
  temps <- as.data.frame(Sys.time())
  write.table(temps,file=paste0(chemin_tps_traitment,'Identification_id_a_charger_PUBMED_fin.txt'), col.names = TRUE, row.names = FALSE) 
  
  return(id_a_charger) 
}