#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                             identification_id_plus_present                                #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction a pour vocation de récupérer l'ensemble des idpubmed qui ont été       #
#  #  charges mais qui ne sont plus rattaches à une publication désormais.                  #      
#  #  Ce cas peut apparaitre lors d'une reprise notamment                                   #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #                                                                                        #
#  #   Pas de paramètre en entrée mais le fichier de suivi doit exister                     #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   # un vecteur avec l'ensemble des publications a supprimer                               #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

identification_id_plus_present <- function() {
  
  # On trace l'heure du début de l'étape  
  heure_debut <- Sys.time()   
  
  # 0 - Creation d'une log 
  print(paste0("Lancement de la recuperation des id de publication n'etant plus a charger: ",Sys.time()))
  
  
  
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
  
  ##
  print(paste0( "Nombre de publications pubmed a supprimer: ",length(id_plus_present)))
        
  print(paste0("Fin de lancement de la récupération des id de publication restant a charger: ",Sys.time()))
  
  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = 'Identification des publication plus a charger',
                              heure_debut = heure_debut)
 
  
  return(id_plus_present) 
}