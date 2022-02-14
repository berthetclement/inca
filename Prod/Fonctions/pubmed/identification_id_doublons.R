#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                             identification_id_doublons                                    #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction a pour vocation de récupérer l'ensemble des idpubmed qui ont été       #
#  #  charges  plusieurs fois. Dans ce cas on garde la derniere intégration.                #      
#  #  Cas apparu lors d'un pb du package rentrez qui a ete ajuste mais on garde le test     #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #                                                                                        #
#  #   Pas de paramètre en entrée mais le fichier de suivi doit exister                     #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   # un vecteur avec l'ensemble des publications a supprimer et des fichiers concernes     #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

identification_id_doublons <- function() {
  
  # On trace l'heure du début de l'étape  
  heure_debut <- Sys.time()   
  
  # 0 - Creation d'une log 
  print(paste0("Lancement de la recuperation des id de publication integres plusieurs fois: ",Sys.time()))
  
  
  ## lecture du fichier de suivi
  suivi_id_fetch <- read.csv2(paste0(DIR_OUTPUT, FILE_SUIVI_PUBMED))
  
  ## liste des id charges plusieurs fois
  id_doublons <- suivi_id_fetch %>%  
    filter(fetch_id==TRUE) %>%
    select(recherche_id) %>% 
    group_by(recherche_id) %>%
    summarise(nb = n()) %>%
    filter( nb > 1)
  
  ##
  print(paste0("Nombre de publications chargées plusieurs fois:"),nrow(id_doublons))
  
  print(paste0("Fin de la recuperation des id de publication integres plusieurs fois: ",Sys.time()))
  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = 'Identification des publication chargees plusieurs fois',
                              heure_debut = heure_debut
                              )
  
  return(id_doublons) 
}