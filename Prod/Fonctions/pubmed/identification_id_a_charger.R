#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                               identification_id_a_charger                                 #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction a pour vocation de récupérer l'ensemble des idpubmed restant à charger #
#  #  Elle fait le delta entre l'ensemble des idpumned à charger et ce qui est tracé dans   #      
#  #  le fichier de suivi.                                                                  #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #                                                                                        #
#  #   Pas de paramètre en entrée mais le fichier de suivi doit exister                     #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   # un vecteur avec l'ensemble des publications à charger                                 #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

identification_id_a_charger <- function() {
  
  # On trace l'heure du début de l'étape  
  heure_debut <- Sys.time() 
  
  # 0 - Creation d'une log 
  print(paste0("Lancement de la recuperation des id de publication restant a charger: ",Sys.time()))
  
  
  ## liste des id charges
  fic_suivi <- read.csv2(paste0(DIR_OUTPUT, FILE_SUIVI_PUBMED))
  
  ## on filtre sur les lignes bien integrees
    for (i in (1:length(LST_TEST_PUBMED))) {
      fic_suivi <- fic_suivi %>%  
        filter(get(LST_TEST_PUBMED[i])==TRUE) 
    }

  ## on compte recupere les id bien integre
  id_integres <- fic_suivi %>%  select(recherche_id)
  
  ## liste des id à charger
  r_search <- searchAPI(base_name= "pubmed", 
                        search_term= REQUETE_NCT_PUBLI,
                        opt_history= TRUE)
  ## liste des id en écart
  id_a_charger <- r_search$ids[!r_search$ids %in% id_integres$recherche_id]
 
  ##
  print(paste0( "Recherche des publications pubmed : ",
               length(id_a_charger),
               " publications encore a charger"))
  
  print(paste0("Fin de lancement de la récupération des id de publication restant a charger: ",Sys.time()))
  

  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = 'Identification des publication restant a charger',
                              heure_debut = heure_debut
  )  
  return(id_a_charger) 
}