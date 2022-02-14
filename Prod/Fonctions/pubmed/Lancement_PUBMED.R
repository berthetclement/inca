#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   Lancement_PUBMED                                        #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction lance toute la récupération des publications :                         #
#  #    1) récupération des publications liées à un NCT                                     #      
#  #    2) récupération par paquet des publications au format xml                           #   
#  #    3) structation des données en fichier structurés                                    #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # stop_index_id : indique le nombre max de publication a traiter, 999999 = ALL           #
#  # reprise       : indique si on est dans le cadre d'une reprise (TRUE) ou non (FALSE)    #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


Lancement_PUBMED <- function(stop_index_id=999999,reprise=FALSE) {


  
  ## Pour faciliter la lecture on crée un label différent selon si c'est une reprise ou pas 
  if (reprise == TRUE) {type_trt = "REPRISE"} else {type_trt = "INIT"}
  
  # On trace l'heure du début de l'étape  
  heure_debut <- Sys.time() 
  
  # Creation d'une log 
  journal(paste0("Traitements_fichiers_XML_PUBMED_",type_trt,"_"),paste0("Traitements_fichiers_XML_PUBMED_",type_trt,"_"))

  print(paste0("Lancement de l'intégration des données de publications: ",Sys.time()))
  
  ##
  # Utilisation du package {rentrez} : 
  #   1 - Recherches d'occurences de texte dans les publications
  #   2 - Telechargement des publications pubmed au format xml
  
   
  # 1 - search id pubmed with NCT 
  r_search <- searchAPI(base_name= "pubmed", 
                        search_term= "(ClinicalTrials.gov[Secondary Source ID])",
                        opt_history= TRUE)
  
  saveRDS(r_search,paste0(DIR_OUTPUT_SUIVI,"VERIFICATION/r_search",format(Sys.time(),"%Y%m%d%H%M%S"),".RDS"))
  
  # on définit la liste des id_a_charger
  if (reprise == FALSE) {
    id_a_charger <- r_search$ids
    # 6 - Suppression ----
    # suppression du fichier de suivi 
    if(file.exists(paste0(DIR_OUTPUT_SUIVI, FILE_SUIVI_PUBMED))){
      file.remove(paste0(DIR_OUTPUT_SUIVI, FILE_SUIVI_PUBMED))
    }
    # suppression des RDS déjà chargés
    print(paste("Suppression des fichiers dans le répertoire : ", DIR_OUTPUT_RDS_PUBMED))
    do.call(file.remove, list(list.files(DIR_OUTPUT_RDS_PUBMED, full.names = TRUE)))
  } else {
    id_a_charger <- identification_id_a_charger()
  }

  print(paste0("1 - Recherche des publications pubmed : ",
               length(id_a_charger),
               " publications"))
  print(paste0("1 - Publications totales pubmed à charger : ",
               r_search$count,
               " publications"))
  
  # 2 - Telechargements des fichiers XML 
  # 3 - Traitements des fichiers XML 
  print("2 - Telechargement des publications : ")

  ## on bloque au max :
  if (stop_index_id == 999999) {stop_index_id <- length(r_search$ids)}

  full_traitements_xml(id_a_charger=id_a_charger,
                       r_search=r_search,
                       pos_id_start= 1, 
                       pos_id_end= stop_index_id, 
                       by_nb_id= step_by_id)
  


  suivi_id_fetch <- read.csv2(paste0(DIR_OUTPUT_SUIVI, FILE_SUIVI_PUBMED))
  
  print("*** Suivi des téléchargements : ***")
  text <- paste0("Nombre de publications retenues : ", stop_index_id)
  print(text)
  
  
  nb_id_true_fetch <- suivi_id_fetch %>% 
    filter(fetch_id==TRUE) %>% 
    count(fetch_id) %>% 
    pull(n)
  text <- paste0("Nombre de publications téléchargées : ", nb_id_true_fetch)
  print(text)
  
  if(stop_index_id==length(suivi_id_fetch$recherche_id)){
    print("Pas de reprise à faire")
  }else{
    nb_id_false_fetch <- suivi_id_fetch %>% 
      filter(fetch_id==FALSE | is.na(fetch_id)) %>% 
      count(fetch_id) %>% 
      pull(n)
    text <- paste0("Nombre d'id PUBMED à reprendre : ", stop_index_id-nb_id_true_fetch)
    print(text)
  }
  
  
  # clean env ---- 
  rm(full_recs_xml_web)
  
  sink()

  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = paste0('Lancement pubmed ',type_trt),
                              heure_debut = heure_debut
  ) 
  
}
