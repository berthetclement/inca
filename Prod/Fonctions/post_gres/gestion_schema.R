#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   gestion_schema                                          #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction gere la partie gestion des schemas :                                   #
#  #    1) On vide pubmed_arch  (s'il existe)                                               #      
#  #    2) on renome pubmed en pubmed_arch  (s'il existe)                                   #   
#  #    3) on renomme pubmed_tmp en pubmed                                                  #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #                                                                              ,         #
#  # Pas de parametres                                                                      #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  Les schemas geres                                                                    #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#



gestion_schema <- function() {


# On trace l'heure du début de l'étape  
heure_debut <- Sys.time()   
  
#### 00.01 Journal des messages de compilation, d'exécution et d'erreurs ----

journal("Gestion_schemas-Journal","Gestion_schemas-Journal")


print(paste0("Lancement de l'intégration des données de publications: ",Sys.time()))

#### 01. Suppression du schéma d'archive ----

# on sépare la requête qui vide le schéma "Archives" des autres car la première fois il n'y aura rien dans le schéma "Archives"

## on teste l'existence du schema tmps
  requete_existence_pubmed_tmp <- "SELECT exists(select schema_name FROM information_schema.schemata WHERE schema_name = 'pubmed_tmp');"
  test_verif_pubmed_tmp <- dbGetQuery(con,requete_existence_pubmed_tmp)

## si le schema archive existe, on le vide
  if (!(test_verif_pubmed_tmp$exists==FALSE)) {  
      ## on teste l existence du schema archive
      requete_existence_pubmed_arch <- "SELECT exists(select schema_name FROM information_schema.schemata WHERE schema_name = 'pubmed_arch');"
      test_verif_pubmed_arch <- dbGetQuery(con,requete_existence_pubmed_arch)
      ## s'il existe on le vide
      if (!(test_verif_pubmed_arch$exists==FALSE)) { 
              requete_fin_ARCH <- "DROP SCHEMA \"pubmed_arch\" CASCADE ;" 
              dbGetQuery(con,requete_fin_ARCH) } 
    
              ## on teste si le schema de production existe
              requete_existence_pubmed <- "SELECT exists(select schema_name FROM information_schema.schemata WHERE schema_name = 'pubmed');"
              test_verif_pubmed <- dbGetQuery(con,requete_existence_pubmed)

              ## si le schema de production existe on le renome en arch
              if (!(test_verif_pubmed$exists==FALSE)) {
                    requete_pubmed_Renommage_pubmed_arch <- "ALTER SCHEMA \"pubmed\" RENAME TO \"pubmed_arch\" ;"
                    dbGetQuery(con,requete_pubmed_Renommage_pubmed_arch) }

              ## on renomme le schema tmp en prod
              requete_pubmed_temp_Renommage_pubmed <- "ALTER SCHEMA \"pubmed_tmp\" RENAME TO \"pubmed\" ;"
              dbGetQuery(con,requete_pubmed_temp_Renommage_pubmed) 

}

  print(paste0("Fin de la gestion des schema: ",Sys.time()))
  
  ## on ferme la log
  sink()
  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = 'Gestion des schema ',
                              heure_debut = heure_debut
  )   
  
  
}