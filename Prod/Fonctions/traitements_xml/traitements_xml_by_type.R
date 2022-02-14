#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                traitements_xml_by_type                                    #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  # L'objectif de cette fonction est de structurer des donnees d un fichier XML            #
#  # Traite un type de données parmi supp, qual, desc et pa en écrivant les .rds            #
#  # correspondant aux .xml. C'est une fonction macro.                                      #
#  # Le traitement se déroule en 6 étapes :                                                 #
#  #  Etape 1 : Récupère la liste des variables définies dans le fichier de paramètres      #
#  #  Etape 2 : Supprime les fichiers .xml du répertoire contenant les .xml splittés        #
#  #  Etape 3 : Supprime les fichiers .rds du répertoire de sortie                          #
#  #  Etape 4 : Splitte le fichier .xml principal en N fichiers splittés                    #
#  #  Etape 5 : Liste les fichiers du répertoire contenant les .xml splittés                #
#  #  Etape 6 : Applique la fonction treat_xml_file() à chaque fichier .xml du répertoire   #
#  #           contenant les .xml splittés                                                  #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  type        : type de fichier : desc, supp, pa, qual                                  #
#  #  file_input  : nom du fichier source                                                   #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #   Fichiers RDS (selon la nom max d'enfants fixes par fichier) contenant les donnees   #
#   #   Structuree a partir du fichier XML                                                  #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


traitements_xml_by_type <- function(type,file_input){
  
  # On trace l'heure du début de l'étape  
  heure_debut <- Sys.time() 
  
  ## ouverture de la log
  journal(paste0("Traitements_fichiers_XML_",str_to_upper(type)),paste0("Traitements_fichiers_XML_",str_to_upper(type)))
  
  print(paste0("Lancement Traitements_fichiers_XML_",str_to_upper(type)))
  print("Heure lancement: ")
  print(as.character(Sys.time()))
  
  
  ## récupération des paramètres associés au fichier à traité
  
  dir_xml_splitted = get(paste("DIR_INPUT_XML", toupper(type), sep = "_"))
  nom_parent_id = get(paste("NOM_PARENT_ID", toupper(type), sep = "_"))
  nom_balise_id = get(paste("NOM_BALISE_ID", toupper(type), sep = "_"))
  dir_output_rds = get(paste("DIR_OUTPUT_RDS", toupper(type), sep = "_"))
  prefix_rds = paste0(toupper(type), "_")
  dir_output_suivi = DIR_OUTPUT_SUIVI
  file_suivi = get(paste("FILE_SUIVI", toupper(type), sep = "_"))
  check_function = get(paste("check_data", type, sep = "_"))
  
  ## on ré-initialise les répertoires et le fichier de suivi
  
  print(paste("Suppression des fichiers dans le répertoire : ", dir_xml_splitted))
  do.call(file.remove, list(list.files(dir_xml_splitted, full.names = TRUE)))
  
  print(paste("Suppression des fichiers dans le répertoire : ", dir_output_rds))
  do.call(file.remove, list(list.files(dir_output_rds, full.names = TRUE)))
  
  if(file.exists(paste0(dir_output_suivi, file_suivi))){
    print(paste("Suppression du fichier de suivi : ", file_suivi)) 
    file.remove(paste0(dir_output_suivi, file_suivi))
  }
  
  print("Création des fichiers xml splittés")
  run_xml_splitter(DIR_INPUT_DATA, file_input, dir_xml_splitted)
  
  lst_xml_splitted = list.files(dir_xml_splitted)

  lapply(1:length(lst_xml_splitted)
         , FUN = function(idx){
					           file_to_treat = lst_xml_splitted[idx]
                               print(paste("Traitement de :",file_to_treat))
                               xml_data = xml2::read_xml(paste0(dir_xml_splitted,file_to_treat))
                               treat_xml_file(xml_data, nom_parent_id, nom_balise_id, dir_output_rds, prefix_rds, dir_output_suivi, file_suivi, check_function, type)
                              }
  )

  ##
  print(paste0("Fin Traitements_fichiers_XML_",str_to_upper(type)))
  print("Heure lancement: ")
  print(as.character(Sys.time()))
  
  ## on ferme la log
  sink()
  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = paste0("Traitements_fichiers_XML_",str_to_upper(type)),
                              heure_debut = heure_debut
  )     
  
}
