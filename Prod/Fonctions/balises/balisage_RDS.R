#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   balisage_RDS                                            #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  # Cette fonction a pour but de remonter les donnees sous Postgre en separant les         #
#  #  données des balises simples et les balises multiples.                                 #
#  # Elle se deroule en 3 etapes :                                                          #
#  #  1) creation du schema cible s'il n'existe pas                                         #
#  #  2) creation des structures vides pour accueillir les donnees                          #
#  #  3) separation des rds en partie simple/mult puis remontee sous Postgre                #
#  # Les couples parents/balises sont prequalifies pour faciliter le travail utilisateurs   #                                              #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  nom_schema  : nom du schema dans lequel seront stockees les donnees sous PostGre      #
#  #  nom_table   : nom de la donnee travaillee : pubmed,desc,supp,pa ou qual               #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   # 2 tables (simple et mult) creees sous postgre avec les donnees des fichiers rds       #                                                                                   #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

balisage_RDS <- function(nom_schema, nom_table){
  
  # On trace l'heure du début de l'étape  
  heure_debut <- Sys.time() 
  
  # 0 - Creation d'une log 
  journal(paste0('Balisage_',nom_table), paste0('Balisage_',nom_table))

  print(paste0("Lancement de la partie remontee des donnees ",nom_table," :",Sys.time()))
  
  file_comptage = get(paste("PATH_REF_CPT", toupper(nom_table), sep = "_"))
  dir_rds = get(paste("DIR_OUTPUT_RDS", toupper(nom_table), sep = "_"))
  
  print(paste0("Initialisation du schema :",Sys.time()))
  # Initialisation du schéma
  pstgr_init_schema(nom_schema)
  
  print(paste0("Initialisation des tables :",Sys.time()))
  # Initialisation des tables vides
  pstgr_write_table_ref_vide(nom_schema, nom_table)
  
  print(paste0("Separation des donneees et remontee sous PostGre:",Sys.time()))
  # lecture referentiel valide en INPUT
  referentiel <- read.csv2(file_comptage)
  
  # test si RDS en output
  list_rds_files <- list.files(dir_rds, pattern = "*.RDS")
  len_list_rds_files = length(list_rds_files)
  
  if(len_list_rds_files > 0){
    lapply(1:len_list_rds_files, FUN = function(idx){
													fullname_rds = paste0(dir_rds, list_rds_files[idx])
													print( paste("Chargement de : ",fullname_rds) )
													load_rds_file_to_db(fullname_rds, referentiel, nom_schema, nom_table) 
													}
			)
  }else{ 
    stop("Aucun fichier RDS en sortie")
  }
  
  ##
  print(paste0("Fin de la partie remontee des donnees ",nom_table," :",Sys.time()))
  
  ## on ferme la log
  sink()
  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = paste0("Remontee des donnees ",nom_table),
                              heure_debut = heure_debut
  )   
}
