suppression_id_plus_acharger <- function() {   
  ## liste des id charges
  suivi_id_fetch <- read.csv2(paste0(DIR_OUTPUT, FILE_SUIVI_PUBMED))
  
  ## on récupère les lignes correspondantes aux publications à ne plus garder
  suivi_id_fetch_a_purger <- suivi_id_fetch[suivi_id_fetch$recherche_id %in% liste_plus_present,]
  
  ## on définit le nombre de publications à purger  
  nb_apurger <- nrow(suivi_id_fetch_a_purger)
  
  ## test de la nécessiter de purger avant de rentrer dans le traitement
  if (!is.null(nb_apurger)) {
    for (n_fic in 1:nb_apurger) {
      
      ## on identifie le fichier à lire
      nom_fic <- str_to_lower(suivi_id_fetch_a_purger[n_fic,"lot"])
      
      ## on lit le RDS
      temp <- as.data.frame(readRDS(paste0(DIR_OUTPUT_RDS_PUBMED,nom_fic,".RDS")))
      
      ## on identifie le numero de la publication
      id_pubmed <- as.character(suivi_id_fetch_a_purger[n_fic,"recherche_id"])
      
      ## on purge
      temp <- temp[as.numeric(temp$id_pubmed) %!in% id_pubmed,]
      temp <- as.data.table(temp)
      
      ## on sauvegarde le fichier
      saveRDS(temp, paste0(DIR_OUTPUT_RDS_PUBMED,nom_fic,".RDS"))
    }  
    
    ## on met à jour le fichier de suivi
    suivi_id_fetch <- suivi_id_fetch[suivi_id_fetch$recherche_id %!in% suivi_id_fetch_a_purger$recherche_id,]
    
    write.table(suivi_id_fetch, 
                paste0(DIR_OUTPUT, FILE_SUIVI_PUBMED), 
                row.names = FALSE, 
                sep = ";")
  }
}