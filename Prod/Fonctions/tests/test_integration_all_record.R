#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                               test_integration_all_record                                 #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction a pour vocation de récupérer tester la bonne integration des donnees   #
#  #  des fichiers xml. Elle compare le nombre d'enfants du fichier au nombre integre       #      
#  #  lcorrectement dans le fichier de suivi.                                               #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #   dir_input                                                                                     #
#  #   file_input                    #
#  #   file_suivi                    #
#  #   liste_test                    #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   # un booleen qui dit si l'integration s est bien deroule                                 #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


test_integration_all_record <- function (dir_input,file_input,file_suivi,liste_test) {
  
  # On trace l'heure du début de l'étape  
  heure_debut <- Sys.time() 
  
  print(paste0("Lancement de la recuperation du test d'integration de ",file_input," : ",Sys.time()))
  
  
  ## on lit le fichier xml
  full_xml_database = xml2::read_xml(paste0(dir_input, file_input))
  
  ## on compte combien de record a intégrer
  nb_records = length(xml_children(full_xml_database))

  ## on lit le fichier de suivi
  fic_suivi <- read.csv2(paste0(DIR_OUTPUT,file_suivi))
  
  ## on filtre sur les lignes bien integrees
  for (i in (1:length(liste_test))) {
  fic_suivi <- fic_suivi %>%  
    filter(get(liste_test[i])==TRUE) 
  }
  
  ## on compte le nombre de lignes bien integrees
  nb_integres <- fic_suivi %>%  summarise(nb = n())
 
  ## on test
  test = (nb_records == nb_integres)
  
  ##
  if (test == TRUE) {
  print(paste0( "Toutes les données ",file_input," sont integrees "))
  } else
  {  print(paste0( "ATTENTION toutes les données ",file_input," ne sont pas integrees :",nb_integres," VS ",nb_records))}
  
  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = paste0('Test integration',file_input),
                              heure_debut = heure_debut)
  
}

