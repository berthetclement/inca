suppression_en_doublons <- function() {   
  ## liste des id charges
  suivi_id_fetch <- read.csv2(paste0(chemin_output, nom_fichier_suivi_id))
  
  ## on récupère les lignes correspondantes aux publications en doublons
  suivi_id_fetch_a_purger <- suivi_id_fetch[suivi_id_fetch$recherche_id %in% liste_doublons$recherche_id,]
  
  ## on va identifier les lignes que l'on garde : les plus récents
  suivi_id_fetch_a_purger <- suivi_id_fetch_a_purger %>% arrange(recherche_id,lot)
  doublons <- suivi_id_fetch_a_purger[!duplicated(suivi_id_fetch_a_purger[,c("recherche_id")],fromLast=TRUE),] 
  liste_a_supprimer <- suivi_id_fetch_a_purger %>% anti_join(doublons,c("recherche_id","lot"))
  
  
  ## on définit le nombre de publications à purger  
  nb_apurger <- nrow(liste_a_supprimer)
  
  ## test de la nécessiter de purger avant de rentrer dans le traitement
  if (!is.null(nb_apurger)) {
    for (n_fic in 1:nb_apurger) {
      
      ## on identifie le fichier à lire
      nom_fic <- str_to_lower(liste_a_supprimer[n_fic,"lot"])
      
      ## on lit le RDS
      temp <- as.data.frame(readRDS(paste0(chemin_pubmed_rds,nom_fic,".RDS")))
      
      ## on identifie le numero de la publication
      id_pubmed <- as.character(liste_a_supprimer[n_fic,"recherche_id"])
      
      ## on purge
      temp <- temp[as.numeric(temp$id_pubmed) %!in% id_pubmed,]
      temp <- as.data.table(temp)
      
      ## on sauvegarde le fichier
      saveRDS(temp, paste0(chemin_pubmed_rds,nom_fic,".RDS"))
      
            ## on met à jour le fichier de suivi
      suivi_id_fetch <- suivi_id_fetch[!(suivi_id_fetch$recherche_id %in% id_pubmed
                                       & suivi_id_fetch$lot %in%  str_to_upper(nom_fic)),]
    }  
    
    
    write.table(suivi_id_fetch, 
                paste0(chemin_output, nom_fichier_suivi_id), 
                row.names = FALSE, 
                sep = ";")
  }
}