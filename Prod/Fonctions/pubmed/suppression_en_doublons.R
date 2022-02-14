#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                               suppression_en_doublons                                     #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction a pour vocation de supprimer l'ensemble des idpubmed qui sont chargees #
#  #  plusieurs fois. Elle se base sur le vecteur liste_doublons créer précemment et sur le #      
#  #  le fichier de suivi pour trouver les .RDS à épurer. On ne garde que la derniere       #
#  #  integration.                                                                          #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #                                                                                        #
#  #   Pas de paramètre en entrée mais le fichier de suivi et le vecteur liste_doublons     #
#  #   doivent exister                                                                      #
#                                                                                           #
## En sortie :                                                                              #
#   # Les RDS dans l'output pubmed et le fichier de suivi mis à jour                        #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


suppression_en_doublons <- function() {   
  
  # On trace l'heure du début de l'étape  
  heure_debut <- Sys.time() 
  
  # 0 - Creation d'une log 
  # Creation d'une log 
  journal("Suppression_publications_en_doublons_","Suppression_publications_en_doublons_")
  
  print(paste0("Lancement de la suppression des publications qui ne sont charges plusieurs fois: ",Sys.time()))
  
  
  
  
  ## liste des id charges
  suivi_id_fetch <- read.csv2(paste0(DIR_OUTPUT, FILE_SUIVI_PUBMED))
  
  ## on récupère les lignes correspondantes aux publications en doublons
  suivi_id_fetch_a_purger <- suivi_id_fetch[suivi_id_fetch$recherche_id %in% liste_doublons$recherche_id,]
  
  ## on va identifier les lignes que l'on garde : les plus récents
  suivi_id_fetch_a_purger <- suivi_id_fetch_a_purger %>% arrange(recherche_id,lot)
  doublons <- suivi_id_fetch_a_purger[!duplicated(suivi_id_fetch_a_purger[,c("recherche_id")],fromLast=TRUE),] 
  liste_a_supprimer <- suivi_id_fetch_a_purger %>% anti_join(doublons,c("recherche_id","lot"))
  
  
  ## on définit le nombre de publications à purger  
  nb_apurger <- nrow(liste_a_supprimer)
  
  ## test de la nécessiter de purger avant de rentrer dans le traitement
  if (!is.null(nb_apurger) & nb_apurger !=0) {
    for (n_fic in 1:nb_apurger) {
      
      ## on identifie le fichier à lire
      nom_fic <- str_to_lower(liste_a_supprimer[n_fic,"lot"])
      
      ## on lit le RDS
      temp <- as.data.frame(readRDS(paste0(DIR_OUTPUT_RDS_PUBMED,nom_fic,".RDS")))
      
      ## on identifie le numero de la publication
      id_pubmed <- as.character(liste_a_supprimer[n_fic,"recherche_id"])
      
      ## on purge
      temp <- temp[as.numeric(temp$id_pubmed) %!in% id_pubmed,]
      temp <- as.data.table(temp)
      
      ## on sauvegarde le fichier
      saveRDS(temp, paste0(DIR_OUTPUT_RDS_PUBMED,nom_fic,".RDS"))
      
            ## on met à jour le fichier de suivi
      suivi_id_fetch <- suivi_id_fetch[!(suivi_id_fetch$recherche_id %in% id_pubmed
                                       & suivi_id_fetch$lot %in%  str_to_upper(nom_fic)),]
    }  
    
    
    write.table(suivi_id_fetch, 
                paste0(DIR_OUTPUT, FILE_SUIVI_PUBMED), 
                row.names = FALSE, 
                sep = ";")
  }
  
  ##
  print(paste0("Nombre de publications pubmed supprimées: ", nb_apurger))
  print(paste0("Fin de lancement de la Suppression des publications chargees plusieurs fois: ",Sys.time()))
  
  # on ferme la log
  sink()
  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = 'Suppression des publication plus a charger',
                              heure_debut = heure_debut
  )  
  
}